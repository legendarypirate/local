'use client';

import React, { useEffect, useState } from 'react';
import {  Button, Space, Drawer, Form, Select } from 'antd';
import type { TableColumnsType } from 'antd';
import { EditOutlined, DeleteOutlined } from '@ant-design/icons';


interface User {
  id: number;
  username: string;
  email: string;
  phone: string;
  role_id: number;
  createdAt: string;
  updatedAt: string;
}

export default function UsersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [loading, setLoading] = useState(false);
  const [drawerVisible, setDrawerVisible] = useState(false);
  const [form] = Form.useForm();

  useEffect(() => {
    document.title = 'Хэрэглэгч';

    const fetchUsers = async () => {
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

    fetchUsers();
  }, []);

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
        body: JSON.stringify(values), // includes username, phone, email, role_id, password
      });
  
      const result = await response.json();
  
      if (response.ok) {
        console.log('User created:', result);
        // Optionally refresh user list
        setUsers((prev) => [...prev, result]);
        // Close drawer and reset form
        handleDrawerClose();
      } else {
        console.error('Failed to create user:', result.message);
      }
    } catch (error) {
      console.error('Validation or request failed:', error);
    }
  };
  
  const columns: TableColumnsType<User> = [
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
            onClick={() => alert(`Delete ${record.username}`)}
          >
            Delete
          </Button>
        </Space>
      ),
    },
  ];

  return (
    <div>
       Under Construction
    </div>
  );
}
