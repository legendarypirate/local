'use client';

import React, { useCallback, useEffect, useState } from 'react';
import { App, Button, DatePicker, Select, Space, Table, Tag, Typography } from 'antd';
import type { TableColumnsType } from 'antd';
import dayjs, { Dayjs } from 'dayjs';

const api = process.env.NEXT_PUBLIC_API_URL || '';

interface Payment {
  id: number;
  amount: number;
  note?: string | null;
  createdAt: string;
}

interface SettlementRow {
  id: number;
  driver_id: number;
  settlement_date: string;
  total_amount: number;
  driver_salary: number;
  difference: number;
  amount_paid: number;
  remaining: number;
  is_paid?: boolean;
  driver?: { id: number; username: string };
  payments?: Payment[];
}

export default function DriverDailySettlementsPage() {
  const { message: msg } = App.useApp();
  const [rows, setRows] = useState<SettlementRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [drivers, setDrivers] = useState<{ id: number; username: string }[]>([]);
  const [driverId, setDriverId] = useState<number | null>(null);
  const [dateRange, setDateRange] = useState<[Dayjs, Dayjs]>([dayjs().subtract(14, 'day'), dayjs()]);

  const fetchDrivers = useCallback(async () => {
    try {
      const res = await fetch(`${api}/api/user/drivers`);
      const json = await res.json();
      if (json.success && Array.isArray(json.data)) setDrivers(json.data);
    } catch {
      setDrivers([]);
    }
  }, []);

  const fetchRows = useCallback(async () => {
    if (!driverId) {
      setRows([]);
      return;
    }
    setLoading(true);
    try {
      const start = dateRange[0].format('YYYY-MM-DD');
      const end = dateRange[1].format('YYYY-MM-DD');
      const res = await fetch(
        `${api}/api/driver-daily-settlements?driver_id=${driverId}&start_date=${start}&end_date=${end}`
      );
      const json = await res.json();
      if (json.success && Array.isArray(json.data)) {
        setRows(json.data);
      } else {
        setRows([]);
        if (!json.success) msg.error(json.message || 'Ачаалахад алдаа');
      }
    } catch {
      setRows([]);
      msg.error('Сервертэй холбогдож чадсангүй');
    } finally {
      setLoading(false);
    }
  }, [driverId, dateRange, msg]);

  useEffect(() => {
    document.title = 'Жолоочийн өдрийн тооцоо';
    fetchDrivers();
  }, [fetchDrivers]);

  useEffect(() => {
    if (driverId) fetchRows();
  }, [driverId, fetchRows]);

  const columns: TableColumnsType<SettlementRow> = [
    { title: 'Огноо', dataIndex: 'settlement_date', width: 110 },
    {
      title: 'Жолооч',
      render: (_, r) => r.driver?.username ?? `#${r.driver_id}`,
      width: 120,
    },
    {
      title: 'Дүн (төлөх)',
      dataIndex: 'total_amount',
      width: 110,
      render: (v: number) => `${Number(v).toLocaleString()} ₮`,
    },
    {
      title: 'Төлсөн',
      dataIndex: 'amount_paid',
      width: 100,
      render: (v: number) => `${Number(v).toLocaleString()} ₮`,
    },
    {
      title: 'Үлдэгдэл',
      dataIndex: 'remaining',
      width: 100,
      render: (v: number) => (
        <span style={{ color: v > 0 ? '#cf1322' : '#389e0d', fontWeight: 600 }}>
          {Number(v).toLocaleString()} ₮
        </span>
      ),
    },
    {
      title: 'Жолоочид олгох',
      dataIndex: 'driver_salary',
      width: 110,
      render: (v: number) => `${Number(v).toLocaleString()} ₮`,
    },
    {
      title: 'Зөрүү',
      dataIndex: 'difference',
      width: 100,
      render: (v: number) => `${Number(v).toLocaleString()} ₮`,
    },
    {
      title: 'Төлөв',
      width: 100,
      render: (_, r) =>
        r.remaining <= 0 && r.total_amount > 0 ? (
          <Tag color="green">Төлсөн</Tag>
        ) : r.amount_paid > 0 ? (
          <Tag color="gold">Хэсэгчлэн</Tag>
        ) : (
          <Tag color="red">Төлөөгүй</Tag>
        ),
    },
    {
      title: 'Төлбөрүүд',
      key: 'payments',
      ellipsis: true,
      render: (_, r) =>
        (r.payments ?? [])
          .map((p) => `${Number(p.amount).toLocaleString()}₮`)
          .join(', ') || '—',
    },
  ];

  const totals = rows.reduce(
    (acc, r) => {
      acc.due += Number(r.total_amount ?? 0);
      acc.paid += Number(r.amount_paid ?? 0);
      acc.rem += Number(r.remaining ?? 0);
      return acc;
    },
    { due: 0, paid: 0, rem: 0 }
  );

  return (
    <div style={{ maxWidth: 1200 }}>
      <Typography.Title level={4} style={{ marginBottom: 16 }}>
        Жолоочийн өдрийн тооцоо (Дүн төлбөр)
      </Typography.Title>
      <Space wrap style={{ marginBottom: 16 }}>
        <Select
          showSearch
          allowClear
          placeholder="Жолооч"
          style={{ width: 220 }}
          value={driverId ?? undefined}
          onChange={(v) => setDriverId(typeof v === 'number' ? v : null)}
          options={drivers.map((d) => ({ value: d.id, label: d.username }))}
          optionFilterProp="label"
        />
        <DatePicker.RangePicker
          value={dateRange}
          onChange={(v) => {
            if (v?.[0] && v[1]) setDateRange([v[0], v[1]]);
          }}
        />
        <Button type="primary" onClick={fetchRows} loading={loading} disabled={!driverId}>
          Хайх
        </Button>
      </Space>
      {rows.length > 0 && (
        <Typography.Paragraph>
          Нийт Дүн: <strong>{totals.due.toLocaleString()} ₮</strong> | Төлсөн:{' '}
          <strong>{totals.paid.toLocaleString()} ₮</strong> | Үлдэгдэл:{' '}
          <strong style={{ color: totals.rem > 0 ? '#cf1322' : '#389e0d' }}>
            {totals.rem.toLocaleString()} ₮
          </strong>
        </Typography.Paragraph>
      )}
      <Table<SettlementRow>
        rowKey="id"
        loading={loading}
        columns={columns}
        dataSource={rows}
        scroll={{ x: 1000 }}
        pagination={{ pageSize: 31 }}
        expandable={{
          expandedRowRender: (r) =>
            (r.payments?.length ?? 0) > 0 ? (
              <ul style={{ margin: 0, paddingLeft: 20 }}>
                {r.payments!.map((p) => (
                  <li key={p.id}>
                    {Number(p.amount).toLocaleString()} ₮ — {dayjs(p.createdAt).format('YYYY-MM-DD HH:mm')}
                    {p.note ? ` (${p.note})` : ''}
                  </li>
                ))}
              </ul>
            ) : (
              <span>Төлбөр байхгүй</span>
            ),
        }}
      />
    </div>
  );
}
