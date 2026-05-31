'use client';

import React, { useCallback, useEffect, useState } from 'react';
import { App, Button, Form, Input, InputNumber, Modal, Space, Switch, Table, Typography } from 'antd';

const { Title } = Typography;
import type { TableColumnsType } from 'antd';
import { PlusOutlined } from '@ant-design/icons';

const api = process.env.NEXT_PUBLIC_API_URL || '';

interface PriceSettingRow {
  id: number;
  label?: string | null;
  merchant_price: number;
  driver_price: number;
  is_default: boolean;
}

export default function PriceSettingsPage() {
  const { message: msg, modal } = App.useApp();
  const [form] = Form.useForm();
  const [rows, setRows] = useState<PriceSettingRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState<PriceSettingRow | null>(null);
  const [saving, setSaving] = useState(false);

  const fetchRows = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch(`${api}/api/delivery-price-settings`);
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
  }, [msg]);

  useEffect(() => {
    document.title = 'Үнийн тохиргоо';
    fetchRows();
  }, [fetchRows]);

  const openCreate = () => {
    setEditing(null);
    form.resetFields();
    form.setFieldsValue({ merchant_price: 6000, driver_price: 4000, is_default: false });
    setModalOpen(true);
  };

  const openEdit = (row: PriceSettingRow) => {
    setEditing(row);
    form.setFieldsValue({
      label: row.label ?? '',
      merchant_price: row.merchant_price,
      driver_price: row.driver_price,
      is_default: row.is_default,
    });
    setModalOpen(true);
  };

  const handleSave = async () => {
    try {
      const values = await form.validateFields();
      setSaving(true);
      const body = {
        label: values.label?.trim() || null,
        merchant_price: Number(values.merchant_price),
        driver_price: Number(values.driver_price),
        is_default: !!values.is_default,
      };
      const url = editing
        ? `${api}/api/delivery-price-settings/${editing.id}`
        : `${api}/api/delivery-price-settings`;
      const res = await fetch(url, {
        method: editing ? 'PUT' : 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
      });
      const json = await res.json();
      if (json.success) {
        msg.success(editing ? 'Шинэчлэгдлээ' : 'Нэмэгдлээ');
        setModalOpen(false);
        fetchRows();
      } else {
        msg.error(json.message || 'Алдаа');
      }
    } catch {
      /* validation */
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = (row: PriceSettingRow) => {
    modal.confirm({
      title: 'Устгах уу?',
      content: row.label || `#${row.id}`,
      okText: 'Тийм',
      cancelText: 'Үгүй',
      okButtonProps: { danger: true },
      onOk: async () => {
        const res = await fetch(`${api}/api/delivery-price-settings/${row.id}`, { method: 'DELETE' });
        const json = await res.json();
        if (json.success) {
          msg.success('Устгагдлаа');
          fetchRows();
        } else {
          msg.error(json.message || 'Алдаа');
        }
      },
    });
  };

  const columns: TableColumnsType<PriceSettingRow> = [
    { title: 'ID', dataIndex: 'id', width: 70 },
    {
      title: 'Нэр',
      dataIndex: 'label',
      render: (v: string | null, r) => v || (r.is_default ? 'Стандарт (default)' : '—'),
    },
    {
      title: 'Дэлгүүр (₮)',
      dataIndex: 'merchant_price',
      width: 130,
      render: (v: number) => `${Number(v).toLocaleString()} ₮`,
    },
    {
      title: 'Жолооч (₮)',
      dataIndex: 'driver_price',
      width: 130,
      render: (v: number) => `${Number(v).toLocaleString()} ₮`,
    },
    {
      title: 'Default',
      dataIndex: 'is_default',
      width: 90,
      render: (v: boolean) => (v ? 'Тийм' : '—'),
    },
    {
      title: 'Үйлдэл',
      key: 'actions',
      width: 160,
      render: (_, r) => (
        <Space>
          <Button size="small" onClick={() => openEdit(r)}>
            Засах
          </Button>
          <Button size="small" danger disabled={r.is_default} onClick={() => handleDelete(r)}>
            Устгах
          </Button>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ maxWidth: 900 }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
        <Title level={4} style={{ margin: 0 }}>
          Үнийн тохиргоо
        </Title>
        <Button type="primary" icon={<PlusOutlined />} onClick={openCreate}>
          Нэмэх
        </Button>
      </div>
      <Typography.Paragraph type="secondary">
        Шинэ хүргэлт default тохиргоогоор үүснэ (ихэвчлэн 6000 / 4000). Том хүргэлтүүдийг хүргэлтийн жагсаалтаас
        сонгож bulk-аар тохиргоо онооно. Тайлан (шинэ) хүргэлт бүрт энэ тохиргооны үнийг ашиглана.
      </Typography.Paragraph>
      <Table<PriceSettingRow>
        rowKey="id"
        loading={loading}
        columns={columns}
        dataSource={rows}
        pagination={false}
      />

      <Modal
        title={editing ? 'Тохиргоо засах' : 'Шинэ тохиргоо'}
        open={modalOpen}
        onCancel={() => !saving && setModalOpen(false)}
        onOk={handleSave}
        confirmLoading={saving}
        okText="Хадгалах"
        cancelText="Болих"
      >
        <Form form={form} layout="vertical">
          <Form.Item name="label" label="Нэр (заавал биш)">
            <Input placeholder="Жишээ: Том хүргэлт" />
          </Form.Item>
          <Form.Item
            name="merchant_price"
            label="Дэлгүүрийн үнэ (₮)"
            rules={[{ required: true, message: 'Оруулна уу' }]}
          >
            <InputNumber min={0} style={{ width: '100%' }} />
          </Form.Item>
          <Form.Item
            name="driver_price"
            label="Жолоочийн үнэ (₮)"
            rules={[{ required: true, message: 'Оруулна уу' }]}
          >
            <InputNumber min={0} style={{ width: '100%' }} />
          </Form.Item>
          <Form.Item name="is_default" label="Default (шинэ хүргэлт)" valuePropName="checked">
            <Switch />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
