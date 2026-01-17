'use client';

import React, { useState, useMemo,useRef,useEffect } from 'react';
import { Table, Button, Space, Input, Drawer, Form ,Select} from 'antd';
import type { ColumnsType } from 'antd/es/table';

import dayjs, { Dayjs } from 'dayjs';
import isSameOrAfter from 'dayjs/plugin/isSameOrAfter';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';

dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);
interface Notification {
  id: number;
  type: number;
  title: string;
  body: string;

}


const columns: ColumnsType<Notification> = [
  {
    title: 'Үүссэн огноо',
    dataIndex: 'createdAt',
    render: (text: string) => {
      return dayjs(text).format('YYYY-MM-DD hh:mm A'); // Format the date here
    },
  },
  {
    title: 'Төрөл',
    dataIndex: 'type',
    render: (type: number) => (type === 1 ? 'Харилцагч' : 'Жолооч'),
  },  
  { title: 'Гарчиг', dataIndex: 'title' },
  { title: 'Мэдээлэл', dataIndex: 'body' },

];

export default function DeliveryPage() {
  const [selectedRowKeys, setSelectedRowKeys] = useState<React.Key[]>([]);
  const [merchantFilter, setMerchantFilter] = useState('');
  const [dateRange, setDateRange] = useState<[Dayjs | null, Dayjs | null]>([null, null]);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [form] = Form.useForm();
  const [isDrawerVisible, setIsDrawerVisible] = useState(false);
  const [merchants, setMerchants] = useState<{ id: number; username: string }[]>([]);
  const [regionData, setRegionData] = useState<Notification[]>([]);
  const [drivers, setDrivers] = useState<{ id: number; username: string }[]>([]);
  const [selectedDriverId, setSelectedDriverId] = useState<number | null>(null);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 });

  const fileInputRef = useRef<HTMLInputElement | null>(null);

  useEffect(() => {
    document.title = 'Мэдэгдэл';

    const fetchData = async () => {
      try {

        // Always fetch deliveries on page/size change
        const deliveryRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/notification`);
        const deliveriesResult = await deliveryRes.json();
  
        if (deliveriesResult.success) {
            setRegionData(deliveriesResult.data);
          
        }
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    };
  
    fetchData();
  }, [pagination.current, pagination.pageSize]);
  
  
  const rowSelection = {
    selectedRowKeys,
    onChange: (selectedKeys: React.Key[]) => {
      setSelectedRowKeys(selectedKeys);
    },
  };

  const handleDeliveryButton = () => {
    setIsDrawerVisible(true);
  };

  // Handle modal cancel
  const handleCancel = () => {
    setIsModalVisible(false);
  };

  // Handle form submission (for example, you could save data here)
  const handleOk = async () => {
    try {
      const values = await form.validateFields();
  
      // Construct the request payload
      const payload = {
        title: values.title,
        body: values.body,
        type: values.type,
      };
  
      // Send the POST request
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/notification`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });
  
      const result = await response.json();
  
      if (result.success) {
        // Optionally refresh the delivery list
        const refreshed = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/notification`);
        const refreshedResult = await refreshed.json();
        if (refreshedResult.success) {
            setRegionData(refreshedResult.data);
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


  return (
    <div style={{ paddingBottom: '100px' }}> {/* Adding padding to prevent overlap with fixed button */}
      <h1 style={{ marginBottom: 24 }}>Мэдэгдэл илгээх</h1>

      <Space style={{ marginBottom: 16 }} wrap>
       
         <Button
          type="primary"
          style={{ marginLeft: 'auto' }}
          onClick={handleDeliveryButton}
        >
          + Мэдэгдэл илгээх
        </Button>
      </Space>

      <Table
  rowSelection={rowSelection}
  columns={columns}
  dataSource={regionData}
  rowKey="id"
  pagination={{
    position: ['topRight'], // 👈 This moves pagination to top-right
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
        title="Мэдэгдэл илгээх"
        placement="right"
        visible={isDrawerVisible}
        onClose={handleCloseDrawer}
        width="400px"  // Adjust the width as needed
        height="100%"  // Full height
        bodyStyle={{ padding: '20px' }}
      >
        <Form form={form} layout="vertical">
        <Form.Item
            label="Төрөл"
            name="type"
            rules={[{ required: true, message: 'Төрөл сонгоно уу!' }]}
            >
            <Select placeholder="Төрөл сонгох">
                <Select.Option value={1}>Харилцагч</Select.Option>
                <Select.Option value={2}>Жолооч</Select.Option>
            </Select>
            </Form.Item>

        <Form.Item
            label="Гарчиг"
            name="title"
            rules={[{ required: true, message: 'Please input the address!' }]}
          >
            <Input placeholder="Гарчиг оруулах" />
          </Form.Item>
          <Form.Item
            label="Мэдэгдэл"
            name="body"
            rules={[{ required: true, message: 'Please input the address!' }]}
          >
            <Input placeholder="Мэдэгдэл оруулах" />
          </Form.Item>
        
          <Form.Item>
            <Button type="primary" onClick={handleOk} block>
              Үүсгэх
            </Button>
          </Form.Item>
        </Form>
      </Drawer>
      {/* Fixed Bottom Section */}
      
    </div>
  );
}