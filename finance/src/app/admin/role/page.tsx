'use client';

import React, { useEffect, useState } from 'react';
import { Table, Button, Space, Drawer, Form, message, Switch, Divider } from 'antd';
import type { TableColumnsType } from 'antd';
import { EditOutlined } from '@ant-design/icons';

interface Role {
  id: number;
  name: string;
  createdAt: string;
  updatedAt: string;
}

interface Permission {
  id: number;
  module: string;
  action: string;
}

export default function RolePermissionPage() {
  const [roles, setRoles] = useState<Role[]>([]);
  const [permissions, setPermissions] = useState<Permission[]>([]);
  const [loading, setLoading] = useState(false);
  const [drawerVisible, setDrawerVisible] = useState(false);
  const [form] = Form.useForm();
  const [selectedRole, setSelectedRole] = useState<Role | null>(null);
  const [rolePermissions, setRolePermissions] = useState<number[]>([]);

  useEffect(() => {
    document.title = 'Эрхийн зохицуулалт';
    fetchRoles();
    fetchPermissions();
  }, []);

  const fetchRoles = async () => {
    setLoading(true);
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/role`);
      const result = await res.json();
      if (result.success) setRoles(result.data);
      else message.error('Failed to load roles');
    } catch (err) {
      console.error('Error fetching roles:', err);
    } finally {
      setLoading(false);
    }
  };

  const fetchPermissions = async () => {
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/permission`);
      const result = await res.json();
      if (result.success) setPermissions(result.data);
      else message.error('Failed to load permissions');
    } catch (err) {
      console.error('Error fetching permissions:', err);
    }
  };

  const openPermissionDrawer = async (role: Role) => {
    setSelectedRole(role);
    setDrawerVisible(true);
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/role_permission/${role.id}`);
      const result = await res.json();
      if (result.success && Array.isArray(result.data)) {
        const permissionIds = result.data.map((p: Permission) => p.id);
        setRolePermissions(permissionIds);
      }
    } catch (err) {
      console.error('Failed to fetch role permissions', err);
    }
  };

  const handleSubmit = async () => {
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/role_permission/${selectedRole?.id}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ permissions: rolePermissions }),
      });
      const result = await res.json();
      if (res.ok) {
        message.success('Permissions updated');
        setDrawerVisible(false);
        setRolePermissions([]);
        form.resetFields();
      } else {
        message.error(result.message || 'Failed to update permissions');
      }
    } catch (err) {
      message.error('Error submitting permissions');
    }
  };

  const columns: TableColumnsType<Role> = [
    {
      title: 'Role',
      dataIndex: 'name',
    },
    {
      title: 'Actions',
      render: (_, record) => (
        <Space>
          <Button
            type="link"
            icon={<EditOutlined />}
            onClick={() => openPermissionDrawer(record)}
          >
            Edit Permissions
          </Button>
        </Space>
      ),
    },
  ];

  return (
    <div>
      <h1 style={{ marginBottom: 24 }}>Role Permissions</h1>
      <Table
        columns={columns}
        dataSource={roles}
        rowKey="id"
        loading={loading}
      />

      <Drawer
        title={`Edit Permissions: ${selectedRole?.name}`}
        width={480}
        onClose={() => {
          setDrawerVisible(false);
          setSelectedRole(null);
          setRolePermissions([]);
        }}
        open={drawerVisible}
        styles={{ body: { paddingBottom: 80 } }}
      >
        <Form form={form} layout="vertical" onFinish={handleSubmit}>
          <Form.Item label="Permissions">
            {permissions.map((p) => (
              <Form.Item key={p.id} style={{ marginBottom: 12 }}>
                <Space>
                  <Switch
                    checked={rolePermissions.includes(p.id)}
                    onChange={(checked) => {
                      if (checked) {
                        setRolePermissions((prev) => [...prev, p.id]);
                      } else {
                        setRolePermissions((prev) => prev.filter((id) => id !== p.id));
                      }
                    }}
                  />
                  <span>{`${p.module} - ${p.action}`}</span>
                </Space>
              </Form.Item>
            ))}
          </Form.Item>

          <Divider />

          <Form.Item>
            <Button type="primary" htmlType="submit" block>
              Save Permissions
            </Button>
          </Form.Item>
        </Form>
      </Drawer>
    </div>
  );
}
