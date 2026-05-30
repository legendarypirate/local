'use client';

import React, { useCallback, useEffect, useState } from 'react';
import { useDeliveryItemsExpand } from '@/hooks/useDeliveryItemsExpand';
import {
  Table,
  Button,
  Space,
  Modal,
  Select,
  Input,
  Tag,
  App,
} from 'antd';
import type { TableColumnsType } from 'antd';

const api = process.env.NEXT_PUBLIC_API_URL || '';

interface DriverOpt {
  id: number;
  username: string;
}

interface AddressRequestRow {
  id: number;
  delivery_id: number;
  previous_address: string;
  new_address: string;
  status: string;
  admin_note?: string | null;
  new_driver_id?: number | null;
  createdAt: string;
  delivery?: {
    id: number;
    phone?: string;
    address?: string;
    status?: number;
    merchant?: { id: number; username: string };
    driver?: { id: number; username: string };
  };
  requester?: { id: number; username: string };
  new_driver?: { id: number; username: string } | null;
}

export default function DeliveryAddressRequestsPage() {
  const { message: msg, modal } = App.useApp();
  const [rows, setRows] = useState<AddressRequestRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [statusFilter, setStatusFilter] = useState<string>('pending');
  const [drivers, setDrivers] = useState<DriverOpt[]>([]);
  const [approveOpen, setApproveOpen] = useState(false);
  const [rejectOpen, setRejectOpen] = useState(false);
  const [activeRow, setActiveRow] = useState<AddressRequestRow | null>(null);
  const [selectedDriverId, setSelectedDriverId] = useState<number | null>(null);
  const [rejectNote, setRejectNote] = useState('');
  const [actionLoading, setActionLoading] = useState(false);

  const fetchRequests = useCallback(async () => {
    setLoading(true);
    try {
      const q = statusFilter === 'all' ? '' : `?status=${encodeURIComponent(statusFilter)}`;
      const res = await fetch(`${api}/api/delivery-address-requests${q}`);
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

  const fetchDrivers = useCallback(async () => {
    try {
      const res = await fetch(`${api}/api/user/drivers`);
      const json = await res.json();
      if (json.success && Array.isArray(json.data)) {
        setDrivers(json.data);
      } else {
        setDrivers([]);
      }
    } catch {
      setDrivers([]);
    }
  }, []);

  useEffect(() => {
    document.title = 'Хаяг солих хүсэлт';
    fetchDrivers();
  }, [fetchDrivers]);

  useEffect(() => {
    fetchRequests();
  }, [fetchRequests]);

  const openApprove = (row: AddressRequestRow) => {
    setActiveRow(row);
    setSelectedDriverId(null);
    setApproveOpen(true);
  };

  const onApproveSubmitClick = () => {
    if (!activeRow || !selectedDriverId) {
      msg.warning('Жолооч сонгоно уу');
      return;
    }
    modal.confirm({
      title: 'Итгэлтэй юу?',
      content: 'Хүргэлтийн хаяг шинэчлэгдэж, сонгосон жолооч руу шилжинэ.',
      okText: 'Тийм',
      cancelText: 'Үгүй',
      onOk: submitApprove,
    });
  };

  const submitApprove = async () => {
    if (!activeRow || !selectedDriverId) {
      return;
    }
    setActionLoading(true);
    try {
      const res = await fetch(`${api}/api/delivery-address-requests/${activeRow.id}/approve`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ new_driver_id: selectedDriverId }),
      });
      const json = await res.json();
      if (json.success) {
        msg.success(json.message || 'Зөвшөөрөгдлөө');
        setApproveOpen(false);
        setActiveRow(null);
        fetchRequests();
      } else {
        msg.error(json.message || 'Алдаа');
      }
    } catch {
      msg.error('Сервертэй холбогдож чадсангүй');
    } finally {
      setActionLoading(false);
    }
  };

  const submitReject = async () => {
    if (!activeRow) return;
    setActionLoading(true);
    try {
      const res = await fetch(`${api}/api/delivery-address-requests/${activeRow.id}/reject`, {
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
        fetchRequests();
      } else {
        msg.error(json.message || 'Алдаа');
      }
    } catch {
      msg.error('Сервертэй холбогдож чадсангүй');
    } finally {
      setActionLoading(false);
    }
  };

  const statusTag = (s: string) => {
    if (s === 'pending') return <Tag color="gold">Хүлээгдэж буй</Tag>;
    if (s === 'approved') return <Tag color="green">Зөвшөөрсөн</Tag>;
    if (s === 'rejected') return <Tag color="red">Татгалзсан</Tag>;
    return <Tag>{s}</Tag>;
  };

  const getDeliveryId = useCallback(
    (r: AddressRequestRow) => r.delivery_id ?? r.delivery?.id,
    []
  );
  const { expandable } = useDeliveryItemsExpand(getDeliveryId);

  const columns: TableColumnsType<AddressRequestRow> = [
    { title: 'ID', dataIndex: 'id', width: 70 },
    {
      title: 'Хүргэлт',
      width: 100,
      render: (_, r) => r.delivery?.id ?? r.delivery_id,
    },
    {
      title: 'Утас',
      width: 120,
      render: (_, r) => r.delivery?.phone ?? '—',
    },
    {
      title: 'Хаяг',
      ellipsis: true,
      width: 200,
      render: (_, r) => r.delivery?.address ?? '—',
    },
    {
      title: 'Дэлгүүр',
      render: (_, r) => r.delivery?.merchant?.username ?? '—',
    },
    {
      title: 'Одоогийн жолооч',
      render: (_, r) => r.delivery?.driver?.username ?? '—',
    },
    {
      title: 'Хүсэлт гаргасан',
      render: (_, r) => r.requester?.username ?? '—',
    },
    {
      title: 'Өмнөх хаяг',
      dataIndex: 'previous_address',
      ellipsis: true,
      width: 180,
    },
    {
      title: 'Шинэ хаяг',
      dataIndex: 'new_address',
      ellipsis: true,
      width: 180,
    },
    {
      title: 'Төлөв',
      dataIndex: 'status',
      width: 120,
      render: (s: string) => statusTag(s),
    },
    {
      title: 'Шинэ жолооч (баталсны дараа)',
      width: 160,
      render: (_, r) => r.new_driver?.username ?? (r.new_driver_id ? `#${r.new_driver_id}` : '—'),
    },
    { title: 'Огноо', dataIndex: 'createdAt', width: 170 },
    {
      title: 'Үйлдэл',
      key: 'actions',
      width: 200,
      fixed: 'right',
      render: (_, r) =>
        r.status === 'pending' ? (
          <Space>
            <Button type="primary" size="small" onClick={() => openApprove(r)}>
              Зөвшөөрөх
            </Button>
            <Button danger size="small" onClick={() => { setActiveRow(r); setRejectNote(''); setRejectOpen(true); }}>
              Татгалзах
            </Button>
          </Space>
        ) : null,
    },
  ];

  return (
    <>
      <div style={{ marginBottom: 16, display: 'flex', gap: 12, alignItems: 'center' }}>
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
      <Table<AddressRequestRow>
        rowKey="id"
        loading={loading}
        columns={columns}
        dataSource={rows}
        scroll={{ x: 1500 }}
        pagination={{ pageSize: 50 }}
        expandable={expandable}
      />

      <Modal
        title="Хаяг солих — зөвшөөрөх"
        open={approveOpen}
        onCancel={() => !actionLoading && setApproveOpen(false)}
        footer={[
          <Button key="cancel" disabled={actionLoading} onClick={() => setApproveOpen(false)}>
            Болих
          </Button>,
          <Button key="ok" type="primary" loading={actionLoading} onClick={onApproveSubmitClick}>
            Батлах
          </Button>,
        ]}
      >
        <p style={{ marginBottom: 8 }}>Шинэ хүргэлтийн жолооч сонгоно уу:</p>
        <Select
          style={{ width: '100%' }}
          placeholder="Жолооч"
          value={selectedDriverId ?? undefined}
          onChange={(v) => setSelectedDriverId(v)}
          showSearch
          optionFilterProp="label"
          options={drivers.map((d) => ({
            value: d.id,
            label: `${d.username} (#${d.id})`,
          }))}
        />
      </Modal>

      <Modal
        title="Хаяг солих — татгалзах"
        open={rejectOpen}
        onCancel={() => !actionLoading && setRejectOpen(false)}
        okText="Илгээх"
        cancelText="Болих"
        confirmLoading={actionLoading}
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
