'use client';

import React, { useState, useMemo,useEffect } from 'react';
import { Table, Button, Space, Input, DatePicker, Drawer, Form ,Select,Tag,Modal} from 'antd';
import type { TableColumnsType } from 'antd';
import { EditOutlined, DeleteOutlined } from '@ant-design/icons';
import dayjs, { Dayjs } from 'dayjs';
import isSameOrAfter from 'dayjs/plugin/isSameOrAfter';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';

const { Option } = Select;

const { RangePicker } = DatePicker;
dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);
interface Order {
  id: number;
  phone: string;
  address: string;
  status: number | string; // This is still the numeric or string status
  comment: string;
  driver: {
    username: string;
  };
  createdAt: string;
  merchant: {
    username: string;
  };
  status_name: {        // This field contains status and color information
    status: string;
    color: string;
  };
}
interface Status {
  id: number;
  label: string;
  color: string;
}



export default function DeliveryPage() {
  const [selectedRowKeys, setSelectedRowKeys] = useState<React.Key[]>([]);
  const [merchantFilter, setMerchantFilter] = useState('');
  const [dateRange, setDateRange] = useState<[Dayjs | null, Dayjs | null]>([null, null]);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [form] = Form.useForm();
  const [isDrawerVisible, setIsDrawerVisible] = useState(false);
  const [merchants, setMerchants] = useState<{ id: number; username: string }[]>([]);
  const [orderData, setOrderData] = useState<Order[]>([]);
  const [drivers, setDrivers] = useState<{ id: number; username: string }[]>([]);
  const [selectedDriverId, setSelectedDriverId] = useState<number | null>(null);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 });
  const [permissions, setPermissions] = useState<string[]>([]);

  const userData = typeof window !== 'undefined' ? localStorage.getItem('user') : null;
  const user = userData ? JSON.parse(userData) : null;
  const isMerchant = user?.role === 2;
  const username = typeof window !== 'undefined' ? localStorage.getItem('username') : null;;
  const merchantId = isMerchant ? user.id : null;
  const [statusList, setStatusList] = useState<Status[]>([
    { id: 1, label: 'Шинэ', color: 'orange' },
    { id: 2, label: 'Жолоочид', color: 'blue' },
    { id: 3, label: 'Хүргэсэн', color: 'green' },
    { id: 4, label: 'Цуцалсан', color: 'red' },
  ]);
    const [selectedStatuses, setSelectedStatuses] = useState<number[]>([]);
  const [phoneFilter, setPhoneFilter] = useState('');

  const toggleStatus = (id: number) => {
    setSelectedStatuses((prev) =>
      prev.includes(id) ? prev.filter((s) => s !== id) : [...prev, id]
    );
  };
  useEffect(() => {
    document.title = 'Татан авалт';
  
    if (isMerchant) {
      form.setFieldsValue({ merchantId: merchantId });
    }
  
    const saved = localStorage.getItem('permissions');
    if (saved) setPermissions(JSON.parse(saved));
  
    const fetchData = async () => {
      try {
        const userData = localStorage.getItem('user');
        const user = userData ? JSON.parse(userData) : null;
  
        // Fetch merchants only once
        if (merchants.length === 0) {
          const merchantRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/merchant`);
          const merchantsResult = await merchantRes.json();
          if (merchantsResult.success) {
            setMerchants(merchantsResult.data);
          }
        }
  
        const { current, pageSize } = pagination;
        let url = `${process.env.NEXT_PUBLIC_API_URL}/api/order?page=${current}&limit=${pageSize}`;
  
        if (user && user.role === 2) {
          url += `&merchant_id=${user.id}`;
        }
  
        if (phoneFilter) {
          url += `&phone=${phoneFilter}`;
        }
  
        if (selectedStatuses.length > 0) {
          url += `&status_ids=${selectedStatuses.join(',')}`;
        }
  
        if (dateRange[0] && dateRange[1]) {
          url += `&start_date=${dateRange[0].format('YYYY-MM-DD')}`;
          url += `&end_date=${dateRange[1].format('YYYY-MM-DD')}`;
        }
  
        const orderRes = await fetch(url);
        const ordersResult = await orderRes.json();
  
        if (ordersResult.success) {
          setOrderData(ordersResult.data);
          setPagination((prev) => ({
            ...prev,
            total: ordersResult.pagination.total,
          }));
        }
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    };
  
    fetchData();
  }, [
    pagination.current,
    pagination.pageSize,
    form,
    isMerchant,
    merchantId,
    phoneFilter,
    selectedStatuses,
    dateRange,
  ]);
  
  const hasPermission = (perm: string) => permissions.includes(perm);
  const columns: TableColumnsType<Order> = [
    {
      title: 'Үүссэн огноо',
      dataIndex: 'createdAt',
      render: (text: string) => {
        return dayjs(text).format('YYYY-MM-DD hh:mm A'); // Format the date here
      },
    },
    { 
      title: 'Мерчанд нэр', 
      dataIndex: ['merchant', 'username'], 
      render: (_, record) => record.merchant?.username || '-' 
    },
    { title: 'Утас', dataIndex: 'phone' },
    { title: 'Хаяг', dataIndex: 'address' },
    
    // Updated Status Column with Tag
    {
      title: 'Төлөв',
      dataIndex: 'status',
      render: (status: number) => {
        const found = statusList.find(s => s.id === status);
        return (
          <Tag color={found?.color || 'gray'}>
            {found?.label || 'Unknown'}
          </Tag>
        );
      },
    },  
    { title: 'Тайлбар', dataIndex: 'comment' },
    { 
      title: 'Жолооч нэр', 
      dataIndex: ['driver', 'username'], 
      render: (_, record) => record.driver?.username || '-' 
    },  {
      title: 'Үйлдэл',
      key: 'actions',
      render: (_: any, record: Order) => (
        <Space>
          <Button
            type="link"
            icon={<EditOutlined />}
            onClick={() => alert(`Edit ${record.merchant?.username}`)}
          >
            Edit
          </Button>
          <Button
            type="link"
            danger
            icon={<DeleteOutlined />}
            onClick={() => alert(`Delete ${record.merchant?.username}`)}
          >
            Delete
          </Button>
        </Space>
      ),
    },
  ];
  
  const rowSelection = {
    selectedRowKeys,
    onChange: (selectedKeys: React.Key[]) => {
      setSelectedRowKeys(selectedKeys);
    },
  };


  // Handle form submission (for example, you could save data here)
  const handleOk = async () => {
    try {
      const values = await form.validateFields();
  
      // Construct the request payload
      const payload = {
        merchant_id: values.merchantId,
        phone: values.phone,
        address: values.address,
        status: 1, // Default status as per your backend
        comment: values.comment,
      };
  
      // Send the POST request
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/order`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });
  
      const result = await response.json();
  
      if (result.success) {
        // Optionally refresh the delivery list
        const refreshed = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/order`);
        const refreshedResult = await refreshed.json();
        if (refreshedResult.success) {
            setOrderData(refreshedResult.data);
        }
  
        // Reset form and close drawer
        form.resetFields();
        setIsDrawerVisible(false);
      } else {
        console.error('Failed to create delivery:', result.message);
      }
    } catch (err) {
      console.error('Validation or request error:', err);
    }
  };


  const handleCloseDrawer = () => {
    setIsDrawerVisible(false);
  };
  const filteredData = useMemo(() => {
    return orderData.filter((item) => {
      const matchesMerchant = item.merchant?.username
        ?.toLowerCase()
        .includes(merchantFilter.toLowerCase());
  
      const itemDate = dayjs(item.createdAt);
  
      const matchesDate =
        !dateRange[0] ||
        !dateRange[1] ||
        (
          itemDate.isSameOrAfter(dateRange[0]?.startOf('day')) &&
          itemDate.isSameOrBefore(dateRange[1]?.endOf('day'))
        );
  
      return matchesMerchant && matchesDate;
    });
  }, [orderData, merchantFilter, dateRange]);
  

  const handleAllocateToDriver = async () => {
    if (selectedRowKeys.length === 0) {
      alert('Please select at least one delivery.');
      return;
    }

    // Fetch drivers only when this function is called
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/drivers`);
      const result = await response.json();
      
      if (result.success) {
        setDrivers(result.data); // Set the list of drivers
        setIsModalVisible(true); // Open the modal
      } else {
        alert('Failed to load drivers.');
      }
    } catch (error) {
      console.error('Error fetching drivers:', error);
      alert('Error fetching drivers.');
    }
  };

  const handleDriverSelection = (value: number) => {
    setSelectedDriverId(value); // Set the selected driver ID
  };

  const handleSaveAllocation = async () => {
    if (!selectedDriverId) {
      alert('Please select a driver!');
      return;
    }
  
    // Send the selected driver ID and the selected delivery IDs to the backend
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/order/allocate`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          driver_id: selectedDriverId,
          delivery_ids: selectedRowKeys, // Pass the selected delivery IDs
        }),
      });
  
      const result = await response.json();
  
      if (result.success) {
        // Close the modal and reset the state
        setIsModalVisible(false);
        setSelectedDriverId(null);
        alert('Deliveries allocated to the driver successfully.');
  
        // Fetch updated delivery data here to refresh the table
        const updatedDeliveriesResponse = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/order`);
        const updatedDeliveries = await updatedDeliveriesResponse.json();
  
        if (updatedDeliveries.success) {
          // Update the state with the new deliveries data
          setOrderData(updatedDeliveries.data);
        } else {
          alert('Failed to fetch updated deliveries data.');
        }
      } else {
        alert('Failed to allocate deliveries.');
      }
    } catch (error) {
      console.error('Error allocating deliveries:', error);
    }
  };
  
  return (
    <div style={{ paddingBottom: '100px' }}> {/* Adding padding to prevent overlap with fixed button */}
      <h1 style={{ marginBottom: 24 }}>Татан авалт</h1>

      <Space style={{ marginBottom: 16 }} wrap>
  <Input
    placeholder="Filter by Phone"
    value={phoneFilter}
    onChange={(e) => setPhoneFilter(e.target.value)}
    allowClear
  />
  <RangePicker
    value={dateRange}
    onChange={(range) => {
      setDateRange(range ?? [null, null]);
    }}
  />
 {statusList.map((status) => (
  <Tag
    key={status.id}
    color={status.color}
    onClick={() => toggleStatus(status.id)}
    style={{
      cursor: 'pointer',
      userSelect: 'none',
      border: selectedStatuses.includes(status.id)
        ? '2px solid #52c41a'
        : '2px solid transparent',
      borderRadius: 4,
    }}
  >
    {status.label}
  </Tag>
))}

  {hasPermission('order:create_order') && (
    <Button
      type="primary"
      style={{ marginLeft: 'auto' }}
      onClick={() => setIsDrawerVisible(true)}
    >
      + Захиалга үүсгэх
    </Button>
  )}
</Space>

      <Table
  rowSelection={rowSelection}
  columns={columns}
  dataSource={orderData}
  rowKey="id"
  pagination={{
    position: ['bottomRight'], // 👈 This moves pagination to top-right
    current: pagination.current,
    pageSize: pagination.pageSize,
    total: pagination.total,
    showSizeChanger: true,
    onChange: (page, pageSize) => {
      setPagination((prev) => ({
        ...prev,
        current: page,
        pageSize: pageSize,
      }));
    },
  }}
/>

 <Drawer
        title="Захиалга үүсгэх"
        placement="right"
        open={isDrawerVisible}
        onClose={handleCloseDrawer}
        width="400px"  // Adjust the width as needed
        height="100%"  // Full height
        styles={{ body: { padding: '20px' } }}
      >
        <Form form={form} layout="vertical">
        <Form.Item
  label="Дэлгүүрийн нэр"
  name="merchantId"
  rules={[{ required: true, message: 'Please select a merchant!' }]}
>
  {isMerchant ? (
    <>
      <div style={{
        padding: '4px 11px',
        border: '1px solid #d9d9d9',
        borderRadius: 2,
        backgroundColor: '#f5f5f5',
        color: 'rgba(0, 0, 0, 0.85)',
        minHeight: 32,
      }}>
        {username}
      </div>
      {/* Hidden input to submit merchantId */}
      <Input type="hidden" value={merchantId} />
    </>
  ) : (
    <Select placeholder="Select a merchant">
      {merchants.map((merchant) => (
        <Select.Option key={merchant.id} value={merchant.id}>
          {merchant.username}
        </Select.Option>
      ))}
    </Select>
  )}
</Form.Item>
          <Form.Item
            label="Утас"
            name="phone"
            rules={[{ required: true, message: 'Please input the phone number!' }]}
          >
            <Input placeholder="Enter phone number" />
          </Form.Item>

          <Form.Item
            label="Хаяг"
            name="address"
            rules={[{ required: true, message: 'Please input the address!' }]}
          >
            <Input placeholder="Enter address" />
          </Form.Item>
          
          <Form.Item
            label="Тайлбар"
            name="comment"
            rules={[{ required: true, message: 'Please input the comment!' }]}
          >
            <Input placeholder="Enter comment" />
          </Form.Item>

          <Form.Item>
            <Button type="primary" onClick={handleOk} block>
              Үүсгэх
            </Button>
          </Form.Item>
        </Form>
      </Drawer>
      {/* Fixed Bottom Section */}
      {hasPermission('order:allocate_order') && (

      <div style={{ position: 'fixed', bottom: 0, left: 0, width: '100%', background: '#fff', padding: '16px 24px', borderTop: '1px solid #ddd', zIndex: 999 }}>
        <Space style={{ marginRight: 16 }}>
          <div>
            {selectedRowKeys.length} item(s) selected
          </div>
          <Button
            type="primary"
            onClick={handleAllocateToDriver}
            disabled={selectedRowKeys.length === 0}
          >
            Allocate to Driver
          </Button>
        </Space>
        
      </div>
      )}
      <Modal
        title="Select Driver"
        open={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        onOk={handleSaveAllocation}
        okText="Save"
        cancelText="Cancel"
      >
        <Select
          style={{ width: '100%' }}
          placeholder="Select a driver"
          onChange={handleDriverSelection}
          value={selectedDriverId}
        >
          {drivers.map((driver) => (
            <Option key={driver.id} value={driver.id}>
              {driver.username}
            </Option>
          ))}
        </Select>
      </Modal>
    </div>
  );
}