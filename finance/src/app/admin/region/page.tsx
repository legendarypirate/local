'use client';

import React, { useCallback, useEffect, useState } from 'react';
import {
  App,
  Button,
  Card,
  Col,
  Form,
  Input,
  Modal,
  Row,
  Select,
  Space,
  Table,
  Tabs,
  Tag,
  Transfer,
  Typography,
} from 'antd';
import type { TableColumnsType, TransferProps } from 'antd';
import { DeleteOutlined, EditOutlined, PlusOutlined } from '@ant-design/icons';

const api = process.env.NEXT_PUBLIC_API_URL || '';

interface Driver {
  id: number;
  username: string;
}

interface ServiceRegion {
  id: number;
  name: string;
  driver_id: number | null;
  is_rural: boolean;
  khoroo_count?: number;
  driver?: { id: number; username: string } | null;
  khoroos?: { id: number; name: string; region?: { id: number; name: string } }[];
}

interface District {
  id: number;
  name: string;
}

interface KhorooRow {
  id: number;
  name: string;
  region_id: number;
}

interface GroupedKhoroo {
  district_id: number;
  district_name: string;
  khoroos: { id: number; name: string; assigned_service_region_id: number | null }[];
}

export default function ServiceRegionsAdminPage() {
  const { message: msg } = App.useApp();
  const [regions, setRegions] = useState<ServiceRegion[]>([]);
  const [drivers, setDrivers] = useState<Driver[]>([]);
  const [loading, setLoading] = useState(false);
  const [createOpen, setCreateOpen] = useState(false);
  const [khorooModalOpen, setKhorooModalOpen] = useState(false);
  const [activeRegion, setActiveRegion] = useState<ServiceRegion | null>(null);
  const [groupedKhoroos, setGroupedKhoroos] = useState<GroupedKhoroo[]>([]);
  const [targetKeys, setTargetKeys] = useState<React.Key[]>([]);
  const [savingKhoroos, setSavingKhoroos] = useState(false);
  const [createForm] = Form.useForm();

  const [districts, setDistricts] = useState<District[]>([]);
  const [districtKhoroos, setDistrictKhoroos] = useState<KhorooRow[]>([]);
  const [selectedDistrictId, setSelectedDistrictId] = useState<number | null>(null);
  const [newKhorooName, setNewKhorooName] = useState('');

  const fetchRegions = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch(`${api}/api/service-region`);
      const json = await res.json();
      if (json.success) setRegions(json.data);
    } catch {
      msg.error('Бүс ачаалахад алдаа');
    } finally {
      setLoading(false);
    }
  }, [msg]);

  const fetchDrivers = useCallback(async () => {
    const res = await fetch(`${api}/api/user/drivers`);
    const json = await res.json();
    if (json.success) setDrivers(json.data);
  }, []);

  const fetchDistricts = useCallback(async () => {
    const res = await fetch(`${api}/api/region`);
    const json = await res.json();
    if (json.success) setDistricts(json.data);
  }, []);

  const fetchKhoroosForDistrict = useCallback(async (districtId: number) => {
    const res = await fetch(`${api}/api/khoroo?region_id=${districtId}`);
    const json = await res.json();
    if (json.success) setDistrictKhoroos(json.data);
  }, []);

  useEffect(() => {
    document.title = 'Хүргэлтийн бүс';
    fetchRegions();
    fetchDrivers();
    fetchDistricts();
  }, [fetchRegions, fetchDrivers, fetchDistricts]);

  const handleCreateRegion = async () => {
    const values = await createForm.validateFields();
    const res = await fetch(`${api}/api/service-region`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: values.name }),
    });
    const json = await res.json();
    if (json.success) {
      msg.success('Бүс үүслээ');
      setCreateOpen(false);
      createForm.resetFields();
      fetchRegions();
    } else {
      msg.error(json.message || 'Алдаа');
    }
  };

  const handleAssignDriver = async (region: ServiceRegion, driverId: number | null) => {
    const res = await fetch(`${api}/api/service-region/${region.id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ driver_id: driverId }),
    });
    const json = await res.json();
    if (json.success) {
      msg.success('Жолооч хадгалагдлаа');
      fetchRegions();
    } else {
      msg.error(json.message || 'Алдаа');
    }
  };

  const openKhorooAssign = async (region: ServiceRegion) => {
    if (region.is_rural) {
      msg.info('Орон нутаг бүсэд хороо хуваарилах шаардлагагүй');
      return;
    }
    setActiveRegion(region);
    const res = await fetch(`${api}/api/service-region/khoroos-grouped`);
    const json = await res.json();
    if (json.success) {
      setGroupedKhoroos(json.data);
      const assigned: React.Key[] = [];
      json.data.forEach((d: GroupedKhoroo) => {
        d.khoroos.forEach((k) => {
          if (k.assigned_service_region_id === region.id) assigned.push(k.id);
        });
      });
      setTargetKeys(assigned);
      setKhorooModalOpen(true);
    }
  };

  const transferDataSource = groupedKhoroos.flatMap((d) =>
    d.khoroos.map((k) => ({
      key: String(k.id),
      title: `${d.district_name} — ${k.name}`,
      disabled: k.assigned_service_region_id != null && k.assigned_service_region_id !== activeRegion?.id,
    }))
  );

  const handleSaveKhoroos: TransferProps['onChange'] = async (nextKeys) => {
    setTargetKeys(nextKeys);
  };

  const submitKhoroos = async () => {
    if (!activeRegion) return;
    setSavingKhoroos(true);
    try {
      const res = await fetch(`${api}/api/service-region/${activeRegion.id}/khoroos`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ khoroo_ids: targetKeys.map((k) => Number(k)) }),
      });
      const json = await res.json();
      if (json.success) {
        msg.success('Хороо хадгалагдлаа');
        setKhorooModalOpen(false);
        fetchRegions();
      } else {
        msg.error(json.message || 'Алдаа');
      }
    } finally {
      setSavingKhoroos(false);
    }
  };

  const handleDeleteRegion = async (id: number) => {
    const res = await fetch(`${api}/api/service-region/${id}`, { method: 'DELETE' });
    const json = await res.json();
    if (json.success) {
      msg.success('Устгагдлаа');
      fetchRegions();
    } else {
      msg.error(json.message || 'Алдаа');
    }
  };

  const addKhorooToDistrict = async () => {
    if (!selectedDistrictId || !newKhorooName.trim()) return;
    const res = await fetch(`${api}/api/khoroo`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name: newKhorooName.trim(), region_id: selectedDistrictId }),
    });
    const json = await res.json();
    if (json.success) {
      msg.success('Хороо нэмэгдлээ');
      setNewKhorooName('');
      fetchKhoroosForDistrict(selectedDistrictId);
    } else {
      msg.error(json.message || 'Алдаа');
    }
  };

  const columns: TableColumnsType<ServiceRegion> = [
    { title: 'Бүс', dataIndex: 'name', render: (n, r) => (r.is_rural ? <Tag color="green">{n}</Tag> : n) },
    {
      title: 'Жолооч',
      key: 'driver',
      render: (_, r) => (
        <Select
          allowClear
          showSearch
          placeholder="Жолооч сонгох"
          style={{ minWidth: 180 }}
          value={r.driver_id ?? undefined}
          optionFilterProp="label"
          options={drivers.map((d) => ({ value: d.id, label: d.username }))}
          onChange={(v) => handleAssignDriver(r, typeof v === 'number' ? v : null)}
        />
      ),
    },
    {
      title: 'Хороо',
      dataIndex: 'khoroo_count',
      width: 90,
      render: (c, r) => (r.is_rural ? '—' : c ?? 0),
    },
    {
      title: 'Үйлдэл',
      key: 'action',
      render: (_, r) => (
        <Space>
          {!r.is_rural && (
            <Button size="small" icon={<EditOutlined />} onClick={() => openKhorooAssign(r)}>
              Хороо хуваарилах
            </Button>
          )}
          {!r.is_rural && (
            <Button size="small" danger icon={<DeleteOutlined />} onClick={() => handleDeleteRegion(r.id)}>
              Устгах
            </Button>
          )}
        </Space>
      ),
    },
  ];

  const regionsTab = (
    <>
      <Typography.Paragraph type="secondary">
        1р бүс, 2р бүс гэх мэт бүс үүсгээд дүүргийн хороонуудыг хуваарилна. Бүс бүрт жолооч онооно.{' '}
        <strong>Орон нутаг</strong> бүс анхдагчаар үүссэн — хаяг сонгохдоо «Орон нутаг» сонговол энэ бүсийн жолоочид
        очно.
      </Typography.Paragraph>
      <Button type="primary" icon={<PlusOutlined />} onClick={() => setCreateOpen(true)} style={{ marginBottom: 16 }}>
        Бүс нэмэх (1р, 2р, …)
      </Button>
      <Table rowKey="id" loading={loading} columns={columns} dataSource={regions} pagination={false} />
    </>
  );

  const districtsTab = (
    <>
      <Typography.Paragraph type="secondary">
        Эхлээд 6 дүүргийн хороонуудыг бүртгэнэ (жишээ: Баянзүрх — 1-р хороо). Дараа нь дээрх бүс рүү хороо хуваарилна.
      </Typography.Paragraph>
      <Row gutter={16}>
        <Col xs={24} md={8}>
          <Card title="Дүүрэг" size="small">
            <Select
              style={{ width: '100%', marginBottom: 12 }}
              placeholder="Дүүрэг сонгох"
              value={selectedDistrictId ?? undefined}
              onChange={(v) => {
                setSelectedDistrictId(v);
                if (v) fetchKhoroosForDistrict(v);
              }}
              options={districts.map((d) => ({ value: d.id, label: d.name }))}
            />
            <Input
              placeholder="Шинэ хорооны нэр (жишээ: 1-р хороо)"
              value={newKhorooName}
              onChange={(e) => setNewKhorooName(e.target.value)}
              onPressEnter={addKhorooToDistrict}
            />
            <Button type="primary" block style={{ marginTop: 8 }} onClick={addKhorooToDistrict} disabled={!selectedDistrictId}>
              Хороо нэмэх
            </Button>
          </Card>
        </Col>
        <Col xs={24} md={16}>
          <Card title="Хороонууд" size="small">
            <Table
              rowKey="id"
              size="small"
              pagination={false}
              dataSource={districtKhoroos}
              columns={[
                { title: 'ID', dataIndex: 'id', width: 60 },
                { title: 'Нэр', dataIndex: 'name' },
              ]}
            />
          </Card>
        </Col>
      </Row>
    </>
  );

  return (
    <div style={{ padding: 24 }}>
      <Typography.Title level={3}>Хүргэлтийн бүс</Typography.Title>
      <Tabs
        items={[
          { key: 'regions', label: 'Бүс & жолооч', children: regionsTab },
          { key: 'districts', label: 'Дүүрэг & хороо бүртгэл', children: districtsTab },
        ]}
      />

      <Modal title="Шинэ бүс" open={createOpen} onOk={handleCreateRegion} onCancel={() => setCreateOpen(false)} okText="Үүсгэх">
        <Form form={createForm} layout="vertical">
          <Form.Item name="name" label="Бүсийн нэр" rules={[{ required: true }]} extra="Жишээ: 1-р бүс, 2-р бүс">
            <Input placeholder="1-р бүс" />
          </Form.Item>
        </Form>
      </Modal>

      <Modal
        title={activeRegion ? `Хороо хуваарилах — ${activeRegion.name}` : 'Хороо'}
        open={khorooModalOpen}
        onCancel={() => setKhorooModalOpen(false)}
        width={720}
        footer={[
          <Button key="c" onClick={() => setKhorooModalOpen(false)}>
            Болих
          </Button>,
          <Button key="s" type="primary" loading={savingKhoroos} onClick={submitKhoroos}>
            Хадгалах
          </Button>,
        ]}
      >
        <Typography.Paragraph type="secondary" style={{ marginBottom: 12 }}>
          Баруун талд сонгогдсон хороонууд энэ бүсэд орно. Өөр бүсэд байгаа хороо саарал (эхлээд тэр бүсээс хасна).
        </Typography.Paragraph>
        <Transfer
          dataSource={transferDataSource}
          titles={['Боломжтой', `${activeRegion?.name ?? ''} бүсэд`]}
          targetKeys={targetKeys}
          onChange={handleSaveKhoroos}
          render={(item) => item.title ?? ''}
          listStyle={{ width: 300, height: 360 }}
          showSearch
        />
      </Modal>
    </div>
  );
}
