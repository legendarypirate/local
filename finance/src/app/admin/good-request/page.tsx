'use client';

import React, { useEffect, useState, useMemo } from 'react';
import {
  Table,
  Button,
  Space,
  Select,
  Input,
  Tag,
  message,
  Drawer,
  Form,
  InputNumber,
  Modal,
} from 'antd';
import type { TableColumnsType } from 'antd';
import { CheckOutlined, CloseOutlined, PlusOutlined } from '@ant-design/icons';
import dayjs from 'dayjs';

interface GoodRequest {
  id: number;
  type: number;
  stock: number;
  approved_stock?: number | null;
  status: number;
  ware_id: number;
  merchant_id: number;
  good_id: number | null;
  name: string | null;
  createdAt: string;
  merchant?: { id: number; username: string };
  ware?: { id: number; name: string };
  good?: { id: number; name: string } | null;
}

interface Good {
  id: number;
  name: string;
  stock: number;
  ware_id?: number;
  ware?: { id: number; name: string };
}

interface Ware {
  id: number;
  name: string;
}

const TYPE_LABELS: Record<number, string> = {
  1: 'Шинэ бараа үүсгэх',
  2: 'Нэмэх',
  3: 'Хасах',
};

const STATUS_LABELS: Record<number, string> = {
  1: 'Хүлээгдэж байна',
  2: 'Зөвшөөрөгдсөн',
  3: 'Татгалзсан',
};

export default function GoodRequestPage() {
  const [requests, setRequests] = useState<GoodRequest[]>([]);
  const [loading, setLoading] = useState(false);
  const [user, setUser] = useState<{ id: number; role?: number; role_id?: number } | null>(null);
  const [statusFilter, setStatusFilter] = useState<number | null>(null);
  const [typeFilter, setTypeFilter] = useState<number | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [form] = Form.useForm();
  const [goods, setGoods] = useState<Good[]>([]);
  const [wares, setWares] = useState<Ware[]>([]);
  const [submitLoading, setSubmitLoading] = useState(false);

  const isMerchant = user ? (user.role === 2 || user.role_id === 2) : false;
  const merchantId = isMerchant ? user?.id ?? null : null;

  const loadUser = () => {
    try {
      const raw = typeof window !== 'undefined' ? localStorage.getItem('user') : null;
      if (raw) setUser(JSON.parse(raw));
    } catch {
      setUser(null);
    }
  };

  const loadData = useMemo(
    () => async () => {
      if (!user) return;
      setLoading(true);
      try {
        const url =
          isMerchant && merchantId
            ? `${process.env.NEXT_PUBLIC_API_URL}/api/request?merchant_id=${merchantId}`
            : `${process.env.NEXT_PUBLIC_API_URL}/api/request`;
        const res = await fetch(url);
        const result = await res.json();
        if (result.success && Array.isArray(result.data)) {
          setRequests(result.data);
        } else {
          setRequests([]);
        }

        const wareRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/ware`);
        const wareResult = await wareRes.json();
        if (wareResult.success && Array.isArray(wareResult.data)) {
          setWares(wareResult.data);
        }

        if (isMerchant && merchantId) {
          const goodRes = await fetch(
            `${process.env.NEXT_PUBLIC_API_URL}/api/good?merchant_id=${merchantId}`
          );
          const goodResult = await goodRes.json();
          if (goodResult.success && Array.isArray(goodResult.data)) {
            setGoods(goodResult.data);
          }
        }
      } catch {
        setRequests([]);
        message.error('Өгөгдөл ачааллахад алдаа гарлаа');
      } finally {
        setLoading(false);
      }
    },
    [user, isMerchant, merchantId]
  );

  useEffect(() => {
    document.title = 'Барааны хүсэлт';
    loadUser();
  }, []);

  useEffect(() => {
    if (user) loadData();
  }, [user, loadData]);

  const filteredRequests = useMemo(() => {
    let list = requests;
    if (statusFilter != null) list = list.filter((r) => r.status === statusFilter);
    if (typeFilter != null) list = list.filter((r) => r.type === typeFilter);
    if (searchTerm.trim()) {
      const q = searchTerm.toLowerCase().trim();
      list = list.filter((r) => {
        const goodName = (r.good?.name ?? r.name ?? '').toLowerCase();
        const merchantName = (r.merchant?.username ?? '').toLowerCase();
        return goodName.includes(q) || merchantName.includes(q);
      });
    }
    return list;
  }, [requests, statusFilter, typeFilter, searchTerm]);

  const handleApprove = async (record: GoodRequest) => {
    try {
      const res = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL}/api/request/approve/${record.id}`,
        { method: 'PUT', headers: { 'Content-Type': 'application/json' }, body: '{}' }
      );
      const result = await res.json();
      if (result.success) {
        message.success('Хүсэлт зөвшөөрөгдлөө');
        loadData();
      } else {
        message.error(result.message || 'Зөвшөөрөхөд алдаа гарлаа');
      }
    } catch {
      message.error('Зөвшөөрөхөд алдаа гарлаа');
    }
  };

  const handleDecline = (record: GoodRequest) => {
    Modal.confirm({
      title: 'Татгалзах',
      content: 'Та энэ хүсэлтийг татгалзахдаа итгэлтэй байна уу?',
      okText: 'Тийм',
      cancelText: 'Үгүй',
      onOk: async () => {
        try {
          const res = await fetch(
            `${process.env.NEXT_PUBLIC_API_URL}/api/request/decline/${record.id}`,
            { method: 'PUT', headers: { 'Content-Type': 'application/json' } }
          );
          const result = await res.json();
          if (result.success) {
            message.success('Хүсэлт татгалзсан');
            loadData();
          } else {
            message.error(result.message || 'Татгалзахдаа алдаа гарлаа');
          }
        } catch {
          message.error('Татгалзахдаа алдаа гарлаа');
        }
      },
    });
  };

  const handleCreateRequest = async (values: {
    type: number;
    ware_id: number;
    good_id?: number;
    name?: string;
    amount: number;
  }) => {
    if (!merchantId) return;
    setSubmitLoading(true);
    try {
      const payload: Record<string, unknown> = {
        type: values.type,
        amount: values.amount,
        ware_id: values.ware_id,
        merchant_id: merchantId,
      };
      if (values.type === 1) {
        payload.name = values.name;
      } else {
        payload.good_id = values.good_id;
      }
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/request/stock`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });
      const result = await res.json();
      if (result.success) {
        message.success('Хүсэлт амжилттай үүсгэгдлээ');
        setDrawerOpen(false);
        form.resetFields();
        loadData();
      } else {
        message.error(result.message || 'Хүсэлт үүсгэхэд алдаа гарлаа');
      }
    } catch {
      message.error('Хүсэлт үүсгэхэд алдаа гарлаа');
    } finally {
      setSubmitLoading(false);
    }
  };

  const selectedWareId = Form.useWatch('ware_id', form);
  const requestType = Form.useWatch('type', form);
  const isTypeCreateGood = requestType === 1;
  const filteredGoodsByWare = selectedWareId
    ? goods.filter((g) => (g.ware_id ?? g.ware?.id) === selectedWareId)
    : [];

  const columns: TableColumnsType<GoodRequest> = [
    ...(!isMerchant
      ? [
          {
            title: 'Дэлгүүр',
            key: 'merchant',
            dataIndex: ['merchant', 'username'],
            render: (v: string) => v ?? '—',
          },
        ]
      : []),
    {
      title: 'Төрөл',
      dataIndex: 'type',
      key: 'type',
      render: (t: number) => (
        <Tag color={t === 1 ? 'blue' : t === 2 ? 'green' : 'red'}>{TYPE_LABELS[t] ?? '—'}</Tag>
      ),
    },
    {
      title: 'Бараа',
      key: 'goodName',
      render: (_: unknown, r: GoodRequest) => r.good?.name ?? r.name ?? '—',
    },
    {
      title: 'Агуулах',
      key: 'ware',
      render: (_: unknown, r: GoodRequest) => r.ware?.name ?? '—',
    },
    {
      title: 'Хүсэлтийн тоо',
      dataIndex: 'stock',
      key: 'stock',
      render: (v: number) => (v != null ? v.toLocaleString() : '—'),
    },
    {
      title: 'Зөвшөөрсөн тоо',
      dataIndex: 'approved_stock',
      key: 'approved_stock',
      render: (v: number | null) =>
        v != null ? <span style={{ color: '#52c41a' }}>{v.toLocaleString()}</span> : '—',
    },
    {
      title: 'Төлөв',
      dataIndex: 'status',
      key: 'status',
      render: (s: number) => (
        <Tag color={s === 1 ? 'gold' : s === 2 ? 'green' : 'red'}>
          {STATUS_LABELS[s] ?? '—'}
        </Tag>
      ),
    },
    {
      title: 'Огноо',
      dataIndex: 'createdAt',
      key: 'createdAt',
      render: (t: string) => (t ? dayjs(t).format('YYYY-MM-DD HH:mm') : '—'),
    },
    ...(!isMerchant
      ? [
          {
            title: 'Үйлдэл',
            key: 'actions',
            render: (_: unknown, record: GoodRequest) =>
              record.status === 1 ? (
                <Space>
                  <Button
                    type="primary"
                    size="small"
                    icon={<CheckOutlined />}
                    onClick={() => handleApprove(record)}
                  >
                    Зөвшөөрөх
                  </Button>
                  <Button
                    size="small"
                    danger
                    icon={<CloseOutlined />}
                    onClick={() => handleDecline(record)}
                  >
                    Татгалзах
                  </Button>
                </Space>
              ) : (
                <span style={{ color: '#999' }}>Дууссан</span>
              ),
          },
        ]
      : []),
  ];

  return (
    <div style={{ padding: 24 }}>
      <div style={{ marginBottom: 16, display: 'flex', justifyContent: 'space-between', flexWrap: 'wrap', gap: 16 }}>
        <h1 style={{ margin: 0 }}>Барааны хүсэлт</h1>
        {isMerchant && (
          <Button type="primary" icon={<PlusOutlined />} onClick={() => setDrawerOpen(true)}>
            Хүсэлт үүсгэх
          </Button>
        )}
      </div>

      <Space wrap style={{ marginBottom: 16 }}>
        {!isMerchant && (
          <Select
            placeholder="Төлөвөөр шүүх"
            allowClear
            style={{ width: 160 }}
            value={statusFilter ?? undefined}
            onChange={(v) => setStatusFilter(v ?? null)}
            options={[
              { value: 1, label: 'Хүлээгдэж байна' },
              { value: 2, label: 'Зөвшөөрөгдсөн' },
              { value: 3, label: 'Татгалзсан' },
            ]}
          />
        )}
        <Select
          placeholder="Төрлөөр шүүх"
          allowClear
          style={{ width: 180 }}
          value={typeFilter ?? undefined}
          onChange={(v) => setTypeFilter(v ?? null)}
          options={[
            { value: 1, label: 'Шинэ бараа үүсгэх' },
            { value: 2, label: 'Нэмэх' },
            { value: 3, label: 'Хасах' },
          ]}
        />
        <Input.Search
          placeholder="Бараа эсвэл дэлгүүрийн нэрээр хайх"
          allowClear
          style={{ width: 280 }}
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          onSearch={() => {}}
        />
      </Space>

      <Table
        rowKey="id"
        columns={columns}
        dataSource={filteredRequests}
        loading={loading}
        pagination={{ pageSize: 20, showSizeChanger: true }}
        locale={{ emptyText: 'Хүсэлт олдсонгүй' }}
      />

      <Drawer
        title="Барааны хүсэлт үүсгэх"
        open={drawerOpen}
        onClose={() => setDrawerOpen(false)}
        width={400}
        destroyOnClose
        footer={null}
      >
        <Form
          form={form}
          layout="vertical"
          onFinish={handleCreateRequest}
          initialValues={{ type: 1 }}
        >
          <Form.Item name="type" label="Төрөл" rules={[{ required: true }]}>
            <Select
              options={[
                { value: 1, label: 'Шинэ бараа үүсгэх' },
                { value: 2, label: 'Нэмэх' },
                { value: 3, label: 'Хасах' },
              ]}
              onChange={() => {
                form.setFieldValue('good_id', undefined);
                form.setFieldValue('name', undefined);
              }}
            />
          </Form.Item>
          <Form.Item name="ware_id" label="Агуулах" rules={[{ required: true }]}>
            <Select
              placeholder="Агуулах сонгох"
              options={wares.map((w) => ({ value: w.id, label: w.name }))}
              onChange={() => form.setFieldValue('good_id', undefined)}
            />
          </Form.Item>
          {isTypeCreateGood ? (
            <Form.Item
              name="name"
              label="Шинэ барааны нэр"
              rules={[{ required: true, message: 'Барааны нэр оруулна уу' }]}
            >
              <Input placeholder="Барааны нэр" />
            </Form.Item>
          ) : (
            <Form.Item
              name="good_id"
              label="Бараа"
              rules={[{ required: true, message: 'Бараа сонгоно уу' }]}
            >
              <Select
                placeholder="Бараа сонгох"
                disabled={!selectedWareId}
                options={filteredGoodsByWare.map((g) => ({
                  value: g.id,
                  label: `${g.name} (Үлдэгдэл: ${g.stock})`,
                }))}
              />
            </Form.Item>
          )}
          <Form.Item
            name="amount"
            label={isTypeCreateGood ? 'Анхны тоо ширхэг' : 'Тоо ширхэг'}
            rules={[{ required: true }, { type: 'number', min: 1, message: '1-ээс их байх ёстой' }]}
          >
            <InputNumber min={1} style={{ width: '100%' }} placeholder="Тоо ширхэг" />
          </Form.Item>
          <Form.Item>
            <Space>
              <Button type="primary" htmlType="submit" loading={submitLoading}>
                Хүсэлт үүсгэх
              </Button>
              <Button onClick={() => setDrawerOpen(false)}>Цуцлах</Button>
            </Space>
          </Form.Item>
        </Form>
      </Drawer>
    </div>
  );
}
