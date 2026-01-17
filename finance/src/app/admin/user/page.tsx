'use client';

import React, { useEffect, useState } from 'react';
import {
  Table,
  Button,
  Space,
  Drawer,
  Form,
  Input,
  Select,
  Modal,
  message,
} from 'antd';
import type { ColumnsType } from 'antd/es/table';
import {
  EditOutlined,
  DeleteOutlined,
  ExclamationCircleOutlined,
  SearchOutlined,
} from '@ant-design/icons';

const { Option } = Select;
const { confirm } = Modal;

interface User {
  id: number;
  username: string;
  email: string;
  phone: string;
  contact_info?: string; // ✅ Added here
  role_id: number;
  createdAt: string;
  updatedAt: string;
}

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  const [drawerVisible, setDrawerVisible] = useState(false);
  const [form] = Form.useForm();
  const [pagination, setPagination] = useState({
    current: 1,
    pageSize: 100,
    total: 0,
  });
  const [searchText, setSearchText] = useState('');

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user`);
      const result = await res.json();
      if (result.success) {
        setUsers(result.data);
      } else {
        console.error('Failed to load users:', result.message);
      }
    } catch (err) {
      console.error('Fetch error:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    document.title = 'Хэрэглэгч';
    fetchData();
  }, []);

  const filteredCustomers = users.filter(
    (user) =>
      user.role_id === 2 &&
      user.username.toLowerCase().includes(searchText.toLowerCase())
  );

  useEffect(() => {
    setPagination((prev) => ({
      ...prev,
      total: filteredCustomers.length,
    }));
  }, [filteredCustomers.length]);

  const currentPageData = filteredCustomers.slice(
    (pagination.current - 1) * pagination.pageSize,
    pagination.current * pagination.pageSize
  );

  const handleDelete = (record: User) => {
    confirm({
      title: 'Устгахдаа итгэлтэй байна уу?',
      icon: <ExclamationCircleOutlined />,
      content: `"${record.username}" устгах`,
      okText: 'Тийм',
      okType: 'danger',
      cancelText: 'Үгүй',
      onOk: async () => {
        try {
          const res = await fetch(
            `${process.env.NEXT_PUBLIC_API_URL}/api/user/${record.id}`,
            { method: 'DELETE' }
          );
          const json = await res.json();
          if (!json.success) throw new Error(json.message);
          message.success('Амжилттай устгалаа');
          fetchData();
        } catch (err) {
          console.error(err);
          message.error('Устгахад алдаа гарлаа');
        }
      },
    });
  };

  const handleCreateUser = () => {
    setDrawerVisible(true);
  };

  const handleDrawerClose = () => {
    setDrawerVisible(false);
    form.resetFields();
  };

  const handleFormSubmit = async () => {
    try {
      const values = await form.validateFields();

      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(values),
      });

      const result = await response.json();

      if (response.ok && result.success) {
        message.success('Хэрэглэгч амжилттай үүслээ');
        fetchData();
        handleDrawerClose();
      } else {
        message.error(result.message || 'Алдаа гарлаа');
      }
    } catch (error) {
      console.error('Validation or request failed:', error);
      message.error('Хэлбэр буруу байна');
    }
  };

  const handleSearch = (value: string) => {
    setSearchText(value);
    setPagination((prev) => ({ ...prev, current: 1 }));
  };

  const columns: ColumnsType<User> = [
    {
      title: 'Username',
      dataIndex: 'username',
    },
    {
      title: 'Email',
      dataIndex: 'email',
    },
    {
      title: 'Phone',
      dataIndex: 'phone',
    },
    {
      title: 'Contact Info', // ✅ New column
      dataIndex: 'contact_info',
      render: (value) => value || '-', // show "-" if null
    },
    {
      title: 'Role',
      dataIndex: 'role_id',
      render: (role_id: number) => {
        const roles: Record<number, string> = {
          1: 'admin',
          2: 'customer',
          3: 'driver',
        };
        return roles[role_id] || `Role ${role_id}`;
      },
    },
    {
      title: 'Actions',
      key: 'actions',
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            icon={<EditOutlined />}
            onClick={() => alert(`Edit ${record.username}`)}
          >
            Edit
          </Button>
          <Button
            type="link"
            danger
            icon={<DeleteOutlined />}
            onClick={() => handleDelete(record)}
          >
            Delete
          </Button>
        </Space>
      ),
    },
  ];

  return (
    <div>
      <h1 style={{ marginBottom: 24 }}>Хэрэглэгч (Зөвхөн Customers)</h1>

      <Space style={{ marginBottom: 16, width: '100%' }} wrap>
        <div style={{ fontSize: '14px', color: '#666' }}>
          Нийт: {filteredCustomers.length} customer(s)
        </div>

        <Input
          placeholder="Search by username..."
          prefix={<SearchOutlined />}
          value={searchText}
          onChange={(e) => handleSearch(e.target.value)}
          style={{ width: 250 }}
          allowClear
        />

        <Button
          type="primary"
          style={{ marginLeft: 'auto' }}
          onClick={handleCreateUser}
        >
          + Хэрэглэгч үүсгэх
        </Button>
      </Space>

      <Table
        columns={columns}
        dataSource={currentPageData}
        rowKey="id"
        loading={loading}
        pagination={{
          current: pagination.current,
          pageSize: pagination.pageSize,
          total: filteredCustomers.length,
          showSizeChanger: true,
          pageSizeOptions: ['50', '100', '200', '500'],
          showTotal: (total, range) => `${range[0]}-${range[1]} of ${total} items`,
          onChange: (page, pageSize) => {
            setPagination((prev) => ({
              ...prev,
              current: page,
              pageSize: pageSize || prev.pageSize,
            }));
          },
        }}
      />

      <Drawer
        title="Хэрэглэгч үүсгэх"
        width={400}
        onClose={handleDrawerClose}
        open={drawerVisible}
        bodyStyle={{ paddingBottom: 80 }}
      >
        <Form layout="vertical" form={form} onFinish={handleFormSubmit}>
          <Form.Item name="username" label="Username" rules={[{ required: true }]}>
            <Input placeholder="Username" />
          </Form.Item>
          <Form.Item name="email" label="Email">
            <Input placeholder="Email" />
          </Form.Item>
          <Form.Item name="phone" label="Phone">
            <Input placeholder="Phone" />
          </Form.Item>

          {/* ✅ Added contact_info field */}
          <Form.Item name="contact_info" label="Contact Info">
            <Input placeholder="Contact details or notes" />
          </Form.Item>

          <Form.Item name="role_id" label="Role" rules={[{ required: true }]}>
            <Select placeholder="Select role">
              <Option value={1}>Admin</Option>
              <Option value={2}>Customer</Option>
              <Option value={3}>Driver</Option>
            </Select>
          </Form.Item>

          <Form.Item
            name="password"
            label="Password"
            rules={[{ required: true, message: 'Please enter a password' }]}
          >
            <Input.Password placeholder="Password" />
          </Form.Item>

          <Form.Item>
            <Button type="primary" htmlType="submit" block>
              Хадгалах
            </Button>
          </Form.Item>
        </Form>
      </Drawer>
    </div>
  );
}