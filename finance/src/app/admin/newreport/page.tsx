'use client';

import React, { useState, useEffect, useCallback } from 'react';
import {
  App,
  Button,
  DatePicker,
  Drawer,
  Select,
  Space,
  Table,
  Typography,
} from 'antd';
import type { TableColumnsType } from 'antd';
import dayjs, { Dayjs } from 'dayjs';
import * as XLSX from 'xlsx';

import { fetchReportDeliveries, fetchReportOrders, type Order } from './services/report.service';
import { fetchDrivers, fetchMerchants } from './services/delivery-users.service';
import type { Delivery } from './types/delivery';
import type { ReportRow, ReportType } from './types/report';

const { Title } = Typography;

function dedupeDeliveriesById(list: Delivery[]): Delivery[] {
  const m = new Map<number, Delivery>();
  for (const d of list) m.set(d.id, d);
  return Array.from(m.values());
}
const { RangePicker } = DatePicker;

const DRIVER_UNIT = 4000;
const MERCHANT_UNIT = 6000;

function unitForType(type: ReportType | 'now', isCustomer: boolean): number {
  const t = isCustomer ? 'now' : type;
  return t === 'driver' ? DRIVER_UNIT : MERCHANT_UNIT;
}

function isStatus3(d: Delivery): boolean {
  return d.status === 3 || d.status === '3';
}

/** «Хаягаар очсон» — зөвхөн төлөв 7 (5 нь татгалзсан гэх мэт, энд тоологдохгүй). */
function isStatus7AddressVisit(d: Delivery): boolean {
  return d.status === 7 || d.status === '7';
}

function getStoredUser(): { id?: number; role?: number; role_id?: number; username?: string } | null {
  if (typeof window === 'undefined') return null;
  try {
    const raw = localStorage.getItem('user');
    if (!raw) return null;
    return JSON.parse(raw);
  } catch {
    return null;
  }
}

const drawerDeliveryColumns: TableColumnsType<Delivery> = [
  { title: 'ID', dataIndex: 'id', width: 72, fixed: 'left' },
  { title: 'Дэлгүүр', width: 120, render: (_, r) => r.merchant?.username ?? '-' },
  { title: 'Хаяг', dataIndex: 'address', ellipsis: true },
  { title: 'Тайлбар', dataIndex: 'comment', width: 160, ellipsis: true, render: (v) => v || '-' },
  { title: 'Утас', dataIndex: 'phone', width: 112 },
  {
    title: 'Үнэ',
    dataIndex: 'price',
    width: 96,
    render: (v: number) => `${Number(v ?? 0).toLocaleString()} ₮`,
  },
  {
    title: 'Төлөв',
    width: 120,
    render: (_: unknown, r: Delivery) => r.status_name?.status ?? String(r.status),
  },
  {
    title: 'Хүргэгдсэн',
    width: 140,
    render: (_: unknown, r: Delivery) =>
      r.delivered_at ? dayjs(r.delivered_at).format('YYYY-MM-DD HH:mm') : '-',
  },
];

export default function NewReportPage() {
  const { message: msg } = App.useApp();
  const [loading, setLoading] = useState(false);
  const [reportData, setReportData] = useState<ReportRow[]>([]);
  const [user, setUser] = useState<ReturnType<typeof getStoredUser>>(null);
  const isCustomer = user?.role === 2 || user?.role_id === 2;
  const [dateRange, setDateRange] = useState<[Dayjs, Dayjs]>([dayjs(), dayjs()]);
  const [reportType, setReportType] = useState<ReportType>('driver');
  const [selectedId, setSelectedId] = useState<number | null>(null);
  const [drivers, setDrivers] = useState<{ id: number; username: string }[]>([]);
  const [merchants, setMerchants] = useState<{ id: number; username: string }[]>([]);
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [drawerTitle, setDrawerTitle] = useState('');
  const [drawerDeliveries, setDrawerDeliveries] = useState<Delivery[]>([]);

  useEffect(() => {
    document.title = 'Тайлан (шинэ)';
  }, []);

  useEffect(() => {
    setUser(getStoredUser());
  }, []);

  useEffect(() => {
    if (isCustomer) return;
    (async () => {
      try {
        const [d, m] = await Promise.all([
          fetchDrivers().catch(() => []),
          fetchMerchants().catch(() => []),
        ]);
        setDrivers(d);
        setMerchants(m);
      } catch (e) {
        console.error(e);
      }
    })();
  }, [isCustomer]);

  useEffect(() => {
    setSelectedId(null);
  }, [reportType]);

  const groupDeliveriesByType = useCallback(
    (deliveries: Delivery[], type: ReportType, cust: boolean): Record<string, Delivery[]> => {
      const grouped: Record<string, Delivery[]> = {};
      deliveries.forEach((delivery) => {
        let key: string;
        if (cust) {
          key = 'merchant_summary';
        } else if (type === 'driver') {
          key = delivery.driver?.username || 'No Driver';
        } else {
          key = delivery.merchant?.username || 'Unknown Merchant';
        }
        if (!grouped[key]) grouped[key] = [];
        grouped[key].push(delivery);
      });
      return grouped;
    },
    []
  );

  const groupOrdersByType = useCallback(
    (orders: Order[], type: ReportType, cust: boolean): Record<string, Order[]> => {
      const grouped: Record<string, Order[]> = {};
      orders.forEach((order) => {
        let key: string;
        if (cust) {
          key = 'merchant_summary';
        } else if (type === 'driver') {
          key = order.driver?.username || 'No Driver';
        } else {
          key = order.merchant?.username || 'Unknown Merchant';
        }
        if (!grouped[key]) grouped[key] = [];
        grouped[key].push(order);
      });
      return grouped;
    },
    []
  );

  const loadReportData = async () => {
    if (!dateRange[0] || !dateRange[1]) {
      msg.error('Огноо сонгоно уу');
      return;
    }
    setLoading(true);
    try {
      const startDate = dateRange[0].format('YYYY-MM-DD');
      const endDate = dateRange[1].format('YYYY-MM-DD');
      const filters: {
        startDate: string;
        endDate: string;
        driverId?: number;
        merchantId?: number;
      } = { startDate, endDate };

      if (isCustomer && user?.id) {
        filters.merchantId = user.id;
      } else {
        if (reportType === 'driver' && selectedId) filters.driverId = selectedId;
        else if (
          (reportType === 'now' || reportType === 'later' || reportType === 'merchant') &&
          selectedId
        ) {
          filters.merchantId = selectedId;
        }
      }

      const [deliveries, orders] = await Promise.all([
        fetchReportDeliveries(filters),
        fetchReportOrders(filters),
      ]);

      const filteredDeliveries = deliveries.filter((d) => isStatus3(d) || isStatus7AddressVisit(d));
      const status3Deliveries = filteredDeliveries.filter(isStatus3);
      const addressVisitDeliveries = filteredDeliveries.filter(isStatus7AddressVisit);

      let deliveriesToProcess = status3Deliveries;
      let addressVisitDeliveriesToProcess = addressVisitDeliveries;

      if (!isCustomer && (reportType === 'now' || reportType === 'later')) {
        const merchantGroups: Record<string, Delivery[]> = {};
        status3Deliveries.forEach((delivery) => {
          const key = delivery.merchant?.username || 'Unknown Merchant';
          if (!merchantGroups[key]) merchantGroups[key] = [];
          merchantGroups[key].push(delivery);
        });

        deliveriesToProcess = [];
        Object.entries(merchantGroups).forEach(([, merchantDeliveries]) => {
          const totalPrice = merchantDeliveries.reduce(
            (sum, d) => sum + parseFloat(String(d.price)),
            0
          );
          const salary = merchantDeliveries.length * MERCHANT_UNIT;
          const difference = totalPrice - salary;
          if (
            (reportType === 'now' && difference >= 0) ||
            (reportType === 'later' && difference < 0)
          ) {
            deliveriesToProcess.push(...merchantDeliveries);
          }
        });

        const filteredMerchantNames = new Set(
          Object.keys(merchantGroups).filter((merchantName) => {
            const merchantDeliveries = merchantGroups[merchantName];
            const totalPrice = merchantDeliveries.reduce(
              (sum, d) => sum + parseFloat(String(d.price)),
              0
            );
            const salary = merchantDeliveries.length * MERCHANT_UNIT;
            const difference = totalPrice - salary;
            return (
              (reportType === 'now' && difference >= 0) ||
              (reportType === 'later' && difference < 0)
            );
          })
        );

        addressVisitDeliveriesToProcess = addressVisitDeliveries.filter((d) => {
          const merchantName = d.merchant?.username || 'Unknown Merchant';
          return filteredMerchantNames.has(merchantName);
        });
      }

      const typeToUse: ReportType = isCustomer ? 'now' : reportType;
      const groupedData = groupDeliveriesByType(deliveriesToProcess, typeToUse, isCustomer);
      const groupedStatus5Data = groupDeliveriesByType(
        addressVisitDeliveriesToProcess,
        typeToUse,
        isCustomer
      );
      const groupedOrders = groupOrdersByType(orders, typeToUse, isCustomer);

      const unitOrder = unitForType(typeToUse, isCustomer);
      const pricePerDelivery = typeToUse === 'driver' ? DRIVER_UNIT : MERCHANT_UNIT;

      let rowKeySeq = 0;
      const nextRowKey = () => `r-${rowKeySeq++}`;

      const reportRows: ReportRow[] = Object.entries(groupedData).map(([id, groupDeliveries]) => {
        const deliveredCount = groupDeliveries.length;
        const totalPrice = groupDeliveries.reduce((sum, d) => sum + parseFloat(String(d.price)), 0);
        const status5GroupDeliveries = groupedStatus5Data[id] || [];
        const status5Count = status5GroupDeliveries.length;

        let salary = deliveredCount * pricePerDelivery;
        if (typeToUse === 'driver') {
          salary += status5Count * DRIVER_UNIT;
        } else {
          salary += status5Count * MERCHANT_UNIT;
        }

        const groupOrders = groupedOrders[id] || [];
        const orderCount = groupOrders.length;
        salary += orderCount * unitOrder;

        const name =
          typeToUse === 'driver'
            ? groupDeliveries[0]?.driver?.username || 'Unknown'
            : isCustomer && user?.username
              ? user.username
              : groupDeliveries[0]?.merchant?.username || 'Unknown';

        return {
          rowKeyId: nextRowKey(),
          dateRange: `${startDate} ~ ${endDate}`,
          name,
          deliveredDeliveries: deliveredCount,
          totalDeliveries: deliveredCount + status5Count,
          totalPrice,
          salary,
          status5Deliveries: status5Count,
          status5MerchantAmount: 0,
          status5DriverAmount: 0,
          orderCount,
          deliveredDetails: [...groupDeliveries],
          addressVisitDetails: [...status5GroupDeliveries],
        };
      });

      Object.entries(groupedStatus5Data).forEach(([id, status5GroupDeliveries]) => {
        if (!groupedData[id]) {
          const status5Count = status5GroupDeliveries.length;
          let salary = 0;
          if (typeToUse === 'driver') {
            salary = status5Count * DRIVER_UNIT;
          } else {
            salary = status5Count * MERCHANT_UNIT;
          }
          const groupOrders = groupedOrders[id] || [];
          const orderCount = groupOrders.length;
          salary += orderCount * unitOrder;

          const name =
            typeToUse === 'driver'
              ? status5GroupDeliveries[0]?.driver?.username || 'Unknown'
              : isCustomer && user?.username
                ? user.username
                : status5GroupDeliveries[0]?.merchant?.username || 'Unknown';

          reportRows.push({
            rowKeyId: nextRowKey(),
            dateRange: `${startDate} ~ ${endDate}`,
            name,
            deliveredDeliveries: 0,
            totalDeliveries: status5Count,
            totalPrice: 0,
            salary,
            status5Deliveries: status5Count,
            status5MerchantAmount: 0,
            status5DriverAmount: 0,
            orderCount,
            deliveredDetails: [],
            addressVisitDetails: [...status5GroupDeliveries],
          });
        }
      });

      Object.entries(groupedOrders).forEach(([id, groupOrders]) => {
        if (!groupedData[id] && !groupedStatus5Data[id]) {
          const orderCount = groupOrders.length;
          const salary = orderCount * unitOrder;
          const name =
            typeToUse === 'driver'
              ? groupOrders[0]?.driver?.username || 'Unknown'
              : isCustomer && user?.username
                ? user.username
                : groupOrders[0]?.merchant?.username || 'Unknown';

          reportRows.push({
            rowKeyId: nextRowKey(),
            dateRange: `${startDate} ~ ${endDate}`,
            name,
            deliveredDeliveries: 0,
            totalDeliveries: 0,
            totalPrice: 0,
            salary,
            status5Deliveries: 0,
            status5MerchantAmount: 0,
            status5DriverAmount: 0,
            orderCount,
            deliveredDetails: [],
            addressVisitDetails: [],
          });
        }
      });

      setReportData(reportRows);
    } catch (e) {
      console.error(e);
      msg.error(e instanceof Error ? e.message : 'Алдаа');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (user !== null) {
      void loadReportData();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- initial + user load like mgl
  }, [user]);

  const formatCurrency = (amount: number) =>
    new Intl.NumberFormat('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 }).format(
      amount
    );

  const totals = reportData.reduce(
    (acc, row) => {
      acc.deliveredDeliveries += row.deliveredDeliveries;
      acc.totalDeliveries += row.totalDeliveries;
      acc.totalPrice += row.totalPrice;
      acc.salary += row.salary;
      acc.difference += row.totalPrice - row.salary;
      acc.status5Deliveries += row.status5Deliveries;
      acc.orderCount += row.orderCount || 0;
      return acc;
    },
    {
      deliveredDeliveries: 0,
      totalDeliveries: 0,
      totalPrice: 0,
      salary: 0,
      difference: 0,
      status5Deliveries: 0,
      orderCount: 0,
    }
  );

  const exportToExcel = () => {
    if (reportData.length === 0) {
      msg.warning('Экспортлох өгөгдөл байхгүй');
      return;
    }
    const typeToUse = isCustomer ? 'now' : reportType;
    const headers = ['Огноо'];
    if (!isCustomer) {
      headers.push(typeToUse === 'driver' ? 'Жолооч' : 'Дэлгүүр');
    }
    headers.push(
      'Нийт хүргэлт',
      'Хүргэсэн хүргэлт',
      'Хаягаар очсон',
      'Захиалгын тоо',
      'Нийт тооцоо',
      'Цалин',
      'зөрүү'
    );

    const excelData: (string | number)[][] = [
      headers,
      ...reportData.map((row) => {
        const rowData: (string | number)[] = [row.dateRange];
        if (!isCustomer) rowData.push(row.name);
        rowData.push(
          row.totalDeliveries,
          row.deliveredDeliveries,
          row.status5Deliveries,
          row.orderCount || 0,
          row.totalPrice,
          row.salary,
          row.totalPrice - row.salary
        );
        return rowData;
      }),
      (() => {
        const totalsRow: (string | number)[] = ['Нийт'];
        if (!isCustomer) totalsRow.push('');
        totalsRow.push(
          totals.totalDeliveries,
          totals.deliveredDeliveries,
          totals.status5Deliveries,
          totals.orderCount,
          totals.totalPrice,
          totals.salary,
          totals.difference
        );
        return totalsRow;
      })(),
    ];

    const wb = XLSX.utils.book_new();
    const ws = XLSX.utils.aoa_to_sheet(excelData);
    const columnWidths = [{ wch: 20 }];
    if (!isCustomer) columnWidths.push({ wch: 20 });
    columnWidths.push(
      { wch: 15 },
      { wch: 18 },
      { wch: 18 },
      { wch: 18 },
      { wch: 15 },
      { wch: 15 },
      { wch: 15 }
    );
    ws['!cols'] = columnWidths;
    XLSX.utils.book_append_sheet(wb, ws, 'Report');
    const startDate = dateRange[0].format('YYYY-MM-DD');
    const endDate = dateRange[1].format('YYYY-MM-DD');
    XLSX.writeFile(wb, `Report_${startDate}_${endDate}_${typeToUse}.xlsx`);
    msg.success('Excel татагдлаа');
  };

  const typeToUse = isCustomer ? 'now' : reportType;
  const nameColTitle = typeToUse === 'driver' ? 'Жолооч' : 'Дэлгүүр';

  const openDeliveryDrawer = (title: string, list: Delivery[]) => {
    if (list.length === 0) return;
    setDrawerTitle(title);
    setDrawerDeliveries(list);
    setDrawerOpen(true);
  };

  const exportDrawerDeliveriesToExcel = () => {
    if (drawerDeliveries.length === 0) {
      msg.warning('Экспортлох хүргэлт байхгүй');
      return;
    }
    const rows = drawerDeliveries.map((d) => ({
      ID: d.id,
      Дэлгүүр: d.merchant?.username ?? '',
      Хаяг: d.address ?? '',
      Тайлбар: d.comment ?? '',
      Утас: d.phone ?? '',
      Үнэ: Number(d.price ?? 0),
      Төлөв: d.status_name?.status ?? String(d.status),
      'Хүргэгдсэн огноо': d.delivered_at ? dayjs(d.delivered_at).format('YYYY-MM-DD HH:mm') : '',
    }));
    const ws = XLSX.utils.json_to_sheet(rows);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Хүргэлт');
    const safe = drawerTitle.replace(/[/\\?%*:|"<>]/g, '_').slice(0, 80);
    XLSX.writeFile(wb, `deliveries_${safe}_${dayjs().format('YYYYMMDD-HHmmss')}.xlsx`);
    msg.success('Excel татагдлаа');
  };

  const columns: TableColumnsType<ReportRow> = [
    { title: 'Огноо', dataIndex: 'dateRange', key: 'dr' },
    ...(!isCustomer ? [{ title: nameColTitle, dataIndex: 'name', key: 'name' }] : []),
    { title: 'Нийт хүргэлт', dataIndex: 'totalDeliveries', key: 'td' },
    {
      title: 'Хүргэсэн хүргэлт',
      dataIndex: 'deliveredDeliveries',
      key: 'dd',
      render: (v: number, row: ReportRow) =>
        v > 0 ? (
          <Button
            type="link"
            size="small"
            style={{ padding: 0, height: 'auto' }}
            onClick={() =>
              openDeliveryDrawer(`${row.name} — Хүргэсэн хүргэлт`, row.deliveredDetails)
            }
          >
            {v}
          </Button>
        ) : (
          v
        ),
    },
    {
      title: 'Хаягаар очсон',
      dataIndex: 'status5Deliveries',
      key: 's5',
      render: (v: number, row: ReportRow) =>
        v > 0 ? (
          <Button
            type="link"
            size="small"
            style={{ padding: 0, height: 'auto' }}
            onClick={() =>
              openDeliveryDrawer(`${row.name} — Хаягаар очсон`, row.addressVisitDetails)
            }
          >
            {v}
          </Button>
        ) : (
          v
        ),
    },
    { title: 'Захиалгын тоо', dataIndex: 'orderCount', key: 'oc' },
    {
      title: 'Нийт тооцоо',
      dataIndex: 'totalPrice',
      key: 'tp',
      render: (v: number) => `${formatCurrency(v)} ₮`,
    },
    {
      title: 'Цалин',
      dataIndex: 'salary',
      key: 'sal',
      render: (v: number) => `${formatCurrency(v)} ₮`,
    },
    {
      title: 'зөрүү',
      key: 'diff',
      render: (_, row) => `${formatCurrency(row.totalPrice - row.salary)} ₮`,
    },
  ];

  return (
    <div style={{ maxWidth: 1400 }}>
      <Title level={4} style={{ marginBottom: 16 }}>
        Тайлан (шинэ) — жолооч {DRIVER_UNIT}₮, дэлгүүр {MERCHANT_UNIT}₮
      </Title>

      <Space wrap style={{ marginBottom: 16 }} align="center">
        <RangePicker
          value={dateRange}
          onChange={(v) => {
            if (v?.[0] && v[1]) setDateRange([v[0], v[1]]);
          }}
        />
        {!isCustomer && (
          <Select
            style={{ width: 160 }}
            value={reportType}
            onChange={(v) => setReportType(v as ReportType)}
            options={[
              { value: 'driver', label: 'Жолооч' },
              { value: 'now', label: 'Одоо' },
              { value: 'later', label: 'Дараа' },
              { value: 'merchant', label: 'Дэлгүүр' },
            ]}
          />
        )}
        {!isCustomer &&
          (reportType === 'driver' ? (
            <Select
              showSearch
              allowClear
              placeholder="Бүх жолооч"
              style={{ width: 220 }}
              value={selectedId ?? undefined}
              onChange={(v) => setSelectedId(typeof v === 'number' ? v : null)}
              options={drivers.map((d) => ({ value: d.id, label: d.username }))}
              optionFilterProp="label"
            />
          ) : (
            <Select
              showSearch
              allowClear
              placeholder="Бүх дэлгүүр"
              style={{ width: 220 }}
              value={selectedId ?? undefined}
              onChange={(v) => setSelectedId(typeof v === 'number' ? v : null)}
              options={merchants.map((m) => ({ value: m.id, label: m.username }))}
              optionFilterProp="label"
            />
          ))}
        <Button type="primary" onClick={() => void loadReportData()} loading={loading}>
          Хайх
        </Button>
        <Button onClick={exportToExcel} disabled={loading || reportData.length === 0}>
          Excel
        </Button>
      </Space>

      <Table<ReportRow>
        rowKey={(r) => r.rowKeyId}
        loading={loading}
        columns={columns}
        dataSource={reportData}
        pagination={false}
        summary={() =>
          reportData.length > 0 ? (
            <Table.Summary.Row>
              <Table.Summary.Cell index={0} colSpan={1}>
                <strong>Нийт</strong>
              </Table.Summary.Cell>
              {!isCustomer ? (
                <Table.Summary.Cell index={1} colSpan={1} />
              ) : null}
              <Table.Summary.Cell index={2}>
                <strong>{totals.totalDeliveries}</strong>
              </Table.Summary.Cell>
              <Table.Summary.Cell index={3}>
                {totals.deliveredDeliveries > 0 ? (
                  <Button
                    type="link"
                    size="small"
                    style={{ padding: 0, height: 'auto' }}
                    onClick={() =>
                      openDeliveryDrawer(
                        'Нийт — Хүргэсэн хүргэлт',
                        dedupeDeliveriesById(reportData.flatMap((r) => r.deliveredDetails))
                      )
                    }
                  >
                    <strong>{totals.deliveredDeliveries}</strong>
                  </Button>
                ) : (
                  <strong>{totals.deliveredDeliveries}</strong>
                )}
              </Table.Summary.Cell>
              <Table.Summary.Cell index={4}>
                {totals.status5Deliveries > 0 ? (
                  <Button
                    type="link"
                    size="small"
                    style={{ padding: 0, height: 'auto' }}
                    onClick={() =>
                      openDeliveryDrawer(
                        'Нийт — Хаягаар очсон',
                        dedupeDeliveriesById(reportData.flatMap((r) => r.addressVisitDetails))
                      )
                    }
                  >
                    <strong>{totals.status5Deliveries}</strong>
                  </Button>
                ) : (
                  <strong>{totals.status5Deliveries}</strong>
                )}
              </Table.Summary.Cell>
              <Table.Summary.Cell index={5}>
                <strong>{totals.orderCount}</strong>
              </Table.Summary.Cell>
              <Table.Summary.Cell index={6}>
                <strong>{formatCurrency(totals.totalPrice)} ₮</strong>
              </Table.Summary.Cell>
              <Table.Summary.Cell index={7}>
                <strong>{formatCurrency(totals.salary)} ₮</strong>
              </Table.Summary.Cell>
              <Table.Summary.Cell index={8}>
                <strong>{formatCurrency(totals.difference)} ₮</strong>
              </Table.Summary.Cell>
            </Table.Summary.Row>
          ) : null
        }
      />

      <Drawer
        title={drawerTitle}
        placement="bottom"
        height="70%"
        open={drawerOpen}
        onClose={() => setDrawerOpen(false)}
        destroyOnClose
        styles={{ body: { paddingTop: 8 } }}
        extra={
          <Button type="primary" onClick={exportDrawerDeliveriesToExcel} disabled={drawerDeliveries.length === 0}>
            Excel
          </Button>
        }
      >
        <Table<Delivery>
          size="small"
          rowKey="id"
          pagination={false}
          dataSource={drawerDeliveries}
          scroll={{ x: 1120, y: 'calc(70vh - 200px)' }}
          columns={drawerDeliveryColumns}
        />
      </Drawer>
    </div>
  );
}
