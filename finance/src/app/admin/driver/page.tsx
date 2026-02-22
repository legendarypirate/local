'use client';

import React, { useEffect, useState } from 'react';
import { Table, Card } from 'antd';
import type { TableColumnsType } from 'antd';

interface DriverWithCount {
  id: number;
  username: string;
  deliveryCountStatus2: number;
}

export default function DriverPage() {
  const [data, setData] = useState<DriverWithCount[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    document.title = 'Жолооч';
    const fetchData = async () => {
      setLoading(true);
      try {
        const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/drivers-with-stats`);
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
    };
    fetchData();
  }, []);

  const getCountBg = (val: number) => {
    if (val > 20) return { backgroundColor: '#ffcccc' };
    if (val > 10) return { backgroundColor: '#ffe0cc' };
    if (val === 0) return { backgroundColor: '#d4edda' };
    return undefined;
  };

  const columns: TableColumnsType<DriverWithCount> = [
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
        <span style={{ padding: '4px 8px', borderRadius: 4, ...getCountBg(val) }}>
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
      />
    </Card>
  );
}
