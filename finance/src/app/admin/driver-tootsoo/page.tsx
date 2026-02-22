'use client';

import React, { useCallback, useEffect, useState } from 'react';
import { Table, Button, Tag, message, Select, DatePicker, Space } from 'antd';
import type { TableColumnsType } from 'antd';
import dayjs, { Dayjs } from 'dayjs';

interface DriverTootsoo {
  id: number;
  driver_id: number;
  driver?: { username: string };
  start_date: string;
  end_date: string;
  total_price: number;
  for_driver: number;
  extra_deduction?: number;
  account: number;
  number_delivery?: number;
  delivery_ids?: number[];
  status: 1 | 2; // 1 = unpaid, 2 = paid
  createdAt: string;
}

const STATUS_UNPAID = 1;
const STATUS_PAID = 2;

type DriverOption = { id: number; username: string };

export default function DriverTootsooPage() {
  const [data, setData] = useState<DriverTootsoo[]>([]);
  const [loading, setLoading] = useState(false);
  const [updatingId, setUpdatingId] = useState<number | null>(null);
  const [drivers, setDrivers] = useState<DriverOption[]>([]);
  const [driverId, setDriverId] = useState<number | null>(null);
  const [fromDate, setFromDate] = useState<Dayjs | null>(dayjs().subtract(14, 'day'));
  const [toDate, setToDate] = useState<Dayjs | null>(dayjs());

  useEffect(() => {
    const load = async () => {
      try {
        const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/drivers`);
        const result = await res.json();
        if (result.success && Array.isArray(result.data)) {
          setDrivers(result.data);
        }
      } catch {
        setDrivers([]);
      }
    };
    load();
  }, []);

  const fetchList = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (fromDate) params.set('from_date', fromDate.format('YYYY-MM-DD'));
      if (toDate) params.set('to_date', toDate.format('YYYY-MM-DD'));
      if (driverId != null) params.set('driver_id', String(driverId));
      const qs = params.toString();
      const url = `${process.env.NEXT_PUBLIC_API_URL}/api/driver-tootsoos${qs ? `?${qs}` : ''}`;
      const res = await fetch(url);
      const result = await res.json();
      if (result.success && Array.isArray(result.data)) {
        setData(result.data);
      } else {
        setData([]);
      }
    } catch {
      setData([]);
    } finally {
      setLoading(false);
    }
  }, [fromDate, toDate, driverId]);

  useEffect(() => {
    document.title = 'Жолоочийн тооцоо';
    fetchList();
  }, [fetchList]);

  const handleStatusChange = async (record: DriverTootsoo, newStatus: 1 | 2) => {
    setUpdatingId(record.id);
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/driver-tootsoos/${record.id}/status`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ status: newStatus }),
      });
      const result = await res.json();
      if (result.success) {
        message.success(newStatus === STATUS_PAID ? 'Төлөгдсөн болголоо' : 'Төлөгдөөгүй болголоо');
        setData((prev) => prev.map((r) => (r.id === record.id ? { ...r, status: newStatus } : r)));
      } else {
        message.error(result.message || 'Алдаа гарлаа');
      }
    } catch {
      message.error('Сервертэй холбогдож чадсангүй');
    } finally {
      setUpdatingId(null);
    }
  };

  const columns: TableColumnsType<DriverTootsoo> = [
    {
      title: 'Үүсгэсэн огноо',
      dataIndex: 'createdAt',
      key: 'createdAt',
      render: (t: string) => (t ? dayjs(t).format('YYYY-MM-DD HH:mm') : '—'),
    },
    {
      title: 'Жолооч',
      key: 'driver',
      render: (_, r) => r.driver?.username ?? `ID ${r.driver_id}`,
    },
    { title: 'Эхлэх огноо', dataIndex: 'start_date', key: 'start_date' },
    { title: 'Дуусах огноо', dataIndex: 'end_date', key: 'end_date' },
    {
      title: 'Нийт үнэ',
      dataIndex: 'total_price',
      key: 'total_price',
      render: (v: number) => (v != null ? `${Number(v).toLocaleString()} ₮` : '—'),
    },
    {
      title: 'Жолоочид олгох',
      dataIndex: 'for_driver',
      key: 'for_driver',
      render: (v: number) => (v != null ? `${Number(v).toLocaleString()} ₮` : '—'),
    },
    {
      title: 'Нэмэлт хасалт',
      dataIndex: 'extra_deduction',
      key: 'extra_deduction',
      render: (v: number) => (v != null && v !== 0 ? `${Number(v).toLocaleString()} ₮` : '—'),
    },
    {
      title: 'Тооцоо',
      dataIndex: 'account',
      key: 'account',
      render: (v: number) => (v != null ? `${Number(v).toLocaleString()} ₮` : '—'),
    },
    {
      title: 'Хүргэлтийн тоо',
      dataIndex: 'number_delivery',
      key: 'number_delivery',
      render: (v: number) => (v != null ? v.toLocaleString() : '—'),
    },
    {
      title: 'Төлөв',
      dataIndex: 'status',
      key: 'status',
      render: (status: number) =>
        status === STATUS_PAID ? (
          <Tag color="green">Төлөгдсөн</Tag>
        ) : (
          <Tag color="orange">Төлөгдөөгүй</Tag>
        ),
    },
    {
      title: 'Үйлдэл',
      key: 'actions',
      render: (_: unknown, record: DriverTootsoo) => {
        const isPaid = record.status === STATUS_PAID;
        const busy = updatingId === record.id;
        return (
          <Button
            type={isPaid ? 'default' : 'primary'}
            size="small"
            loading={busy}
            disabled={busy}
            onClick={() => handleStatusChange(record, isPaid ? STATUS_UNPAID : STATUS_PAID)}
          >
            {isPaid ? 'Төлөгдөөгүй болгох' : 'Төлөгдсөн болгох'}
          </Button>
        );
      },
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <h1 style={{ marginBottom: 24 }}>Жолоочийн тооцоо</h1>
      <Space wrap style={{ marginBottom: 16 }} align="center">
        <Space>
          <span>Жолооч:</span>
          <Select
            placeholder="Бүгд"
            allowClear
            style={{ minWidth: 160 }}
            value={driverId != null ? driverId : undefined}
            onChange={(v) => setDriverId(typeof v === 'number' ? v : null)}
            options={[
              { value: '', label: 'Бүгд' },
              ...drivers.map((d) => ({ value: d.id, label: d.username })),
            ]}
          />
        </Space>
        <Space>
          <span>Огноо:</span>
          <DatePicker
            value={fromDate}
            onChange={(d) => setFromDate(d ?? null)}
            format="YYYY-MM-DD"
          />
          <span>–</span>
          <DatePicker
            value={toDate}
            onChange={(d) => setToDate(d ?? null)}
            format="YYYY-MM-DD"
          />
        </Space>
        <Button type="primary" onClick={() => fetchList()}>
          Шүүх
        </Button>
      </Space>
      <Table
        rowKey="id"
        columns={columns}
        dataSource={data}
        loading={loading}
        pagination={{ pageSize: 20, showSizeChanger: true }}
        scroll={{ x: 'max-content' }}
        locale={{ emptyText: 'Жолоочийн тооцоо байхгүй байна' }}
      />
    </div>
  );
}
