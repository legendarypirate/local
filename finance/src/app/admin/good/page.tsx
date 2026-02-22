'use client';

import React, { useEffect, useState } from 'react';
import { Table, Button, Space, Drawer, Form, Input, Select, Modal, notification, message } from 'antd';
import type { TableColumnsType } from 'antd';
import { EditOutlined, DeleteOutlined, CloseOutlined, ExclamationCircleFilled } from '@ant-design/icons';

const { Option } = Select;
const { confirm } = Modal;

interface Good {
  id: number;
  stock: number;
  name: string;
  merchant_id: number;
  ware_id: number;
  createdAt: string;
  updatedAt: string;
  merchant: {
    id: number;
    username: string;
  };
  ware: {
    id: number;
    name: string;
  };
}

export default function UsersPage() {
  const [good, setGood] = useState<Good[]>([]);
  const [loading, setLoading] = useState(false);
  const [drawerVisible, setDrawerVisible] = useState(false);
  const [form] = Form.useForm();
  const [merchants, setMerchants] = useState([]);
  const [wares, setWares] = useState([]);
  const [selectedGood, setSelectedGood] = useState<Good | null>(null);
  const [modalVisible, setModalVisible] = useState(false);
  const [editModalVisible, setEditModalVisible] = useState(false);
  const [editForm] = Form.useForm();
  const [user, setUser] = useState<any>(null);
  const [username, setUsername] = useState<string | null>(null);

  const isMerchant = user?.role === 2;
  const merchantId = isMerchant ? user?.id : null;

  useEffect(() => {
    document.title = 'Агуулахын бараа';

    const fetchInitialData = async () => {
      setLoading(true);
      try {
        // Get user from localStorage
        const userData = typeof window !== 'undefined' ? localStorage.getItem('user') : null;
        const parsedUser = userData ? JSON.parse(userData) : null;
        setUser(parsedUser);
        setUsername(typeof window !== 'undefined' ? localStorage.getItem('username') : null);

        // Goods with optional merchant_id filter
        let goodsUrl = `${process.env.NEXT_PUBLIC_API_URL}/api/good`;
        if (parsedUser?.role === 2) {
          goodsUrl += `?merchant_id=${parsedUser.id}`;
        }

        const goodsRes = await fetch(goodsUrl);
        const goodsResult = await goodsRes.json();
        if (goodsResult.success) {
          // Sort by ID in descending order
          const sortedGoods = [...goodsResult.data].sort((a, b) => b.id - a.id);
          setGood(sortedGoods);
        }

        // Users (merchants)
        const userRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user`);
        const userResult = await userRes.json();
        if (userResult.success) {
          setMerchants(userResult.data.filter((u: any) => u.role_id === 2));
        }

        // Wares
        const wareRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/ware`);
        const wareResult = await wareRes.json();
        if (wareResult.success) {
          setWares(wareResult.data);
        }
      } catch (err) {
        console.error('Fetch error:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchInitialData();
  }, []);

  const handleCreateGood = () => {
    setDrawerVisible(true);
  };

  const handleDrawerClose = () => {
    setDrawerVisible(false);
    form.resetFields();
  };

  const openNotification = (type: 'success' | 'error' | 'warning', messageText: string) => {
    let backgroundColor = '#52c41a'; // default green
    if (type === 'error') backgroundColor = '#ff4d4f';
    else if (type === 'warning') backgroundColor = '#fa8c16';

    notification.open({
      message: null,
      description: <div style={{ color: 'white' }}>{messageText}</div>,
      duration: 4,
      style: {
        backgroundColor,
        borderRadius: '4px',
      },
      closeIcon: <CloseOutlined style={{ color: '#fff' }} />,
    });
  };

  // ✅ DELETE FUNCTION WITH CONFIRMATION
  const handleDeleteGood = (record: Good) => {
    confirm({
      title: `Та "${record.name}" барааг устгахдаа итгэлтэй байна уу?`,
      icon: <ExclamationCircleFilled />,
      content: 'Энэ үйлдлийг буцаах боломжгүй. Барааг бүрмөсөн устгана.',
      okText: 'Тийм',
      okType: 'danger',
      cancelText: 'Үгүй',
      centered: true,
      onOk: async () => {
        try {
          // Show loading state
          message.loading('Барааг устгаж байна...', 2);
          
          const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/good/${record.id}`, {
            method: 'DELETE',
            headers: {
              'Content-Type': 'application/json',
            },
          });

          const result = await response.json();
          
          if (result.success) {
            // Remove from local state
            setGood((prevGoods) => prevGoods.filter((good) => good.id !== record.id));
            message.success('Бараа амжилттай устгагдлаа');
            
            // Show notification
            openNotification('success', `"${record.name}" бараа амжилттай устгагдлаа`);
          } else {
            message.error(result.message || 'Устгахад алдаа гарлаа');
            openNotification('error', result.message || 'Устгахад алдаа гарлаа');
          }
        } catch (error) {
          console.error('Delete error:', error);
          message.error('Сервертэй холбогдоход алдаа гарлаа');
          openNotification('error', 'Сервертэй холбогдоход алдаа гарлаа');
        }
      },
      onCancel() {
        console.log('Устгах цуцлагдлаа');
      },
    });
  };

  const handleStockUpdate = async (values: { type: number; amount: number }) => {
    if (!selectedGood) return;

    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/good/${selectedGood.id}/stock`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          id: selectedGood.id,
          type: values.type,
          amount: Number(values.amount),
        }),
      });

      const result = await response.json();
      if (result.success) {
        setGood((prevGoods) =>
          prevGoods.map((good) =>
            good.id === selectedGood.id ? { ...good, stock: result.data.stock } : good
          )
        );
        setModalVisible(false);

        if (values.type === 1) {
          openNotification('success', 'Амжилттай орлогодолоо');
        } else if (values.type === 2) {
          openNotification('warning', 'Амжилттай зарлагадлаа');
        }
      } else {
        Modal.error({ title: 'Error', content: result.message });
      }
    } catch (error) {
      console.error('Error updating stock:', error);
      Modal.error({ title: 'Error', content: 'Failed to update stock' });
    }
  };

  const handleEditGood = (record: Good) => {
    setSelectedGood(record);
    editForm.setFieldsValue({ name: record.name });
    setEditModalVisible(true);
  };

  const handleEditFormSubmit = async () => {
    if (!selectedGood) return;

    try {
      const values = await editForm.validateFields();

      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/good/${selectedGood.id}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: values.name,
        }),
      });

      const result = await response.json();

      if (result.success) {
        setGood((prevGoods) =>
          prevGoods.map((good) =>
            good.id === selectedGood.id ? result.data : good
          )
        );
        setEditModalVisible(false);
        editForm.resetFields();
        openNotification('success', 'Барааны нэр амжилттай шинэчлэгдлээ');
      } else {
        openNotification('error', result.message || 'Барааны нэр шинэчлэхэд алдаа гарлаа');
      }
    } catch (error) {
      console.error('Error updating good name:', error);
      openNotification('error', 'Барааны нэр шинэчлэхэд алдаа гарлаа');
    }
  };

  const handleFormSubmit = async () => {
    try {
      const values = await form.validateFields();

      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/good`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(values),
      });

      const result = await response.json();

      if (response.ok) {
        setGood((prev) => [...prev, result.data].sort((a, b) => b.id - a.id));
        handleDrawerClose();
        openNotification('success', 'Бараа амжилттай үүсгэгдлээ');
      } else {
        console.error('Failed to create good:', result.message);
        openNotification('error', result.message || 'Бараа үүсгэхэд алдаа гарлаа');
      }
    } catch (error) {
      console.error('Validation or request failed:', error);
      openNotification('error', 'Бараа үүсгэхэд алдаа гарлаа');
    }
  };
 const merchantFilters = React.useMemo(() => {
    const uniqueMerchants = Array.from(new Set(good.map(item => item.merchant.username)))
      .map(username => {
        return {
          text: username,
          value: username,
        };
      });
    return uniqueMerchants;
  }, [good]);
  const columns: TableColumnsType<Good> = [
    {
      title: 'Агуулах',
      dataIndex: ['ware', 'name'],
    },
    {
      title: 'Дэлгүүр',
      dataIndex: ['merchant', 'username'],
      filters: merchantFilters,
      onFilter: (value, record) => record.merchant.username === value,
      filterSearch: true,
    },
    {
      title: 'Барааны нэр',
      dataIndex: 'name',
    },
    {
      title: 'Үлдэгдэл',
      dataIndex: 'stock',
    },
    ...(!isMerchant
      ? [
          {
            title: 'Үйлдэл',
            key: 'actions' as const,
            render: (_: unknown, record: Good) => (
              <Space>
                <Button
                  type="link"
                  icon={<EditOutlined />}
                  onClick={() => handleEditGood(record)}
                >
                  Засах
                </Button>
                <Button
                  type="link"
                  icon={<EditOutlined />}
                  onClick={() => {
                    setSelectedGood(record);
                    setModalVisible(true);
                  }}
                >
                  Орлогодох
                </Button>
                <Button
                  type="link"
                  danger
                  icon={<DeleteOutlined />}
                  onClick={() => handleDeleteGood(record)}
                >
                  Устгах
                </Button>
              </Space>
            ),
          },
        ]
      : []),
  ];

  return (
    <div style={{ padding: '24px' }}>
      <h1 style={{ marginBottom: 24 }}>Агуулахын бараа</h1>
      {!isMerchant && (
        <Space style={{ marginBottom: 16, width: '100%' }} wrap>
          <Button
            type="primary"
            style={{ marginLeft: 'auto' }}
            onClick={handleCreateGood}
          >
            + Бараа үүсгэх
          </Button>
        </Space>
      )}

      <Table 
        columns={columns} 
        dataSource={good} 
        rowKey="id" 
        loading={loading}
        pagination={{ pageSize: 10 }}
      />

      <Drawer
        title="Бараа үүсгэх"
        width={400}
        onClose={handleDrawerClose}
        open={drawerVisible}
        styles={{ body: { paddingBottom: 80 } }}
      >
        <Form layout="vertical" form={form} onFinish={handleFormSubmit}>
          <Form.Item name="name" label="Барааны нэр" rules={[{ required: true }]}>
            <Input placeholder="Барааны нэр" />
          </Form.Item>
          <Form.Item name="stock" label="Үлдэгдэл" rules={[{ required: true }]}>
            <Input type="number" placeholder="Үлдэгдэл" min={0} />
          </Form.Item>

          {isMerchant ? (
            <>
              <Form.Item label="Дэлгүүр">
                <div
                  style={{
                    padding: '4px 11px',
                    border: '1px solid #d9d9d9',
                    borderRadius: 2,
                    backgroundColor: '#f5f5f5',
                    color: 'rgba(0, 0, 0, 0.85)',
                    minHeight: 32,
                    display: 'flex',
                    alignItems: 'center',
                  }}
                >
                  {username}
                </div>
              </Form.Item>
              <Form.Item name="merchant_id" initialValue={merchantId} hidden>
                <Input />
              </Form.Item>
            </>
          ) : (
            <Form.Item
              name="merchant_id"
              label="Дэлгүүр"
              rules={[{ required: true, message: 'Дэлгүүр сонгоно уу!' }]}
            >
              <Select placeholder="Дэлгүүр сонгох">
                {merchants.map((merchant: any) => (
                  <Option key={merchant.id} value={merchant.id}>
                    {merchant.username}
                  </Option>
                ))}
              </Select>
            </Form.Item>
          )}

          <Form.Item name="ware_id" label="Агуулах" rules={[{ required: true }]}>
            <Select placeholder="Агуулах сонгох">
              {wares.map((ware: any) => (
                <Option key={ware.id} value={ware.id}>
                  {ware.name}
                </Option>
              ))}
            </Select>
          </Form.Item>

          <Form.Item>
            <Button type="primary" htmlType="submit" block>
              Хадгалах
            </Button>
          </Form.Item>
        </Form>
      </Drawer>

      <Modal
        title={`Орлого эсвэл Зарлага`}
        open={modalVisible}
        onCancel={() => setModalVisible(false)}
        footer={null}
        centered
      >
        <p><strong>Бараа:</strong> {selectedGood?.name}</p>
        <Form onFinish={handleStockUpdate} layout="vertical">
          <Form.Item
            name="type"
            label="Төрөл"
            rules={[{ required: true, message: 'Төрлийг сонгоно уу' }]}
          >
            <Select placeholder="Төрөл сонгох">
              <Option value={1}>Орлого</Option>
              <Option value={2}>Зарлага</Option>
            </Select>
          </Form.Item>
          <Form.Item
            name="amount"
            label="Тоо хэмжээ"
            rules={[{ required: true, message: 'Тоо хэмжээг оруулна уу' }]}
          >
            <Input type="number" placeholder="Тоо хэмжээ" min={1} />
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" block>
              Хадгалах
            </Button>
          </Form.Item>
        </Form>
      </Modal>

      <Modal
        title="Барааны нэр засах"
        open={editModalVisible}
        onCancel={() => {
          setEditModalVisible(false);
          editForm.resetFields();
        }}
        footer={null}
        centered
      >
        <Form form={editForm} onFinish={handleEditFormSubmit} layout="vertical">
          <Form.Item
            name="name"
            label="Барааны нэр"
            rules={[{ required: true, message: 'Барааны нэрийг оруулна уу!' }]}
          >
            <Input placeholder="Барааны нэр" />
          </Form.Item>
          <Form.Item>
            <Button type="primary" htmlType="submit" block>
              Хадгалах
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}