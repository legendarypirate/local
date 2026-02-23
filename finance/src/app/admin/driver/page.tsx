'use client';

import React, { useEffect, useState, useCallback } from 'react';
import { Table, Card } from 'antd';
import type { TableColumnsType } from 'antd';
import { HolderOutlined } from '@ant-design/icons';

const DRIVER_ORDER_KEY = 'driver-page-order';

interface DriverWithCount {
  id: number;
  username: string;
  deliveryCountStatus2: number;
}

function loadSavedOrder(): number[] {
  if (typeof window === 'undefined') return [];
  try {
    const raw = localStorage.getItem(DRIVER_ORDER_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed.map(Number).filter((n) => !Number.isNaN(n)) : [];
  } catch {
    return [];
  }
}

function saveOrder(ids: number[]) {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(DRIVER_ORDER_KEY, JSON.stringify(ids));
  } catch {}
}

function applyOrder(list: DriverWithCount[], orderIds: number[]): DriverWithCount[] {
  if (!orderIds.length) return list;
  const byId = new Map(list.map((d) => [d.id, d]));
  const ordered: DriverWithCount[] = [];
  for (const id of orderIds) {
    const row = byId.get(id);
    if (row) {
      ordered.push(row);
      byId.delete(id);
    }
  }
  byId.forEach((row) => ordered.push(row));
  return ordered;
}

export default function DriverPage() {
  const [data, setData] = useState<DriverWithCount[]>([]);
  const [loading, setLoading] = useState(true);
  const [draggedIndex, setDraggedIndex] = useState<number | null>(null);

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/drivers-with-stats`);
      const result = await res.json();
      const list: DriverWithCount[] = result.success && Array.isArray(result.data)
        ? (result.data as DriverWithCount[]).map((row) => ({
            id: Number(row.id),
            username: String(row?.username ?? ''),
            deliveryCountStatus2: Number(row?.deliveryCountStatus2 ?? 0),
          }))
        : [];
      const orderIds = loadSavedOrder();
      setData(applyOrder(list, orderIds));
    } catch {
      setData([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    document.title = 'Жолооч';
    fetchData();
  }, [fetchData]);

  const moveRow = useCallback((fromIndex: number, toIndex: number) => {
    if (fromIndex === toIndex) return;
    setData((prev) => {
      const next = [...prev];
      const [removed] = next.splice(fromIndex, 1);
      next.splice(toIndex, 0, removed);
      saveOrder(next.map((d) => d.id));
      return next;
    });
  }, []);

  const handleDragStart = (e: React.DragEvent<HTMLTableRowElement>, index: number) => {
    setDraggedIndex(index);
    e.dataTransfer.effectAllowed = 'move';
    e.dataTransfer.setData('text/plain', String(index));
    e.dataTransfer.setData('application/json', JSON.stringify({ index }));
  };

  const handleDragOver = (e: React.DragEvent<HTMLTableRowElement>, index: number) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
  };

  const handleDrop = (e: React.DragEvent<HTMLTableRowElement>, toIndex: number) => {
    e.preventDefault();
    setDraggedIndex(null);
    const fromIndex = draggedIndex ?? parseInt(e.dataTransfer.getData('text/plain'), 10);
    if (Number.isNaN(fromIndex)) return;
    moveRow(fromIndex, toIndex);
  };

  const handleDragEnd = () => {
    setDraggedIndex(null);
  };

  const getCountBg = (val: number) => {
    if (val > 20) return { backgroundColor: '#ffcccc' };
    if (val > 10) return { backgroundColor: '#ffe0cc' };
    if (val === 0) return { backgroundColor: '#d4edda' };
    return undefined;
  };

  const columns: TableColumnsType<DriverWithCount> = [
    {
      key: 'drag',
      width: 40,
      align: 'center',
      render: () => (
        <HolderOutlined style={{ cursor: 'grab', color: '#999' }} />
      ),
    },
    {
      title: 'Жолоочийн нэр',
      dataIndex: 'username',
      key: 'username',
    },
    {
      title: 'Хүргэж буй хүргэлтийн тоо (төлөв 2)',
      dataIndex: 'deliveryCountStatus2',
      key: 'deliveryCountStatus2',
      align: 'right',
      render: (val: number) => (
        <span style={{ padding: '4px 8px', borderRadius: 4, ...getCountBg(Number(val)) }}>
          {val}
        </span>
      ),
    },
  ];

  return (
    <Card title="Жолооч — хүргэж буй хүргэлтийн тоо (төлөв 2)">
      <Table
        rowKey="id"
        loading={loading}
        columns={columns}
        dataSource={data}
        pagination={{ pageSize: 50, showSizeChanger: true, showTotal: (t) => `Нийт ${t} жолооч` }}
        onRow={(_, index) => ({
          draggable: true,
          onDragStart: (e) => handleDragStart(e, index ?? 0),
          onDragOver: (e) => handleDragOver(e, index ?? 0),
          onDrop: (e) => handleDrop(e, index ?? 0),
          onDragEnd: handleDragEnd,
          style: index === draggedIndex ? { opacity: 0.5 } : undefined,
        })}
      />
    </Card>
  );
}
