'use client';

import React, { useState, useEffect } from 'react';
import { Table, Button, Space, Select, Tag, Switch, DatePicker,Drawer } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import {EyeOutlined } from '@ant-design/icons';
import dayjs, { Dayjs } from 'dayjs';
import isSameOrAfter from 'dayjs/plugin/isSameOrAfter';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';

dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);

const { Option } = Select;
const { RangePicker } = DatePicker;

// ---- Delivery interface ----
interface SummaryType {
  id: number;
  total: number;
  driver_calculation: number | string;
  account: number;
  comment: string;
  driver_summaries: { username: string };
  createdAt: string;
  merchant: { username: string };
  
}
export interface DeliveryType {
  id: number;
  merchant_id: number;
  phone: string;
  address: string;
  driver_id: number;
  price: string;
  status: number;
  createdAt: string;
  merchant: {
    username: string;
  };
  status_name: {
    status: string;
    color: string;
  };
}

// Delivery Table Columns

// ---- Summary interface ----

type OptionType = {
  id: string;
  username: string;
};

export default function DeliveryPage() {
  // Delivery states
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 });
  const [loadingDeliveries, setLoadingDeliveries] = useState(false);

  // Summary & filters states
  const [merchantFilter, setMerchantFilter] = useState<string | null>(null);
  const [secondOptions, setSecondOptions] = useState<OptionType[]>([]);
  const [secondValue, setSecondValue] = useState<string | null>(null);
  const [loadingOptions, setLoadingOptions] = useState(false);
  const [dateRange, setDateRange] = useState<[Dayjs | null, Dayjs | null]>([null, null]);
  const [isReportMergeMode, setIsReportMergeMode] = useState(true);
  const [selectedDate, setSelectedDate] = useState<Dayjs | null>(null);
  const [summary, setSummary] = useState<SummaryType | null>(null);
  const [fetchingSummary, setFetchingSummary] = useState(false);
  const [fetchError, setFetchError] = useState<string | null>(null);
  const [tableData, setTableData] = useState<SummaryType[]>([]);
  const [loading, setLoading] = useState(false);
  const [drawerVisible, setDrawerVisible] = useState(false);
  const [deliveryList, setDeliveryList] = useState<DeliveryType[]>([]);
  const [selectedReportId, setSelectedReportId] = useState<number | null>(null);
  const [drawerLoading, setDrawerLoading] = useState(false);
  
  // Get user data from localStorage
  const [userRole, setUserRole] = useState<number | null>(null);
  const [userId, setUserId] = useState<string | null>(null);
  const [username, setUsername] = useState<string | null>(null);

  // Initialize user data from localStorage
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const userData = localStorage.getItem('user');
      const role = localStorage.getItem('role');
      
      if (userData) {
        const user = JSON.parse(userData);
        setUserRole(user.role);
        setUserId(user.id.toString());
        setUsername(user.username);
        
        // If user is merchant (role 2), automatically set merchant filter and ID
        if (user.role === 2) {
          setMerchantFilter('1');
          setSecondValue(user.id.toString());
        }
      } else if (role) {
        setUserRole(parseInt(role));
      }
    }
  }, []);

  const deliveryColumns: ColumnsType<DeliveryType> = [
    {
      title: 'Мерчант',
      dataIndex: ['merchant', 'username'],
      render: (_, record) => record.merchant?.username || '-',
    },
    {
      title: 'Утас',
      dataIndex: 'phone',
    },
    {
      title: 'Хаяг',
      dataIndex: 'address',
    },
    {
      title: 'Үнэ',
      dataIndex: 'price',
    },
    {
      title: 'Төлөв',
      key: 'status',
      render: (_, record) => {
        const label = record.status_name?.status || 'N/A';
        const color = record.status_name?.color || 'default';
        return <Tag color={color}>{label}</Tag>;
      },
    },
    {
      title: 'Огноо',
      dataIndex: 'createdAt',
      render: (text: string) => dayjs(text).format('YYYY-MM-DD hh:mm A'),
    },
  ];

  // Fetch options when merchantFilter changes
  useEffect(() => {
    document.title = 'Тайлан харах';

    // Skip fetching options if user is merchant (role 2)
    if (userRole === 2) {
      return;
    }

    const fetchOptions = async () => {
      if (!merchantFilter) {
        setSecondOptions([]);
        return;
      }
      setLoadingOptions(true);
      try {
        const url =
          merchantFilter === '1'
            ? `${process.env.NEXT_PUBLIC_API_URL}/api/user/merchant`
            : `${process.env.NEXT_PUBLIC_API_URL}/api/user/drivers`;

        const response = await fetch(url);
        const result = await response.json();
        if (result.success && Array.isArray(result.data)) {
          setSecondOptions(result.data);
        } else {
          setSecondOptions([]);
        }
      } catch (error) {
        console.error('Fetch error:', error);
        setSecondOptions([]);
      } finally {
        setLoadingOptions(false);
      }
    };

    fetchOptions();
    setSecondValue(null);
    setSummary(null);
    setTableData([]);
  }, [merchantFilter, userRole]);

  const handleShowDeliveries = async (reportId: number) => {
    setDrawerVisible(true);
    setDrawerLoading(true);
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/report/${reportId}/deliveries`);
      const result = await res.json();
      setDeliveryList(result.success ? result.data : []);
    } catch {
      setDeliveryList([]);
    } finally {
      setDrawerLoading(false);
    }
  };

  // Fetch driver summary function
  const fetchSummary = async (userId: string, startDate: string, endDate: string) => {
    setFetchingSummary(true);
    setFetchError(null);
  
    try {
      const query = new URLSearchParams({
        user_id: userId,
        startDate,
        endDate,
      }).toString();
  
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/summary?${query}`);
      const result = await response.json();
  
      if (!response.ok || !result.success) {
        throw new Error(result.message || 'Failed to fetch summary.');
      }
  
      setTableData(result.data || []);
    } catch (error: any) {
      setFetchError(`Error: ${error.message || error}`);
      setSummary(null);
      setTableData([]);
    } finally {
      setFetchingSummary(false);
    }
  };

  const summaryColumns: ColumnsType<SummaryType> = [
    {
      title: 'Үүссэн огноо',
      dataIndex: 'createdAt',
      render: (text: string) => dayjs(text).format('YYYY-MM-DD hh:mm A'),
    },
    {
      title: 'Мерчант нэр',
      dataIndex: ['merchant', 'username'],
      render: (_, record) => record.merchant?.username || '-',
    },
    {
      title: 'Жолоочийн нэр',
      dataIndex: ['driver', 'username'],
      render: (_, record) => record.driver_summaries?.username || '-',
    },
    { title: 'Нийт', dataIndex: 'total' },
    { title: 'Жолоочийн цалин', dataIndex: 'driver' },
    { title: 'Тооцоо', dataIndex: 'account' },
    {
      title: 'Үзэх',
      key: 'actions',
      render: (_: any, record: SummaryType) => (
        <Space>
            <Button
            type="link"
            icon={<EyeOutlined />}
            onClick={() => handleShowDeliveries(record.id)}
          >
            Хүргэлтүүд харах
          </Button>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ display: 'flex', flexDirection: 'column', height: '100vh' }}>
      {/* Filters & Controls */}
      <div className="flex gap-4 items-center w-full p-4" style={{ flexShrink: 0 }}>
        {/* Hide switch for merchant users */}
        {userRole !== 2 && (
          <Switch
            checked={isReportMergeMode}
            onChange={(checked) => {
              setIsReportMergeMode(checked);
              setDateRange([null, null]);
            }}
            checkedChildren="Тайлан нийлэх"
            unCheckedChildren="Тайлан харах"
            style={{
              backgroundColor: isReportMergeMode ? undefined : '#52c41a',
              color: 'white',
            }}
          />
        )}
        
        {/* Hide merchant filter for merchant users */}
        {userRole !== 2 && (
          <Select
            value={merchantFilter}
            onChange={(value) => {
              setMerchantFilter(value);
              setSummary(null);
              setFetchError(null);
              setTableData([]);
            }}
            placeholder="Сонгох"
            style={{ width: 150 }}
            allowClear
          >
            <Option value="1">Мерчант</Option>
            <Option value="2">Жолооч</Option>
          </Select>
        )}

        {/* Show user info for merchant users, hide selection for others */}
        {userRole === 2 ? (
          <div style={{ 
            padding: '8px 12px', 
            border: '1px solid #d9d9d9', 
            borderRadius: '6px',
            backgroundColor: '#f5f5f5',
            minWidth: '200px'
          }}>
            <div style={{ fontWeight: 'bold' }}>Мерчант:</div>
            <div>{username || 'Loading...'}</div>
          </div>
        ) : (
          <Select
            value={secondValue}
            onChange={(value) => {
              setSecondValue(value);
              setSummary(null);
              setFetchError(null);
              setTableData([]);
            }}
            placeholder="Select Option"
            style={{ width: 200 }}
            loading={loadingOptions}
            allowClear
            disabled={!merchantFilter}
            options={secondOptions.map((o) => ({ label: o.username, value: o.id }))}
          />
        )}
        
        <RangePicker
          value={dateRange}
          onChange={(dates) => {
            setDateRange(dates ?? [null, null]);
            if (dates && dates[0] && dates[1]) {
              // Use the appropriate user ID based on role
              const targetUserId = userRole === 2 ? userId : secondValue;
              if (targetUserId) {
                fetchSummary(
                  targetUserId,
                  dates[0].format('YYYY-MM-DD'),
                  dates[1].format('YYYY-MM-DD')
                );
              }
            }
          }}
          format="YYYY-MM-DD"
        />
      </div>

      {/* Delivery Data Table */}
      <div style={{ flexGrow: 1, overflowY: 'auto', padding: '0 24px 80px 24px' }}>
        <Table
          columns={summaryColumns}
          dataSource={tableData}
          loading={loadingDeliveries}
          pagination={{
            current: pagination.current,
            pageSize: pagination.pageSize,
            total: pagination.total,
            onChange: (page, pageSize) => setPagination({ current: page, pageSize, total: pagination.total }),
          }}
          rowKey="id"
          scroll={{ x: 1200 }}
        />
      </div>

      {/* Summary Table Fixed at Bottom */}
      <Drawer
        title="Холбогдох хүргэлтүүд"
        placement="bottom"
        onClose={() => setDrawerVisible(false)}
        open={drawerVisible}
        height="50%"
      >
        <Table
          dataSource={deliveryList}
          columns={deliveryColumns}
          loading={drawerLoading}
          rowKey="id"
        />
      </Drawer>
    </div>
  );
}