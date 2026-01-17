'use client';

import React, { useState, useEffect } from 'react';
import { Table, Button, Space, Input, Drawer, Form, Modal, List, Tag, Row, Col, message } from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { EditOutlined, DeleteOutlined, EyeOutlined, PlusOutlined } from '@ant-design/icons';
import dayjs from 'dayjs';

interface Region {
  id: number;
  name: string;
  createdAt: string;
  deliveryCount?: number;
}

interface Delivery {
  id: number;
  phone: string;
  address: string;
  status: number;
  price: number;
  comment: string;
  createdAt: string;
  merchant?: {
    username: string;
  };
  status_name?: {
    status: string;
    color: string;
  };
}

interface Khoroo {
  id: number;
  name: string;
  region_id: number;
  createdAt: string;
}

export default function DeliveryPage() {
  const [selectedRowKeys, setSelectedRowKeys] = useState<React.Key[]>([]);
  const [form] = Form.useForm();
  const [isDrawerVisible, setIsDrawerVisible] = useState(false);
  const [regionData, setRegionData] = useState<Region[]>([]);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 });
  const [selectedDistrict, setSelectedDistrict] = useState<Region | null>(null);
  const [districtDeliveries, setDistrictDeliveries] = useState<Delivery[]>([]);
  const [isDeliveryModalVisible, setIsDeliveryModalVisible] = useState(false);
  const [deliveryLoading, setDeliveryLoading] = useState(false);
  const [isKhorooModalVisible, setIsKhorooModalVisible] = useState(false);
  const [khoroos, setKhoroos] = useState<Khoroo[]>([]);
  const [khorooLoading, setKhorooLoading] = useState(false);
  const [khorooForm] = Form.useForm();
  const [regionsLoading, setRegionsLoading] = useState(false);

  // Get today's date range - FIXED to use current date properly
  const getTodayDateRange = () => {
    const today = dayjs();
    const startOfDay = today.startOf('day').format('YYYY-MM-DD');
    const endOfDay = today.endOf('day').format('YYYY-MM-DD');
    console.log('Today date range:', { startOfDay, endOfDay, currentTime: today.format() });
    return { startOfDay, endOfDay };
  };

  // Fetch all regions from the API
  const fetchRegions = async () => {
    setRegionsLoading(true);
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/region`);
      if (response.ok) {
        const result = await response.json();
        const regions: Region[] = result.data || [];
        return regions;
      }
      return [];
    } catch (error) {
      console.error('Error fetching regions:', error);
      message.error('Бүсүүдийг ачааллахад алдаа гарлаа');
      return [];
    } finally {
      setRegionsLoading(false);
    }
  };

  // Fetch delivery count for each region (today only)
  const fetchDeliveryCounts = async () => {
    try {
      const { startOfDay, endOfDay } = getTodayDateRange();

      // First fetch all regions from the API
      const regions = await fetchRegions();
      if (regions.length === 0) {
        setRegionData([]);
        return;
      }

      const regionsWithCounts = await Promise.all(
        regions.map(async (region) => {
          try {
            const response = await fetch(
              `${process.env.NEXT_PUBLIC_API_URL}/api/delivery?dist_id=${region.id}&start_date=${startOfDay}&end_date=${endOfDay}&page=1&limit=1000`
            );
            if (response.ok) {
              const result = await response.json();
              const deliveries: Delivery[] = result.data || [];
              
              console.log(`Region ${region.name} deliveries:`, deliveries.length);
              
              // Calculate the earliest createdAt date from today's deliveries
              const earliestDelivery = deliveries.reduce((earliest, delivery) => {
                if (!earliest) return delivery;
                return dayjs(delivery.createdAt).isBefore(dayjs(earliest.createdAt)) ? delivery : earliest;
              }, null as Delivery | null);

              return {
                ...region,
                deliveryCount: deliveries.length,
                createdAt: earliestDelivery ? earliestDelivery.createdAt : region.createdAt || new Date().toISOString()
              };
            }
          } catch (error) {
            console.error(`Error fetching deliveries for ${region.name}:`, error);
          }
          return {
            ...region,
            deliveryCount: 0,
            createdAt: region.createdAt || new Date().toISOString()
          };
        })
      );
      setRegionData(regionsWithCounts);
    } catch (error) {
      console.error('Error fetching delivery counts:', error);
    }
  };

  // Fetch deliveries for a specific district (today only)
  const fetchDistrictDeliveries = async (districtId: number) => {
    setDeliveryLoading(true);
    try {
      const { startOfDay, endOfDay } = getTodayDateRange();

      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL}/api/delivery?dist_id=${districtId}&start_date=${startOfDay}&end_date=${endOfDay}&page=1&limit=1000`
      );
      if (response.ok) {
        const result = await response.json();
        const deliveries = result.data || [];
        console.log(`District ${districtId} today's deliveries:`, deliveries);
        setDistrictDeliveries(deliveries);
      }
    } catch (error) {
      console.error('Error fetching district deliveries:', error);
    } finally {
      setDeliveryLoading(false);
    }
  };

  const handleViewDeliveries = async (district: Region) => {
    setSelectedDistrict(district);
    await fetchDistrictDeliveries(district.id);
    setIsDeliveryModalVisible(true);
  };

  const handleDelete = async (id: number) => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/region/${id}`, {
        method: "DELETE",
      });
  
      if (response.ok) {
        console.log("Deleted successfully");
        fetchDeliveryCounts();
      } else {
        console.error("Failed to delete");
      }
    } catch (error) {
      console.error("Error deleting:", error);
    }
  };

  useEffect(() => {
    document.title = 'Бүс';
    fetchDeliveryCounts();
  }, []);

  const rowSelection = {
    selectedRowKeys,
    onChange: (selectedKeys: React.Key[]) => {
      setSelectedRowKeys(selectedKeys);
    },
  };

  const handleDeliveryButton = () => {
    setIsDrawerVisible(true);
  };

  const handleOk = async () => {
    try {
      const values = await form.validateFields();
  
      const payload = {
        name: values.name,
      };
  
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/region`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });
  
      const result = await response.json();
  
      if (result.success) {
        fetchDeliveryCounts();
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

  const handleCloseDeliveryModal = () => {
    setIsDeliveryModalVisible(false);
    setSelectedDistrict(null);
    setDistrictDeliveries([]);
  };

  // Khoroo management functions
  const fetchKhoroos = async (regionId: number) => {
    setKhorooLoading(true);
    try {
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL}/api/khoroo?region_id=${regionId}`
      );
      if (response.ok) {
        const result = await response.json();
        setKhoroos(result.data || []);
      }
    } catch (error) {
      console.error('Error fetching khoroos:', error);
      message.error('Хороо ачааллахад алдаа гарлаа');
    } finally {
      setKhorooLoading(false);
    }
  };

  const handleManageKhoroos = async (district: Region) => {
    setSelectedDistrict(district);
    await fetchKhoroos(district.id);
    setIsKhorooModalVisible(true);
  };

  const handleCloseKhorooModal = () => {
    setIsKhorooModalVisible(false);
    setSelectedDistrict(null);
    setKhoroos([]);
    khorooForm.resetFields();
  };

  const handleCreateKhoroo = async () => {
    try {
      const values = await khorooForm.validateFields();
      
      if (!selectedDistrict || !selectedDistrict.id) {
        message.error('Бүс сонгогдоогүй байна. Та эхлээд бүс сонгоно уу.');
        return;
      }

      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/khoroo`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: values.name,
          region_id: selectedDistrict.id,
        }),
      });

      const result = await response.json();

      if (result.success) {
        message.success('Хороо амжилттай үүслээ');
        khorooForm.resetFields();
        if (selectedDistrict && selectedDistrict.id) {
          await fetchKhoroos(selectedDistrict.id);
        }
      } else {
        message.error(result.message || 'Хороо үүсгэхэд алдаа гарлаа');
      }
    } catch (error) {
      console.error('Error creating khoroo:', error);
      message.error('Хороо үүсгэхэд алдаа гарлаа');
    }
  };

  const handleDeleteKhoroo = async (khorooId: number) => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/khoroo/${khorooId}`, {
        method: 'DELETE',
      });

      if (response.ok) {
        message.success('Хороо амжилттай устгалаа');
        if (selectedDistrict) {
          await fetchKhoroos(selectedDistrict.id);
        }
      } else {
        message.error('Хороо устгахад алдаа гарлаа');
      }
    } catch (error) {
      console.error('Error deleting khoroo:', error);
      message.error('Хороо устгахад алдаа гарлаа');
    }
  };

  const getStatusColor = (status: number) => {
    switch (status) {
      case 1: return 'orange';
      case 2: return 'blue';
      case 3: return 'green';
      case 4: return 'red';
      default: return 'gray';
    }
  };

  const getStatusText = (status: number) => {
    switch (status) {
      case 1: return 'Pending';
      case 2: return 'Хуваарилсан';
      case 3: return 'хүргэсэн';
      case 4: return 'Cancelled';
      default: return 'Unknown';
    }
  };

  const { startOfDay } = getTodayDateRange();

  // Define columns inside the component to access component functions
  const columns: ColumnsType<Region> = [
    {
      title: 'ID',
      dataIndex: 'id',
      key: 'id',
    },
    {
      title: 'Бүс',
      dataIndex: 'name',
      key: 'name',
    },
    {
      title: 'Өнөөдрийн хүргэлт',
      dataIndex: 'deliveryCount',
      key: 'deliveryCount',
      render: (count: number) => count || 0,
    },
    {
      title: 'Анхны хүргэлт',
      dataIndex: 'createdAt',
      key: 'createdAt',
      render: (date: string) => dayjs(date).format('YYYY-MM-DD HH:mm'),
    },
    {
      title: 'Үйлдэл',
      key: 'action',
      render: (_, record) => (
        <Space size="middle">
          <Button 
            type="primary" 
            icon={<EyeOutlined />}
            onClick={() => handleViewDeliveries(record)}
          >
            Хүргэлтүүд
          </Button>
          <Button 
            type="default"
            icon={<PlusOutlined />}
            onClick={() => handleManageKhoroos(record)}
          >
            Хороо
          </Button>
          <Button icon={<EditOutlined />}>Засах</Button>
          <Button 
            danger 
            icon={<DeleteOutlined />}
            onClick={() => handleDelete(record.id)}
          >
            Устгах
          </Button>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ paddingBottom: '100px' }}>
      <h1 style={{ marginBottom: 24 }}>Бүс</h1>

      <Space style={{ marginBottom: 16 }} wrap>
        <Tag color="blue">Өнөөдөр: {startOfDay}</Tag>
        <Button
          type="primary"
          style={{ marginLeft: 'auto' }}
          onClick={handleDeliveryButton}
        >
          + Бүс үүсгэх
        </Button>
      </Space>

      <Table
        rowSelection={rowSelection}
        columns={columns}
        dataSource={regionData}
        rowKey="id"
        pagination={{
          position: ['topRight'],
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
        title="Бүс үүсгэх"
        placement="right"
        open={isDrawerVisible}
        onClose={handleCloseDrawer}
        width="400px"
        bodyStyle={{ padding: '20px' }}
      >
        <Form form={form} layout="vertical">
          <Form.Item
            label="Бүс"
            name="name"
            rules={[{ required: true, message: 'Please input the address!' }]}
          >
            <Input placeholder="Бүс оруулах" />
          </Form.Item>
        
          <Form.Item>
            <Button type="primary" onClick={handleOk} block>
              Үүсгэх
            </Button>
          </Form.Item>
        </Form>
      </Drawer>

      {/* Delivery List Modal */}
      <Modal
        title={
          <div>
            <h3>{selectedDistrict?.name} дүүргийн хүргэлтүүд</h3>
            <div style={{ marginTop: 8 }}>
              <Space>
                <Tag color="blue">Нийт: {districtDeliveries.length} хүргэлт</Tag>
                <Tag color="green">Өнөөдөр: {startOfDay}</Tag>
              </Space>
            </div>
          </div>
        }
        open={isDeliveryModalVisible}
        onCancel={handleCloseDeliveryModal}
        footer={[
          <Button key="close" onClick={handleCloseDeliveryModal}>
            Хаах
          </Button>
        ]}
        width="80%"
        style={{ top: 20 }}
        bodyStyle={{ maxHeight: '70vh', overflow: 'auto' }}
      >
        {deliveryLoading ? (
          <div style={{ textAlign: 'center', padding: '20px' }}>
            Хүргэлтүүдийг ачаалж байна...
          </div>
        ) : districtDeliveries.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '20px' }}>
            Өнөөдөр ({startOfDay}) энэ дүүрэгт хүргэлт олдсонгүй
          </div>
        ) : (
          <List
            dataSource={districtDeliveries}
            renderItem={(delivery) => (
              <List.Item>
                <div style={{ width: '100%' }}>
                  <Row gutter={16} align="middle">
                    <Col span={4}>
                      <div>
                        <div style={{ fontWeight: 'bold' }}>{delivery.phone}</div>
                        <div style={{ fontSize: '12px', color: '#666' }}>
                          {dayjs(delivery.createdAt).format('YYYY-MM-DD HH:mm')}
                        </div>
                      </div>
                    </Col>
                    <Col span={6}>
                      <div style={{ fontSize: '14px' }}>{delivery.address}</div>
                    </Col>
                    <Col span={4}>
                      <Tag color={getStatusColor(delivery.status)}>
                        {getStatusText(delivery.status)}
                      </Tag>
                    </Col>
                    <Col span={4}>
                      <div style={{ fontWeight: 'bold', color: '#1890ff' }}>
                        {delivery.price}₮
                      </div>
                    </Col>
                    <Col span={6}>
                      <div style={{ fontSize: '12px', color: '#666' }}>
                        {delivery.comment || 'Тайлбаргүй'}
                      </div>
                      {delivery.merchant && (
                        <div style={{ fontSize: '12px' }}>
                          Дэлгүүр: {delivery.merchant.username}
                        </div>
                      )}
                    </Col>
                  </Row>
                </div>
              </List.Item>
            )}
          />
        )}
      </Modal>

      {/* Khoroo Management Modal */}
      <Modal
        title={
          <div>
            <h3>{selectedDistrict?.name} дүүргийн хороонууд</h3>
          </div>
        }
        open={isKhorooModalVisible}
        onCancel={handleCloseKhorooModal}
        footer={[
          <Button key="close" onClick={handleCloseKhorooModal}>
            Хаах
          </Button>
        ]}
        width={600}
      >
        <div style={{ marginBottom: 16 }}>
          <Form form={khorooForm} layout="inline" onFinish={handleCreateKhoroo}>
            <Form.Item
              name="name"
              rules={[{ required: true, message: 'Хорооны нэрийг оруулна уу' }]}
              style={{ flex: 1, marginRight: 8 }}
            >
              <Input placeholder="Хорооны нэр" />
            </Form.Item>
            <Form.Item>
              <Button type="primary" htmlType="submit" icon={<PlusOutlined />}>
                Хороо нэмэх
              </Button>
            </Form.Item>
          </Form>
        </div>

        {khorooLoading ? (
          <div style={{ textAlign: 'center', padding: '20px' }}>
            Хороонуудыг ачаалж байна...
          </div>
        ) : khoroos.length === 0 ? (
          <div style={{ textAlign: 'center', padding: '20px', color: '#999' }}>
            Энэ дүүрэгт хороо олдсонгүй
          </div>
        ) : (
          <List
            dataSource={khoroos}
            renderItem={(khoroo) => (
              <List.Item
                actions={[
                  <Button
                    key="delete"
                    danger
                    size="small"
                    icon={<DeleteOutlined />}
                    onClick={() => handleDeleteKhoroo(khoroo.id)}
                  >
                    Устгах
                  </Button>
                ]}
              >
                <List.Item.Meta
                  title={khoroo.name}
                  description={`ID: ${khoroo.id}`}
                />
              </List.Item>
            )}
          />
        )}
      </Modal>
    </div>
  );
}