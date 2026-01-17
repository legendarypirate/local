'use client';

import React, { useState, useMemo,useRef,useEffect } from 'react';
import { Table, Button, Space, Input, DatePicker, Drawer, Form ,Select,Tag,Modal} from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { EditOutlined, DeleteOutlined } from '@ant-design/icons';
import dayjs from 'dayjs';
import isSameOrAfter from 'dayjs/plugin/isSameOrAfter';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';

dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);
interface Region {
  id: number;
  name: string;
}



export default function DeliveryPage() {
  const [selectedRowKeys, setSelectedRowKeys] = useState<React.Key[]>([]);
  const [form] = Form.useForm();
  const [isDrawerVisible, setIsDrawerVisible] = useState(false);
  const [regionData, setRegionData] = useState<Region[]>([]);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 });

const columns: ColumnsType<Region> = [
  {
    title: 'Үүссэн огноо',
    dataIndex: 'createdAt',
    render: (text: string) => {
      return dayjs(text).format('YYYY-MM-DD hh:mm A'); // Format the date here
    },
  },

  {
    title: 'Нэр',
    dataIndex: 'name',
    key: 'name',
    render: (_: any, record: any) => (
      <Tag color={record.color}>
        {record.name}
      </Tag>
    ),
  }, {
    title: 'Үйлдэл',
    key: 'actions',
    render: (_: any, record: Region) => (
      <Space>
        <Button
          type="link"
          icon={<EditOutlined />}
          onClick={() => alert(`Edit ${record.name}`)}
        >
          Edit
        </Button>
        <Button
          type="link"
          danger
          icon={<DeleteOutlined />}
          onClick={() => handleDelete(record.id)}
        >
          Delete
        </Button>
      </Space>
    ),
  },
];

  const handleDelete = async (id: number) => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/ware/${id}`, {
        method: "DELETE",
      });
  
      if (response.ok) {
        console.log("Deleted successfully");
        const refreshed = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/ware`);
        const refreshedResult = await refreshed.json();
        if (refreshedResult.success) {
            setRegionData(refreshedResult.data);
        }
      } else {
        console.error("Failed to delete");
      }
    } catch (error) {
      console.error("Error deleting:", error);
    }
  };
  useEffect(() => {
    document.title = 'Хүргэлтийн төлөв';
    const fetchData = async () => {
      try {
     
  
        // Always fetch deliveries on page/size change
        const deliveryRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/ware`);
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

  // Handle form submission (for example, you could save data here)
  const handleOk = async () => {
    try {
      const values = await form.validateFields();
  
      // Construct the request payload
      const payload = {
        name: values.name,
      };
  
      // Send the POST request
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/ware`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });
  
      const result = await response.json();
  
      if (result.success) {
        // Optionally refresh the delivery list
        const refreshed = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/ware`);
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
      <h1 style={{ marginBottom: 24 }}>Агуулах</h1>

      <Space style={{ marginBottom: 16 }} wrap>
       
         <Button
          type="primary"
          style={{ marginLeft: 'auto' }}
          onClick={handleDeliveryButton}
        >
          + Агуулах үүсгэх
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
        title="Агуулах үүсгэх"
        placement="right"
        visible={isDrawerVisible}
        onClose={handleCloseDrawer}
        width="400px"  // Adjust the width as needed
        height="100%"  // Full height
        bodyStyle={{ padding: '20px' }}
      >
        <Form form={form} layout="vertical">

          <Form.Item
            label="Агуулахын нэр"
            name="name"
            rules={[{ required: true, message: 'Please input the ware!' }]}
          >
            <Input placeholder="Нэр оруулах" />
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