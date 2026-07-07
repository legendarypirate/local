'use client';

import React, { useCallback, useEffect, useState } from 'react';
import {
  App,
  Button,
  DatePicker,
  Form,
  Input,
  InputNumber,
  Modal,
  Select,
  Space,
  Table,
  Tag,
  Typography,
} from 'antd';
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
  delivery_count?: number;
  amount_paid: number;
  remaining: number;
  is_paid?: boolean;
  driver?: { id: number; username: string };
  payments?: Payment[];
}

interface ReportDay {
  date: string;
  delivered_count?: string | number;
  address_visit_count?: string | number;
  delivered_total_price?: string | number;
  for_driver?: string | number;
  driver_margin?: string | number;
}

function settlementDeliveryCount(item: ReportDay): number {
  return (
    (parseInt(String(item.delivered_count ?? 0), 10) || 0) +
    (parseInt(String(item.address_visit_count ?? 0), 10) || 0)
  );
}

export default function DriverDailySettlementsPage() {
  const { message: msg } = App.useApp();
  const [form] = Form.useForm();
  const [rows, setRows] = useState<SettlementRow[]>([]);
  const [loading, setLoading] = useState(false);
  const [paySubmitting, setPaySubmitting] = useState(false);
  const [drivers, setDrivers] = useState<{ id: number; username: string }[]>([]);
  const [driverId, setDriverId] = useState<number | null>(null);
  const [dateRange, setDateRange] = useState<[Dayjs, Dayjs]>([dayjs().subtract(14, 'day'), dayjs()]);
  const [payRow, setPayRow] = useState<SettlementRow | null>(null);
  const [payModalOpen, setPayModalOpen] = useState(false);

  const fetchDrivers = useCallback(async () => {
    try {
      const res = await fetch(`${api}/api/user/drivers`);
      const json = await res.json();
      if (json.success && Array.isArray(json.data)) setDrivers(json.data);
    } catch {
      setDrivers([]);
    }
  }, []);

  const syncFromReport = useCallback(async (id: number, start: string, end: string) => {
    const reportRes = await fetch(
      `${api}/api/mobile/delivery/report?driver_id=${id}&start_date=${start}&end_date=${end}`
    );
    if (!reportRes.ok) return;
    const reportJson = await reportRes.json();
    const days = (reportJson.data as ReportDay[] | undefined)?.map((item) => ({
      date: item.date,
      total_amount: parseInt(String(item.delivered_total_price ?? 0), 10) || 0,
      driver_salary: parseInt(String(item.for_driver ?? 0), 10) || 0,
      difference: parseInt(String(item.driver_margin ?? 0), 10) || 0,
      delivery_count: settlementDeliveryCount(item),
    }));
    if (!days?.length) return;
    await fetch(`${api}/api/driver-daily-settlements/sync`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ driver_id: id, days }),
    });
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
      await syncFromReport(driverId, start, end);
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
  }, [driverId, dateRange, msg, syncFromReport]);

  const openPayModal = (row: SettlementRow) => {
    setPayRow(row);
    form.setFieldsValue({
      amount: row.remaining > 0 ? row.remaining : undefined,
      note: '',
    });
    setPayModalOpen(true);
  };

  const closePayModal = () => {
    setPayModalOpen(false);
    setPayRow(null);
    form.resetFields();
  };

  const submitPayment = async () => {
    if (!payRow || !driverId) return;
    const values = await form.validateFields();
    const amount = Math.floor(Number(values.amount));
    if (!amount || amount <= 0) {
      msg.error('Зөв дүн оруулна уу');
      return;
    }
    if (amount > payRow.remaining) {
      msg.error(`Төлбөр хэтэрсэн. Үлдэгдэл: ${payRow.remaining.toLocaleString()} ₮`);
      return;
    }

    setPaySubmitting(true);
    try {
      const res = await fetch(`${api}/api/driver-daily-settlements/payment`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          driver_id: driverId,
          settlement_date: payRow.settlement_date,
          amount,
          note: values.note?.trim() || null,
          total_amount: payRow.total_amount,
          driver_salary: payRow.driver_salary,
        }),
      });
      const json = await res.json();
      if (res.ok && json.success) {
        msg.success(json.message || 'Төлбөр бүртгэгдлээ');
        closePayModal();
        await fetchRows();
      } else {
        msg.error(json.message || 'Алдаа');
      }
    } catch {
      msg.error('Сервертэй холбогдож чадсангүй');
    } finally {
      setPaySubmitting(false);
    }
  };

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
      title: 'Хүргэлтийн тоо',
      dataIndex: 'delivery_count',
      width: 100,
      align: 'center',
      render: (v: number | undefined) => Number(v ?? 0).toLocaleString(),
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
      title: 'Үйлдэл',
      key: 'action',
      width: 130,
      fixed: 'right',
      render: (_, r) =>
        r.total_amount > 0 && r.remaining > 0 ? (
          <Button type="primary" size="small" onClick={() => openPayModal(r)}>
            Төлбөр бүртгэх
          </Button>
        ) : (
          <span style={{ color: '#999' }}>—</span>
        ),
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
      <Typography.Title level={4} style={{ marginBottom: 8 }}>
        Жолоочийн өдрийн тооцоо (Дүн төлбөр)
      </Typography.Title>
      <Typography.Paragraph type="secondary" style={{ marginBottom: 16 }}>
        Админ энд хэсэгчлэн эсвэл бүрэн төлбөр бүртгэнэ. Жолооч апп дээр зөвхөн үлдэгдлээ харна.
        Хүргэлтийн тоо = <strong>Хүргэсэн + Хаягаар очсон</strong> (төлөв 3 + 7). Жолоочид олгох дүн нь хүргэлт бүрт оноосон <strong>Үнийн тохиргоо</strong>-оор тооцогдоно.
      </Typography.Paragraph>
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
        scroll={{ x: 1100 }}
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

      <Modal
        title={payRow ? `Төлбөр бүртгэх — ${payRow.settlement_date}` : 'Төлбөр бүртгэх'}
        open={payModalOpen}
        onCancel={closePayModal}
        onOk={submitPayment}
        okText="Хадгалах"
        cancelText="Болих"
        confirmLoading={paySubmitting}
        destroyOnClose
      >
        {payRow && (
          <>
            <Typography.Paragraph>
              Дүн (төлөх): <strong>{payRow.total_amount.toLocaleString()} ₮</strong>
              <br />
              Төлсөн: <strong>{payRow.amount_paid.toLocaleString()} ₮</strong>
              <br />
              Үлдэгдэл:{' '}
              <strong style={{ color: '#cf1322' }}>{payRow.remaining.toLocaleString()} ₮</strong>
            </Typography.Paragraph>
            <Form form={form} layout="vertical">
              <Form.Item
                name="amount"
                label="Энэ удаагийн төлбөр (₮)"
                rules={[{ required: true, message: 'Дүн оруулна уу' }]}
              >
                <InputNumber
                  min={1}
                  max={payRow.remaining}
                  style={{ width: '100%' }}
                  formatter={(v) => `${v}`.replace(/\B(?=(\d{3})+(?!\d))/g, ',')}
                  parser={(v) => Number(String(v ?? '').replace(/[^\d]/g, '')) as unknown as 1}
                />
              </Form.Item>
              <Space style={{ marginBottom: 12 }}>
                <Button
                  size="small"
                  onClick={() => form.setFieldsValue({ amount: payRow.remaining })}
                >
                  Бүтэн үлдэгдэл ({payRow.remaining.toLocaleString()} ₮)
                </Button>
              </Space>
              <Form.Item name="note" label="Тайлбар (заавал биш)">
                <Input.TextArea rows={2} placeholder="Жишээ: дансаар шилжүүлсэн" />
              </Form.Item>
            </Form>
            <Typography.Text type="secondary" style={{ fontSize: 12 }}>
              Жишээ: Дүн 58,000₮, 46,000₮ бүртгэвэл үлдэгдэл 12,000₮ болно.
            </Typography.Text>
          </>
        )}
      </Modal>
    </div>
  );
}
