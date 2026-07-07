'use client';

import React, { useCallback, useEffect, useState } from 'react';
import { Table, Button, Space, Modal, Input, Tag, App, Select } from 'antd';
import type { TableColumnsType } from 'antd';
import { InboxOutlined } from '@ant-design/icons';
import { useDeliveryItemsExpand } from '@/hooks/useDeliveryItemsExpand';

const api = process.env.NEXT_PUBLIC_API_URL || '';

interface NotPickedRow {
  id: number;
  delivery_id: number;
  driver_comment?: string | null;
  status: string;
  admin_note?: string | null;
  createdAt: string;
  delivery?: {
    id: number;
    delivery_id?: string;
    phone?: string;
    address?: string;
    status?: number;
    merchant?: { id: number; username: string };
    driver?: { id: number; username: string };
  };
  requester?: { id: number; username: string };
}

export default function DeliveryNotPickedRequestsPage() {
  const { message: msg, modal } = App.useApp();
  const [rows, setRows] = useState<NotPickedRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [statusFilter, setStatusFilter] = useState<string>('pending');
  const [rejectOpen, setRejectOpen] = useState(false);
  const [activeRow, setActiveRow] = useState<NotPickedRow | null>(null);
  const [rejectNote, setRejectNote] = useState('');
  const [actionRowId, setActionRowId] = useState<number | null>(null);

  const fetchRequests = useCallback(async (overrideStatus?: string) => {
    const statusToLoad = overrideStatus ?? statusFilter;
    setLoading(true);
    try {
      const q = statusToLoad === 'all' ? '' : `?status=${encodeURIComponent(statusToLoad)}`;
      const res = await fetch(`${api}/api/delivery-not-picked-requests${q}`);
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
  }, [statusFilter, msg]);

  useEffect(() => {
    document.title = 'Авч гараагүй хүсэлт';
  }, []);

  useEffect(() => {
    fetchRequests();
  }, [fetchRequests]);

  const submitApprove = async (row: NotPickedRow) => {
    setActionRowId(row.id);
    try {
      const res = await fetch(`${api}/api/delivery-not-picked-requests/${row.id}/approve`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
      });
      const json = await res.json();
      if (json.success) {
        msg.success(json.message || 'Зөвшөөрөгдлөө');
        await fetchRequests();
      } else {
        msg.error(json.message || 'Алдаа');
        throw new Error(json.message || 'Алдаа');
      }
    } catch (e) {
      if (e instanceof Error && e.message !== 'Алдаа') {
        msg.error('Сервертэй холбогдож чадсангүй');
      }
      throw e;
    } finally {
      setActionRowId(null);
    }
  };

  const submitReject = async () => {
    if (!activeRow) return;
    setActionRowId(activeRow.id);
    try {
      const res = await fetch(`${api}/api/delivery-not-picked-requests/${activeRow.id}/reject`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ admin_note: rejectNote.trim() || null }),
      });
      const json = await res.json();
      if (json.success) {
        msg.success(json.message || 'Татгалзлаа');
        setRejectOpen(false);
        setRejectNote('');
        setActiveRow(null);
        setStatusFilter('rejected');
        await fetchRequests('rejected');
      } else {
        msg.error(json.message || 'Алдаа');
        throw new Error(json.message || 'Алдаа');
      }
    } catch (e) {
      if (e instanceof Error && e.message !== 'Алдаа') {
        msg.error('Сервертэй холбогдож чадсангүй');
      }
      throw e;
    } finally {
      setActionRowId(null);
    }
  };

  const statusTag = (s: string) => {
    if (s === 'pending') return <Tag color="gold">Хүлээгдэж буй</Tag>;
    if (s === 'approved') return <Tag color="green">Зөвшөөрсөн</Tag>;
    if (s === 'rejected') return <Tag color="red">Татгалзсан</Tag>;
    return <Tag>{s}</Tag>;
  };

  const getDeliveryId = useCallback(
    (r: NotPickedRow) => r.delivery_id ?? r.delivery?.id,
    []
  );
  const { expandable } = useDeliveryItemsExpand(getDeliveryId);

  const columns: TableColumnsType<NotPickedRow> = [
    {
      title: 'Хүргэлт',
      key: 'delivery',
      width: 96,
      render: (_, r) => r.delivery?.delivery_id ?? r.delivery?.id ?? r.delivery_id,
    },
    {
      title: 'Утас',
      key: 'phone',
      width: 112,
      render: (_, r) => r.delivery?.phone ?? '—',
    },
    {
      title: 'Хаяг',
      key: 'address',
      ellipsis: true,
      width: 220,
      render: (_, r) => r.delivery?.address ?? '—',
    },
    {
      title: 'Дэлгүүр',
      key: 'merchant',
      width: 120,
      ellipsis: true,
      render: (_, r) => r.delivery?.merchant?.username ?? '—',
    },
    {
      title: 'Жолооч',
      key: 'driver',
      width: 110,
      ellipsis: true,
      render: (_, r) => r.delivery?.driver?.username ?? '—',
    },
    {
      title: 'Хүсэлт гаргасан',
      key: 'requester',
      width: 130,
      ellipsis: true,
      render: (_, r) => r.requester?.username ?? '—',
    },
    {
      title: 'Төлөв (хүргэлт)',
      key: 'delivery_status',
      width: 120,
      render: (_, r) => r.delivery?.status ?? '—',
    },
    {
      title: 'Жолоочийн тайлбар',
      key: 'driver_comment',
      dataIndex: 'driver_comment',
      ellipsis: true,
      width: 180,
      render: (t: string | null) => t || '—',
    },
    {
      title: 'Админ тайлбар',
      key: 'admin_note',
      dataIndex: 'admin_note',
      ellipsis: true,
      width: 180,
      render: (t: string | null) => t || '—',
    },
    {
      title: 'Хүсэлтийн төлөв',
      key: 'status',
      dataIndex: 'status',
      width: 140,
      render: (s: string) => statusTag(s),
    },
    { title: 'Огноо', key: 'createdAt', dataIndex: 'createdAt', width: 168 },
    {
      title: 'Үйлдэл',
      key: 'actions',
      width: 200,
      render: (_, r) =>
        r.status === 'pending' ? (
          <Space>
            <Button
              type="primary"
              size="small"
              loading={actionRowId === r.id}
              onClick={() => {
                modal.confirm({
                  title: 'Зөвшөөрөх үү?',
                  content: 'Хүргэлтийн төлөв 10 (Авч гараагүй) болно.',
                  okText: 'Тийм',
                  cancelText: 'Үгүй',
                  onOk: () => submitApprove(r),
                });
              }}
            >
              Зөвшөөрөх
            </Button>
            <Button
              danger
              size="small"
              disabled={actionRowId === r.id}
              onClick={() => {
                setActiveRow(r);
                setRejectNote('');
                setRejectOpen(true);
              }}
            >
              Татгалзах
            </Button>
          </Space>
        ) : null,
    },
  ];

  return (
    <>
      <div style={{ marginBottom: 16, display: 'flex', gap: 12, alignItems: 'center' }}>
        <InboxOutlined style={{ fontSize: 22 }} />
        <span>Шүүлтүүр:</span>
        <Select
          style={{ width: 200 }}
          value={statusFilter}
          onChange={(v) => setStatusFilter(v)}
          options={[
            { value: 'pending', label: 'Хүлээгдэж буй' },
            { value: 'approved', label: 'Зөвшөөрсөн' },
            { value: 'rejected', label: 'Татгалзсан' },
            { value: 'all', label: 'Бүгд' },
          ]}
        />
        <Button onClick={() => fetchRequests()} loading={loading}>
          Шинэчлэх
        </Button>
      </div>
      <Table<NotPickedRow>
        rowKey="id"
        loading={loading}
        columns={columns}
        dataSource={rows}
        tableLayout="fixed"
        scroll={{ x: 1580 }}
        pagination={{ pageSize: 50 }}
        expandable={expandable}
      />

      <Modal
        title="Татгалзах"
        open={rejectOpen}
        onCancel={() => !actionRowId && setRejectOpen(false)}
        okText="Илгээх"
        cancelText="Болих"
        confirmLoading={actionRowId === activeRow?.id}
        onOk={submitReject}
      >
        <Input.TextArea
          rows={3}
          placeholder="Тайлбар (заавал биш)"
          value={rejectNote}
          onChange={(e) => setRejectNote(e.target.value)}
        />
      </Modal>
    </>
  );
}
