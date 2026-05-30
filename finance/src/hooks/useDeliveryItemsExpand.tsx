'use client';

import { useCallback, useState } from 'react';
import { Table } from 'antd';
import type { TableProps } from 'antd';

const api = process.env.NEXT_PUBLIC_API_URL || '';

export interface DeliveryItem {
  id: number;
  good_id: number;
  quantity: number;
  good?: { name?: string };
}

async function fetchDeliveryItems(deliveryId: number): Promise<DeliveryItem[]> {
  try {
    const response = await fetch(`${api}/api/delivery/${deliveryId}/items`);
    if (!response.ok) return [];
    const data = await response.json();
    if (data.success && Array.isArray(data.data)) return data.data;
    return [];
  } catch {
    return [];
  }
}

/** Expandable row config for delivery items (same pattern as DeliveryClient). */
export function useDeliveryItemsExpand<T extends { id: number }>(
  getDeliveryId: (row: T) => number | undefined
): Pick<TableProps<T>, 'expandable'> {
  const [expandedRowKeys, setExpandedRowKeys] = useState<React.Key[]>([]);
  const [expandedItems, setExpandedItems] = useState<Record<number, DeliveryItem[] | null>>({});
  const [loadingRowKeys, setLoadingRowKeys] = useState<React.Key[]>([]);

  const handleExpand = useCallback(
    async (expanded: boolean, record: T) => {
      if (expanded) {
        setExpandedRowKeys([record.id]);
        const deliveryId = getDeliveryId(record);
        if (!deliveryId) return;
        if (!expandedItems[deliveryId]) {
          setLoadingRowKeys((prev) => [...prev, record.id]);
          const items = await fetchDeliveryItems(deliveryId);
          setExpandedItems((prev) => ({ ...prev, [deliveryId]: items }));
          setLoadingRowKeys((prev) => prev.filter((k) => k !== record.id));
        }
      } else {
        setExpandedRowKeys([]);
      }
    },
    [expandedItems, getDeliveryId]
  );

  const expandable: TableProps<T>['expandable'] = {
    expandedRowRender: (record) => {
      const deliveryId = getDeliveryId(record);
      if (!deliveryId) return <p>Хүргэлт олдсонгүй.</p>;
      if (loadingRowKeys.includes(record.id)) return <p>Бараа ачааллаж байна...</p>;
      const items = expandedItems[deliveryId];
      if (!items || items.length === 0) return <p>Бараа байхгүй.</p>;

      return (
        <Table
          size="small"
          bordered
          pagination={false}
          rowKey="id"
          dataSource={items}
          columns={[
            {
              dataIndex: ['good', 'name'],
              key: 'name',
              render: (text: string | undefined) => text || '-',
            },
            { dataIndex: 'quantity', key: 'quantity' },
          ]}
        />
      );
    },
    expandedRowKeys,
    onExpand: handleExpand,
    expandRowByClick: false,
  };

  return { expandable };
}
