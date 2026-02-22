'use client';

import React, { useState, useEffect, useMemo } from 'react';
import { Table, Button, Space, Select, Tag, Switch, DatePicker, notification, InputNumber } from 'antd';
import type { TableColumnsType } from 'antd';
import dayjs, { Dayjs } from 'dayjs';
import isSameOrAfter from 'dayjs/plugin/isSameOrAfter';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';
import { CloseOutlined, DownloadOutlined } from '@ant-design/icons';
import * as XLSX from 'xlsx';

dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);

const { Option } = Select;
const { RangePicker } = DatePicker;

function getCurrentUser(): { id: number; role: number; name?: string } | null {
  if (typeof window === 'undefined') return null;
  try {
    const raw = localStorage.getItem('user');
    if (!raw) return null;
    const user = JSON.parse(raw);
    return user && user.id != null && user.role != null ? user : null;
  } catch {
    return null;
  }
}

// ---- Delivery interface ----
interface Delivery {
  id: number;
  phone: string;
  address: string;
  status: number | string;
  price: number;
  comment: string;
  driver: { username: string };
  createdAt: string;
  merchant: { username: string };
  status_name: {
    status: string;
    color: string;
  };
  delivered_at?: string;
  delivery_price?: number;
}

// Delivery Table Columns (base; merchant view excludes Мерчанд нэр and Жолооч нэр)
const deliveryColumnsBase: TableColumnsType<Delivery> = [
  {
    title: 'Үүссэн огноо',
    dataIndex: 'createdAt',
    render: (text: string) => dayjs(text).format('YYYY-MM-DD hh:mm A'),
  },
  {
    title: 'Хүргэсэн огноо',
    dataIndex: 'delivered_at',
    render: (text: string) => text ? dayjs(text).format('YYYY-MM-DD hh:mm A') : '-',
  },
  {
    title: 'Мерчанд нэр',
    dataIndex: ['merchant', 'username'],
    render: (_, record) => record.merchant?.username || '-',
    key: 'merchant',
  },
  { title: 'Утас', dataIndex: 'phone' },
  { title: 'Хаяг', dataIndex: 'address' },
  {
    title: 'Төлөв',
    dataIndex: 'status_name',
    render: (status_name: { status: string; color: string }) => (
      <Tag color={status_name.color}>{status_name.status}</Tag>
    ),
  },
  {
    title: 'Үнэ',
    dataIndex: 'price',
    render: (price: number) => price.toLocaleString() + ' ₮',
  },
  { title: 'Тайлбар', dataIndex: 'comment' },
  {
    title: 'Жолооч нэр',
    dataIndex: ['driver', 'username'],
    render: (_, record) => record.driver?.username || '-',
    key: 'driver',
  },
];

// ---- Summary interface ----
type SummaryType = {
  key: string;
  driverName: string;
  totalPrice: number;
  forDriver: number;
  account: number;
  numberDelivery?: number;
  extraDeduction?: number; // editable: deducted from нийт үнэ for Зөрүү
};

type OptionType = {
  id: string;
  username: string;
};

export default function DeliveryPage() {
  const [currentUser, setCurrentUser] = useState<{ id: number; role: number; name?: string } | null>(null);

  useEffect(() => {
    setCurrentUser(getCurrentUser());
  }, []);

  const isMerchant = currentUser?.role === 2;
  const merchantId = isMerchant ? String(currentUser!.id) : null;

  // Delivery states
  const [pagination, setPagination] = useState({ current: 1, pageSize: 100, total: 0 });
  const [loadingDeliveries, setLoadingDeliveries] = useState(false);

  // Summary & filters (merchant: pre-set to self once we know user)
  const [merchantFilter, setMerchantFilter] = useState<string | null>(null);
  const [secondOptions, setSecondOptions] = useState<OptionType[]>([]);
  const [secondValue, setSecondValue] = useState<string | null>(null);

  useEffect(() => {
    if (currentUser?.role === 2) {
      setMerchantFilter('1');
      setSecondValue(String(currentUser.id));
    }
  }, [currentUser]);
  const [loadingOptions, setLoadingOptions] = useState(false);
  const [dateRange, setDateRange] = useState<[Dayjs | null, Dayjs | null]>([null, null]);
  const [isReportMergeMode, setIsReportMergeMode] = useState(true);
  const [summary, setSummary] = useState<SummaryType | null>(null);
  const [fetchingSummary, setFetchingSummary] = useState(false);
  const [fetchError, setFetchError] = useState<string | null>(null);
  const [tableData, setTableData] = useState<SummaryType[]>([]);
  const [loading, setLoading] = useState(false);
  const [deliveryList, setDeliveryList] = useState<Delivery[]>([]);
  const [selectedRowKeys, setSelectedRowKeys] = useState<React.Key[]>([]);

  const summaryColumns: TableColumnsType<SummaryType> = useMemo(() => {
    const base = [
      { title: 'нэр', dataIndex: 'driverName', key: 'driverName' },
      {
        title: 'Нийт хүргэлт',
        dataIndex: 'numberDelivery',
        key: 'numberDelivery',
        render: (value?: number) => value?.toLocaleString() ?? '—',
      },
      {
        title: 'Нийт үнэ',
        dataIndex: 'totalPrice',
        key: 'totalPrice',
        render: (value: number, record: SummaryType) => {
          const deduction = record.extraDeduction ?? 0;
          const afterDeduction = value - deduction;
          if (deduction > 0) {
            return (
              <span>
                <span style={{ textDecoration: 'line-through', color: '#999', marginRight: 4 }}>
                  {value.toLocaleString()} ₮
                </span>
                <span>{afterDeduction.toLocaleString()} ₮</span>
              </span>
            );
          }
          return <span>{value.toLocaleString()} ₮</span>;
        },
      },
      {
        title: isMerchant ? 'Компанид олгох' : 'Жолоочид олгох',
        dataIndex: 'forDriver',
        key: 'forDriver',
        render: (value: number) => value.toLocaleString() + ' ₮',
      },
      ...(!isMerchant
        ? [
            {
              title: 'Дутуу',
              key: 'extraDeduction',
              render: (_: unknown, record: SummaryType) => (
                <InputNumber
                  min={0}
                  max={record.totalPrice ?? 0}
                  value={record.extraDeduction ?? 0}
                  onChange={(val) => {
                    const v = typeof val === 'number' ? val : 0;
                    setTableData((prev) =>
                      prev.map((row) =>
                        row.key === record.key ? { ...row, extraDeduction: v } : row
                      )
                    );
                  }}
                  style={{ width: 120 }}
                  addonAfter="₮"
                />
              ),
            },
          ]
        : []),
      {
        title: 'Зөрүү',
        key: 'account',
        render: (_: unknown, record: SummaryType) => {
          const diff = record.totalPrice - record.forDriver;
          return <span>{diff.toLocaleString()} ₮</span>;
        },
      },
    ];
    return base as TableColumnsType<SummaryType>;
  }, [isMerchant]);

  const deliveryColumns = useMemo(
    () =>
      isMerchant
        ? deliveryColumnsBase.filter(
            (col) => col.title !== 'Мерчанд нэр' && col.title !== 'Жолооч нэр'
          )
        : deliveryColumnsBase,
    [isMerchant]
  );

 const rowSelection = {
  selectedRowKeys,
  onChange: (selectedKeys: React.Key[], selectedRows: Delivery[]) => {
    setSelectedRowKeys(selectedKeys);

    // Calculate total price - only include deliveries with status 3
    const totalPrice = selectedRows.reduce((sum, row) => {
      return row.status === 3 ? sum + Number(row.price) : sum;
    }, 0);

    const numberDelivery = selectedRows.length;
    const isMerchantFee = merchantFilter === '1';
    // Merchant fee = sum(delivery_price); driver fee = sum(delivery_price - 2000)
    const getDeliveryPrice = (row: Delivery) => {
      const v = row.delivery_price;
      if (v == null) return 6000;
      const n = Number(v);
      return Number.isNaN(n) ? 6000 : n;
    };
    const totalFee = isMerchantFee
      ? selectedRows.reduce((sum, row) => sum + getDeliveryPrice(row), 0)
      : selectedRows.reduce((sum, row) => sum + (getDeliveryPrice(row) - 2000), 0);
    const account = totalPrice - totalFee;

    const driverName = isMerchantFee
      ? selectedRows[0]?.merchant?.username || ''
      : selectedRows[0]?.driver?.username || '';

    setTableData([
      {
        key: 'summary',
        driverName,
        totalPrice,
        forDriver: totalFee,
        account: totalPrice - totalFee,
        numberDelivery,
        extraDeduction: 0,
      },
    ]);
  },
};

  const openNotification = (type: 'success' | 'error', messageText: string) => {
    notification.open({
      message: null,
      description: <div style={{ color: 'white' }}>{messageText}</div>,
      duration: 4,
      style: {
        backgroundColor: type === 'success' ? '#52c41a' : '#ff4d4f',
        borderRadius: '4px',
      },
      closeIcon: <CloseOutlined style={{ color: '#fff' }} />,
    });
  };
  
  const handleReportMerge = async () => {
  if (!selectedRowKeys || selectedRowKeys.length === 0) {
    alert("Please select at least one delivery to report.");
    return;
  }
  if (!dateRange[0] || !dateRange[1]) {
    openNotification('error', 'Эхлэх болон дуусах огноо сонгоно уу.');
    return;
  }

  try {
    setLoading(true);

    const endpoint = (isMerchant || merchantFilter === '1')
      ? `${process.env.NEXT_PUBLIC_API_URL}/api/report/merchant`
      : `${process.env.NEXT_PUBLIC_API_URL}/api/report/driver`;

    const summaryRow = tableData[0];
    const extraDeduction = summaryRow?.extraDeduction ?? 0;

    const body: Record<string, unknown> = {
      delivery_ids: selectedRowKeys,
      start_date: dateRange[0].format('YYYY-MM-DD'),
      end_date: dateRange[1].format('YYYY-MM-DD'),
      extra_deduction: extraDeduction,
      total_price: summaryRow?.totalPrice,
      for_driver: summaryRow?.forDriver,
      number_delivery: summaryRow?.numberDelivery,
      account: (summaryRow?.totalPrice ?? 0) - (summaryRow?.forDriver ?? 0),
    };
    if (merchantFilter === '2' && effectiveSecondValue) {
      body.driver_id = Number(effectiveSecondValue);
    }

    const response = await fetch(endpoint, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });

    const result = await response.json();

    if (!response.ok || !result.success) {
      throw new Error(result.message || 'Failed to report deliveries.');
    }

    openNotification('success', 'Тайлан амжилттай нийллээ.');
    setSelectedRowKeys([]);
    setTableData([]);

  } catch (error: any) {
    console.error("Error during report merge:", error);
    openNotification('error', `Алдаа гарлаа: ${error.message || 'Unknown error'}`);
  } finally {
    setLoading(false);
  }
};

  // Excel export function with proper numeric formatting
  const exportToExcel = () => {
    if (deliveryList.length === 0) {
      openNotification('error', 'Экспортлох өгөгдөл байхгүй байна');
      return;
    }

    try {
      // Prepare data for export (excluding driver information)
      const dataForExport = deliveryList.map(delivery => ({
        'Үүссэн огноо': dayjs(delivery.createdAt).format('YYYY-MM-DD hh:mm A'),
        'Хүргэсэн огноо': delivery.delivered_at ? dayjs(delivery.delivered_at).format('YYYY-MM-DD hh:mm A') : '-',
        'Мерчанд нэр': delivery.merchant?.username || '-',
        'Утас': delivery.phone,
        'Хаяг': delivery.address,
        'Төлөв': delivery.status_name?.status || '',
        // Ensure price is exported as a number for Excel to recognize it
        'Үнэ': delivery.price,
        'Тайлбар': delivery.comment,
      }));

      // Create worksheet with column types specified
      const ws = XLSX.utils.json_to_sheet(dataForExport);
      
      // Set column widths for better readability
      const colWidths = [
        { wch: 20 }, // Үүссэн огноо
        { wch: 20 }, // Хүргэсэн огноо
        { wch: 20 }, // Мерчанд нэр
        { wch: 15 }, // Утас
        { wch: 30 }, // Хаяг
        { wch: 15 }, // Төлөв
        { wch: 15 }, // Үнэ (this will be formatted as number)
        { wch: 30 }, // Тайлбар
      ];
      ws['!cols'] = colWidths;
      
      // Format the price column as number with 2 decimal places
      const range = XLSX.utils.decode_range(ws['!ref'] || 'A1');
      for (let R = range.s.r + 1; R <= range.e.r; ++R) {
        const priceCellRef = XLSX.utils.encode_cell({r: R, c: 6}); // Column G (7th column, 0-indexed 6)
        if (ws[priceCellRef]) {
          // Ensure the cell is treated as a number
          ws[priceCellRef].t = 'n';
          // Format as number with 2 decimal places
          ws[priceCellRef].z = '#,##0.00';
        }
      }
      
      // Create workbook
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, 'Хүргэлтийн мэдээлэл');
      
      // Generate Excel file
      const fileName = `delivery_report_${dayjs().format('YYYY-MM-DD_HH-mm')}.xlsx`;
      XLSX.writeFile(wb, fileName);
      
      openNotification('success', 'Excel файл амжилттай экспортлогдлоо');
    } catch (error) {
      console.error('Excel export error:', error);
      openNotification('error', 'Excel файл экспортлоход алдаа гарлаа');
    }
  };

  // Fetch options when merchantFilter changes (skip for merchant – they see only their data)
  useEffect(() => {
    document.title = 'Тайлан нийлэх';

    if (isMerchant) {
      setSecondOptions([]);
      return;
    }

    const fetchOptions = async () => {
      if (!merchantFilter) {
        setSecondOptions([]);
        return;
      }
      setLoadingOptions(true);
      try {
        const url =
          merchantFilter === '1'
            ? `${process.env.NEXT_PUBLIC_API_URL}/api/user/merchant`
            : `${process.env.NEXT_PUBLIC_API_URL}/api/user/drivers`;

        const response = await fetch(url);
        const result = await response.json();
        if (result.success && Array.isArray(result.data)) {
          setSecondOptions(result.data);
        } else {
          setSecondOptions([]);
        }
      } catch (error) {
        console.error('Fetch error:', error);
        setSecondOptions([]);
      } finally {
        setLoadingOptions(false);
      }
    };

    fetchOptions();
    if (!isMerchant) setSecondValue(null);
    setSummary(null);
    setTableData([]);
  }, [merchantFilter, isMerchant]);

  // Fetch driver summary function
  const fetchDriverSummary = async (
    id: string,
    startDate: string,
    endDate: string,
    page: number,
    pageSize: number
  ) => {
    setFetchingSummary(true);
    setFetchError(null);

    try {
      const queryParam = merchantFilter === '1' ? 'merchantId' : 'driverId';

      const deliveryUrl = `${process.env.NEXT_PUBLIC_API_URL}/api/delivery/findAllWithDate?page=${page}&limit=${pageSize}&startDate=${startDate}&endDate=${endDate}&${queryParam}=${id}`;
      
      const deliveryRes = await fetch(deliveryUrl);
      if (!deliveryRes.ok) throw new Error(`Delivery API error: ${deliveryRes.status}`);

      const deliveryData = await deliveryRes.json();

      if (deliveryData.success && Array.isArray(deliveryData.data)) {
        setDeliveryList(deliveryData.data);

        setPagination({
          current: page,
          pageSize,
          total: deliveryData.total || deliveryData.count || 0,
        });
      } else {
        throw new Error('Invalid delivery data format');
      }
    } catch (error: any) {
      setFetchError(`Error: ${error.message || error}`);
      setSummary(null);
      setTableData([]);
      setDeliveryList([]);
    } finally {
      setFetchingSummary(false);
    }
  };

  const effectiveSecondValue = isMerchant ? merchantId : secondValue;

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100vh' }}>
      {/* Filters & Controls */}
      <div className="flex gap-4 items-center w-full p-4" style={{ flexShrink: 0 }}>
        {!isMerchant && (
          <Switch
            checked={isReportMergeMode}
            onChange={(checked) => {
              setIsReportMergeMode(checked);
              setDateRange([null, null]);
            }}
            checkedChildren="Тайлан нийлэх"
            unCheckedChildren="Тайлан харах"
            style={{
              backgroundColor: isReportMergeMode ? undefined : '#52c41a',
              color: 'white',
            }}
          />
        )}
        {!isMerchant && (
          <>
            <Select
              value={merchantFilter}
              onChange={(value) => {
                setMerchantFilter(value);
                setSummary(null);
                setFetchError(null);
                setTableData([]);
              }}
              placeholder="Сонгох"
              style={{ width: 150 }}
              allowClear
            >
              <Option value="1">Мерчант</Option>
              <Option value="2">Жолооч</Option>
            </Select>

            <Select
              value={secondValue}
              onChange={(value) => {
                setSecondValue(value);
                setSummary(null);
                setFetchError(null);
                setTableData([]);
              }}
              placeholder="Хэрэглэгч сонгох"
              style={{ width: 200 }}
              loading={loadingOptions}
              allowClear
              disabled={!merchantFilter}
              showSearch
              optionFilterProp="label"
              filterOption={(input, option) =>
                (option?.label ?? '').toLowerCase().includes(input.toLowerCase())
              }
              options={secondOptions.map((o) => ({ label: o.username, value: o.id }))}
            />
          </>
        )}
        <RangePicker
          value={dateRange}
          onChange={(dates) => {
            setDateRange(dates ?? [null, null]);
            if (dates && dates[0] && dates[1] && effectiveSecondValue) {
              fetchDriverSummary(
                effectiveSecondValue,
                dates[0].format('YYYY-MM-DD'),
                dates[1].format('YYYY-MM-DD'),
                pagination.current,
                pagination.pageSize
              );
            }
          }}
          format="YYYY-MM-DD"
          placeholder={['Эхлэх огноо', 'Дуусах огноо']}
        />
      </div>
      
      <div
        style={{
          background: '#fff',
          padding: '16px 24px',
          borderTop: '1px solid #ddd',
          marginBottom: 16,
        }}
      >
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 12 }}>
          <Space>
            {!isMerchant && <div>{selectedRowKeys.length} item(s) selected</div>}
            {!isMerchant && (
              <Button
                type="primary"
                onClick={handleReportMerge}
                disabled={selectedRowKeys.length === 0}
              >
                Тайлан нийлэх
              </Button>
            )}
            <Button
              icon={<DownloadOutlined />}
              onClick={exportToExcel}
              disabled={deliveryList.length === 0}
              type="default"
            >
              Excel татах
            </Button>
          </Space>
          {fetchError && <div style={{ color: 'red' }}>{fetchError}</div>}
        </div>

        <Table
          columns={summaryColumns}
          dataSource={tableData}
          pagination={{
            current: pagination.current,
            pageSize: pagination.pageSize,
            total: pagination.total,
            showSizeChanger: true,
            onChange: (page, pageSize) => {
              setPagination((prev) => ({
                ...prev,
                current: page,
                pageSize: pageSize,
              }));
            },
          }}
          loading={fetchingSummary}
          rowKey="key"
          size="small"
          scroll={{ x: 'max-content' }}
          locale={{ emptyText: 'Тайлан байхгүй байна' }}
        />
      </div>

      {/* Delivery Data Table */}
      <div style={{ flexGrow: 1, overflowY: 'auto', padding: '0 24px' }}>
        <Table
          rowSelection={rowSelection}
          columns={deliveryColumns}
          dataSource={deliveryList}
          loading={loadingDeliveries}
          pagination={{
            current: pagination.current,
            pageSize: pagination.pageSize,
            total: pagination.total,
            showSizeChanger: true,
            pageSizeOptions: isMerchant ? ['50', '100', '200', '1000'] : ['100', '200', '500', '1000'],
            onChange: (page, pageSize) => {
              setPagination((prev) => ({ ...prev, current: page, pageSize }));
              if (dateRange[0] && dateRange[1] && effectiveSecondValue) {
                fetchDriverSummary(
                  effectiveSecondValue,
                  dateRange[0].format('YYYY-MM-DD'),
                  dateRange[1].format('YYYY-MM-DD'),
                  page,
                  pageSize
                );
              }
            },
          }}
          rowKey="id"
          scroll={{ x: 1200 }}
        />
      </div>
    </div>
  );
}