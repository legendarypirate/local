'use client';

import React, { useEffect, useState } from 'react';
import { Table, Button, Space, Drawer, Form, Input, Select, Modal, notification, App, Image } from 'antd';
import type { TableColumnsType } from 'antd';
import { EditOutlined, DeleteOutlined, CloseOutlined, ExclamationCircleFilled, EyeOutlined } from '@ant-design/icons';

const { Option } = Select;

interface Good {
  id: number;
  stock: number;
  name: string;
  merchant_id: number;
  ware_id: number;
  image_url?: string | null;
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
  const [imageModalOpen, setImageModalOpen] = useState(false);
  const [imagePreview, setImagePreview] = useState<{ name: string; url: string } | null>(null);
  const [editForm] = Form.useForm();
  const [user, setUser] = useState<any>(null);
  const [username, setUsername] = useState<string | null>(null);

  const isMerchant = user?.role === 2;
  const merchantId = isMerchant ? user?.id : null;
  const { modal, message } = App.useApp();

  const fetchGoods = React.useCallback(async () => {
    try {
      const userData = typeof window !== 'undefined' ? localStorage.getItem('user') : null;
      const parsedUser = userData ? JSON.parse(userData) : null;
      let goodsUrl = `${process.env.NEXT_PUBLIC_API_URL}/api/good`;
      if (parsedUser?.role === 2) {
        goodsUrl += `?merchant_id=${parsedUser.id}`;
      }
      const goodsRes = await fetch(goodsUrl);
      const goodsResult = await goodsRes.json();
      if (goodsResult.success && Array.isArray(goodsResult.data)) {
        const sortedGoods = [...goodsResult.data].sort((a: Good, b: Good) => b.id - a.id);
        setGood(sortedGoods);
      }
    } catch (err) {
      console.error('Fetch goods error:', err);
    }
  }, []);

  useEffect(() => {
    document.title = 'Агуулахын бараа';

    const fetchInitialData = async () => {
      setLoading(true);
      try {
        const userData = typeof window !== 'undefined' ? localStorage.getItem('user') : null;
        const parsedUser = userData ? JSON.parse(userData) : null;
        setUser(parsedUser);
        setUsername(typeof window !== 'undefined' ? localStorage.getItem('username') : null);

        let goodsUrl = `${process.env.NEXT_PUBLIC_API_URL}/api/good`;
        if (parsedUser?.role === 2) {
          goodsUrl += `?merchant_id=${parsedUser.id}`;
        }
        const goodsRes = await fetch(goodsUrl);
        const goodsResult = await goodsRes.json();
        if (goodsResult.success && Array.isArray(goodsResult.data)) {
          const sortedGoods = [...goodsResult.data].sort((a: Good, b: Good) => b.id - a.id);
          setGood(sortedGoods);
        }

        const userRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user`);
        const userResult = await userRes.json();
        if (userResult.success) {
          setMerchants(userResult.data.filter((u: any) => u.role_id === 2));
        }

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

  // Hard delete with confirmation (defer modal so it opens after click – fixes production)
  const handleDeleteGood = (record: Good) => {
    const r = record;
    setTimeout(() => {
      modal.confirm({
        title: 'Барааг устгах уу?',
        icon: <ExclamationCircleFilled />,
        content: (
          <span>
            Та &quot;{r.name}&quot; барааг бүрмөсөн устгах уу? Энэ үйлдлийг буцаах боломжгүй.
          </span>
        ),
        okText: 'Тийм, устгах',
        okType: 'danger',
        cancelText: 'Үгүй',
        centered: true,
        onOk: async () => {
          const hide = message.loading('Барааг устгаж байна...', 0);
          try {
            const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/good/${r.id}`, {
              method: 'DELETE',
              headers: { 'Content-Type': 'application/json' },
            });
            const result = await response.json().catch(() => ({}));
            hide();
            if (response.ok && result.success) {
              setGood((prev) => prev.filter((g) => g.id !== r.id));
              message.success('Бараа амжилттай устгагдлаа');
              openNotification('success', `"${r.name}" бараа устгагдлаа`);
            } else {
              message.error(result.message || 'Устгахад алдаа гарлаа');
              openNotification('error', result.message || 'Устгахад алдаа гарлаа');
            }
          } catch (error) {
            hide();
            console.error('Delete error:', error);
            message.error('Сервертэй холбогдоход алдаа гарлаа');
            openNotification('error', 'Сервертэй холбогдоход алдаа гарлаа');
          }
        },
      });
    }, 0);
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

  const openImageModal = (record: Good) => {
    if (!record.image_url) return;
    setImagePreview({ name: record.name, url: record.image_url });
    setImageModalOpen(true);
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
        handleDrawerClose();
        openNotification('success', 'Бараа амжилттай үүсгэгдлээ');
        await fetchGoods();
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
    const uniqueMerchants = Array.from(new Set(good.map(item => item?.merchant?.username).filter(Boolean)))
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
      onFilter: (value, record) => record?.merchant?.username === value,
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
    {
      title: 'Зураг',
      key: 'image',
      width: 100,
      render: (_: unknown, record: Good) => (
        <Button
          type="link"
          size="small"
          icon={<EyeOutlined />}
          disabled={!record.image_url}
          onClick={() => openImageModal(record)}
        >
          Харах
        </Button>
      ),
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

      <Modal
        title={imagePreview ? `Зураг — ${imagePreview.name}` : 'Зураг'}
        open={imageModalOpen}
        onCancel={() => {
          setImageModalOpen(false);
          setImagePreview(null);
        }}
        footer={null}
        centered
        width={520}
        destroyOnClose
      >
        {imagePreview?.url ? (
          <Image
            src={imagePreview.url}
            alt={imagePreview.name}
            style={{ width: '100%', maxHeight: '70vh', objectFit: 'contain' }}
          />
        ) : (
          <p>Зураг байхгүй</p>
        )}
      </Modal>
    </div>
  );
}