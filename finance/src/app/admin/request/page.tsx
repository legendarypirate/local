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
  role_id: number;
  bank?: string;
  contact_info?: string;
  account_number?: string;
  address?: string;
  createdAt: string;
  updatedAt: string;
}

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  const [drawerVisible, setDrawerVisible] = useState(false);
  const [editModalVisible, setEditModalVisible] = useState(false);
  const [editingUser, setEditingUser] = useState<User | null>(null);
  const [form] = Form.useForm();
  const [editForm] = Form.useForm();
  const [pagination, setPagination] = useState({
    current: 1,
    pageSize: 100,
    total: 0,
  });
  const [searchText, setSearchText] = useState('');

  // ✅ Reusable fetch function
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

  // Load users on page load
  useEffect(() => {
    document.title = 'Хэрэглэгч';
    fetchData();
  }, []);

  // Filter users to show only role_id 3 (drivers) and apply search filter
  const filteredCustomers = users.filter(user => 
    user.role_id === 3 && 
    user.username.toLowerCase().includes(searchText.toLowerCase())
  );

  // Update pagination total when filtered data changes
  useEffect(() => {
    setPagination(prev => ({
      ...prev,
      total: filteredCustomers.length,
    }));
  }, [filteredCustomers.length]);

  // Get current page data for the table
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
          fetchData(); // ✅ refresh after delete
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
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(values),
      });

      const result = await response.json();

      if (response.ok && result.success) {
        message.success('Хэрэглэгч амжилттай үүслээ');
        fetchData(); // ✅ refresh after create
        handleDrawerClose();
      } else {
        console.error('Failed to create user:', result.message);
        message.error(result.message || 'Алдаа гарлаа');
      }
    } catch (error) {
      console.error('Validation or request failed:', error);
      message.error('Хэлбэр буруу байна');
    }
  };

  // Edit functionality - Only phone field
  const handleEdit = (record: User) => {
    setEditingUser(record);
    editForm.setFieldsValue({
      phone: record.phone,
    });
    setEditModalVisible(true);
  };

  const handleEditModalClose = () => {
    setEditModalVisible(false);
    setEditingUser(null);
    editForm.resetFields();
  };

  const handleEditSubmit = async () => {
    try {
      const values = await editForm.validateFields();

      if (!editingUser) return;

      // Only send phone field to update
      const updateData = {
        phone: values.phone
      };

      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/${editingUser.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updateData),
      });

      const result = await response.json();

      if (response.ok && result.success) {
        message.success('Утасны дугаар амжилттай шинэчлэгдлээ');
        fetchData(); // ✅ refresh after update
        handleEditModalClose();
      } else {
        console.error('Failed to update phone:', result.message);
        message.error(result.message || 'Шинэчлэхэд алдаа гарлаа');
      }
    } catch (error) {
      console.error('Validation or request failed:', error);
      message.error('Хэлбэр буруу байна');
    }
  };

  const handleSearch = (value: string) => {
    setSearchText(value);
    setPagination(prev => ({ ...prev, current: 1 })); // Reset to first page when searching
  };

  const columns: ColumnsType<User> = [
    {
      title: 'Username',
      dataIndex: 'username',
      width: 120,
    },
    {
      title: 'Email',
      dataIndex: 'email',
      width: 150,
    },
    {
      title: 'Phone',
      dataIndex: 'phone',
      width: 120,
    },
    {
      title: 'Bank',
      dataIndex: 'bank',
      width: 120,
      render: (bank: string) => bank || '-',
    },
    {
      title: 'Account Number',
      dataIndex: 'account_number',
      width: 140,
      render: (account_number: string) => account_number || '-',
    },
    {
      title: 'Contact info',
      dataIndex: 'contact_info',
      width: 140,
      render: (contact_info: string) => contact_info || '-',
    },
    {
      title: 'Address',
      dataIndex: 'address',
      width: 200,
      render: (address: string) => address || '-',
      ellipsis: true,
    },
    {
      title: 'Role',
      dataIndex: 'role_id',
      width: 100,
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
      width: 150,
      fixed: 'right',
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            icon={<EditOutlined />}
            onClick={() => handleEdit(record)}
          >
            Edit Phone
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
      <h1 style={{ marginBottom: 24 }}>Хэрэглэгч (Зөвхөн Drivers)</h1>
      <Space style={{ marginBottom: 16, width: '100%' }} wrap>
        <div style={{ fontSize: '14px', color: '#666' }}>
          Нийт: {filteredCustomers.length} driver(s)
        </div>
        
        {/* Search Input */}
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
        scroll={{ x: 1200 }}
        pagination={{
          current: pagination.current,
          pageSize: pagination.pageSize,
          total: filteredCustomers.length, // Total filtered customers
          showSizeChanger: true,
          pageSizeOptions: ['50', '100', '200', '500'],
          showTotal: (total, range) => 
            `${range[0]}-${range[1]} of ${total} items`,
          onChange: (page, pageSize) => {
            setPagination(prev => ({
              ...prev,
              current: page,
              pageSize: pageSize || prev.pageSize,
            }));
          },
        }}
      />

      {/* Create User Drawer */}
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
          <Form.Item name="bank" label="Bank Name">
            <Input placeholder="Bank name" />
          </Form.Item>
          <Form.Item name="account_number" label="Account Number">
            <Input placeholder="Account number" />
          </Form.Item>
          <Form.Item name="contact_info" label="Contact info">
            <Input placeholder="Contact info" />
          </Form.Item>
          <Form.Item name="address" label="Address">
            <Input.TextArea placeholder="Address" rows={3} />
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

      {/* Edit Phone Modal */}
      <Modal
        title={`Утасны дугаар засах - ${editingUser?.username}`}
        open={editModalVisible}
        onCancel={handleEditModalClose}
        footer={[
          <Button key="cancel" onClick={handleEditModalClose}>
            Болих
          </Button>,
          <Button key="submit" type="primary" onClick={handleEditSubmit}>
            Хадгалах
          </Button>,
        ]}
        width={400}
      >
        <Form layout="vertical" form={editForm}>
          <Form.Item 
            name="phone" 
            label="Утасны дугаар" 
            rules={[
              { required: true, message: 'Утасны дугаар оруулна уу' },
              { pattern: /^[0-9+-\s()]+$/, message: 'Зөв утасны дугаар оруулна уу' }
            ]}
          >
            <Input placeholder="Утасны дугаар" />
          </Form.Item>
          <div style={{ color: '#666', fontSize: '12px', marginTop: '-8px', marginBottom: '16px' }}>
            Зөвхөн утасны дугаар засах боломжтой
          </div>
        </Form>
      </Modal>
    </div>
  );
}