'use client';

import React, { useState, useMemo, useRef, useEffect, Suspense } from 'react';
import { Table, Button, Space, Input, DatePicker, Drawer, Form ,Select,Tag,Modal,Checkbox,message,InputNumber,List,Row,Col,Tooltip} from 'antd';
import type { ColumnsType } from 'antd/es/table';
import { EditOutlined, DeleteOutlined,PlusOutlined, EyeOutlined} from '@ant-design/icons';
import dayjs, { Dayjs } from 'dayjs';
import isSameOrAfter from 'dayjs/plugin/isSameOrAfter';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';
import * as XLSX from 'xlsx';
const { Option } = Select;
import { CheckboxChangeEvent } from 'antd/es/checkbox'; // энэ import маш чухал
import { useSearchParams } from 'next/navigation';

const { RangePicker } = DatePicker;
dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);

interface Good {
  name: string;
}

interface Item {
  id: number;
  good_id: number;
  quantity: number;
  good?: Good;   // add this property to match backend data
  // add other fields if needed
}
interface DeliveryHistory {
  id: number;
  merchant_id: number;
  delivery_id: number;
  driver_id: number | null;
  status: number;
  createdAt: string;
  updatedAt: string;
  driver: {
    id: number;
    username: string;
    phone: string;
  } | null;
  status_name: {
    id: number;
    status: string;
    color: string;
  };
}
interface Delivery {
  id: number;
  phone: string;
  address: string;
  status: number | string; // This is still the numeric or string status
  price: number;
  comment: string;
  driver_comment: string;
  driver: {
    username: string;
  };
  createdAt: string;
  merchant: {
    username: string;
  };
  status_name: {
    status: string;
    color: string;
  };
  items?: Item[];
  is_paid: boolean;
  is_rural: boolean;
}

const products = [
  { id: 'p1', name: 'Бараа 1', price: 1000 },
  { id: 'p2', name: 'Бараа 2', price: 1500 },
  { id: 'p3', name: 'Бараа 3', price: 2000 },
];

interface DeliveryStatus {
  id: number;
  status: string;
  color: string;
  createdAt?: string;
  updatedAt?: string;
}

interface ProductItem {
  productId: string;
  productName: string;
  quantity: number;
  price: number; // нэмэгдсэн
}


export default function DeliveryPage() {
  const [selectedRowKeys, setSelectedRowKeys] = useState<React.Key[]>([]);
  const [dateRange, setDateRange] = useState<[Dayjs | null, Dayjs | null]>([null, null]);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [form] = Form.useForm();
  const [isDrawerVisible, setIsDrawerVisible] = useState(false);
  const [merchants, setMerchants] = useState<{ id: number; username: string }[]>([]);
  const [deliveryData, setDeliveryData] = useState<Delivery[]>([]);
  const [drivers, setDrivers] = useState<{ id: number; username: string }[]>([]);
  const [selectedDriverId, setSelectedDriverId] = useState<number | null>(null);
  const [pagination, setPagination] = useState({ current: 1, pageSize: 10, total: 0 });
  const [pullFromWarehouse, setPullFromWarehouse] = useState(false);
  const [productList, setProductList] = useState<ProductItem[]>([]);
  const [selectedProduct, setSelectedProduct] = useState(null);
  const [quantity, setQuantity] = useState(1);
  const [productPrice, setProductPrice] = React.useState<number>(0);
  const [refreshKey, setRefreshKey] = useState(0);
  const [realdriver, setRealdriver] = useState<{ id: number; username: string }[]>([]);
const [isHistoryModal, setIsHistoryModal] = useState(false);
const [deliveryHistory, setDeliveryHistory] = useState<DeliveryHistory[]>([]);
const [historyLoading, setHistoryLoading] = useState(false);
  const [selectStatusId, setSelectedStatusId] = useState<number | null>(null);

  const [status, setStatus] = useState<{ id: number; status: string }[]>([]);

  const fileInputRef = useRef<HTMLInputElement | null>(null);
  const [products, setProducts] = useState<{ id: string; name: string; stock: number }[]>([]);
  const [permissions, setPermissions] = useState<string[]>([]);

  const userData = typeof window !== 'undefined' ? localStorage.getItem('user') : null;
  const user = userData ? JSON.parse(userData) : null;
  const isMerchant = user?.role === 2;
  const username = typeof window !== 'undefined' ? localStorage.getItem('username') : null;

  const [expandedRowKeys, setExpandedRowKeys] = React.useState<React.Key[]>([]);
  const [expandedItems, setExpandedItems] = React.useState<Record<number, Item[] | null>>({});
  const [loadingRows, setLoadingRows] = React.useState<number[]>([]);
const [isSubmitting, setIsSubmitting] = useState(false);

  const [isPaid, setIsPaid] = useState(false);
  const [isRural, setIsRural] = useState(false);
  const [priceDisabled, setPriceDisabled] = useState(false);

  const [isStatusModal, setIsStatusModal] = useState(false);
  const [selectedDelivery, setSelectedDelivery] = useState<Delivery | null>(null);
  const [isEditModal, setIsEditModal] = useState(false);


  // Add to your existing state variables
const [districts, setDistricts] = useState([
  { id: 1, name: 'Баянзүрх' },
  { id: 2, name: 'Хан-Уул' },
  { id: 3, name: 'Сүхбаатар' },
  { id: 4, name: 'Чингэлтэй' },
  { id: 5, name: 'Сонгинохайрхан' },
  { id: 6, name: 'Баянгол' }
]);

const [selectedDistrict, setSelectedDistrict] = useState<number | null>(null);
const [districtFilter, setDistrictFilter] = useState<number | null>(null);

  const handleEditClick = (record: Delivery) => {
    setSelectedDelivery(record);
    form.setFieldsValue({
      phone: record.phone,
      address: record.address,
      price: record.price,
    });
    setIsEditModal(true);
  };

  const handleEdit = async () => {
    try {
      const values = await form.validateFields();
  
      const updateData = {
        phone: values.phone,
        address: values.address,
        price: values.price,
      };
  
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/${selectedDelivery?.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updateData),
      });
  
      const result = await response.json();
  
      if (response.ok && result.success) {
        console.log('Updated successfully:', result.data);
        setIsEditModal(false);
  
        // Optionally refresh your delivery table here
      } else {
        console.error('Failed to update delivery:', result.message);
      }
  
    } catch (err) {
      console.error('Validation or request failed:', err);
    }
  };
  
const baseColumns: ColumnsType<Delivery> = [
  {
    title: 'Үүссэн огноо',
    dataIndex: 'createdAt',
    render: (text: string) => {
      return dayjs(text).format('YYYY-MM-DD hh:mm A');
    },
  },
  {
    title: 'Хүргэсэн огноо',
    dataIndex: 'delivered_at',
    render: (text: string) => {
      return text ? dayjs(text).format('YYYY-MM-DD hh:mm A') : '-';
    },
  },
  { 
    title: 'Мерчанд нэр', 
    dataIndex: ['merchant', 'username'], 
    key: 'merchant',
    render: (_, record) => record.merchant?.username || '-' 
  },
  { 
    title: 'Утас / Хаяг', 
    dataIndex: 'phone',
    key: 'phone_address',
    render: (phone: string, record: Delivery) => (
      <div>
        <div style={{ fontWeight: 500 }}>{phone}</div>
        <div style={{ fontSize: '12px', color: '#666', marginTop: '2px' }}>
          {record.address}
        </div>
      </div>
    ),
  },
  {
    title: 'Төлөв',
    dataIndex: 'status_name',
    render: (status_name: { status: string, color: string }) => (
      <Tag color={status_name.color}>
        {status_name.status}
      </Tag>
    ),
  },
  { title: 'Үнэ', dataIndex: 'price' },
  { title: 'Тайлбар', dataIndex: 'comment' },
  { 
    title: 'Ж/тайлбар', 
    dataIndex: 'driver_comment',
    key: 'driver_comment',
    render: (driver_comment: string) => (
      <Tooltip title={driver_comment || ''}>
        <span style={{ 
          fontSize: '12px',
          color: driver_comment ? '#1890ff' : '#999',
          fontStyle: driver_comment ? 'normal' : 'italic'
        }}>
          {driver_comment || 'Тайлбаргүй'}
        </span>
      </Tooltip>
    ),
  },
  { 
    title: 'Жолооч нэр', 
    dataIndex: ['driver', 'username'], 
    key: 'driver',
    render: (_, record) => record.driver?.username || '-' 
  },
  { 
    title: 'Үйлдэл',
    key: 'actions',
    render: (_: any, record: Delivery) => (
      <Space>
        <Button
          type="link"
          icon={<EditOutlined />}
          onClick={() => handleEditClick(record)}
        >
          Edit
        </Button>
        <Button
          type="link"
          icon={<EyeOutlined />}
          onClick={() => handleViewHistory(record.id)}
          loading={historyLoading}
        >
          History
        </Button>
      </Space>
    ),
  }
];

const columns: ColumnsType<Delivery> = isMerchant
    ? baseColumns.filter(col => col.key !== 'merchant' && col.key !== 'driver' && col.key !== 'actions') as ColumnsType<Delivery>
    : baseColumns;
  
  const merchantId = isMerchant ? user.id : null;
  const [statusList, setStatusList] = useState<DeliveryStatus[]>([]);
  const searchParams = useSearchParams();
  const statusIdsParam = searchParams.get('status_ids') || '';
    const initialStatusIds = searchParams.get('status_ids');
  const parsedStatuses = initialStatusIds
    ? initialStatusIds.split(',').map(id => parseInt(id))
    : [];
  
  const [selectedStatuses, setSelectedStatuses] = useState<number[]>(parsedStatuses);
    const [selectedMerchantId, setSelectedMerchantId] = useState(merchantId || '');
  const [selectedDriver, setSelectedDriver] = useState(null);
  const [loading, setLoading] = useState(false);

  const [fetched, setFetched] = useState(false); // prevent re-fetch
  const [merchantFilter, setMerchantFilter] = useState<number | null>(null);
  const [driverFilter, setDriverFilter] = useState<number | null>(null);

  const [phoneFilter, setPhoneFilter] = useState('');
  const handleIsPaidChange = (e: CheckboxChangeEvent) => {
    const checked = e.target.checked;
    setIsPaid(checked);
    setPriceDisabled(checked);
    if (checked) {
      form.setFieldsValue({ price: 0 });
    }
  };
  
  const handleDriverFilterChange = (value: number | null) => {
    setMerchantFilter(value);
    setPagination((prev) => ({ ...prev, current: 1 }));
  };

  const handleRealDriverFilterChange = (value: number | null) => {
    setDriverFilter(value);
    setPagination((prev) => ({ ...prev, current: 1 }));
  };

  const handleStatusSelection = (value: number) => {
    setSelectedStatusId(value); // Set the selected driver ID
  };
  
  const fetchMerchant = async () => {
    if (fetched) return; // only fetch once
    setLoading(true);
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/merchant`);
      const result = await response.json();
      if (result.success) {
        setDrivers(result.data);
        setFetched(true);
      }
    } catch (error) {
      console.error('Failed to fetch drivers:', error);
    } finally {
      setLoading(false);
    }
  };


  const fetchDriver = async () => {
    if (fetched) return; // only fetch once
    setLoading(true);
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/drivers`);
      const result = await response.json();
      if (result.success) {
        setRealdriver(result.data);
        setFetched(true);
      }
    } catch (error) {
      console.error('Failed to fetch drivers:', error);
    } finally {
      setLoading(false);
    }
  };

// Handle delivery history
const handleViewHistory = async (deliveryId: number) => {
  setHistoryLoading(true);
  try {
    const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/${deliveryId}/history`);
    const result = await response.json();
    
    if (result.success) {
      setDeliveryHistory(result.data);
      setIsHistoryModal(true);
    } else {
      message.error('Failed to load delivery history');
    }
  } catch (error) {
    console.error('Error fetching delivery history:', error);
    message.error('Error loading delivery history');
  } finally {
    setHistoryLoading(false);
  }
};
  
  const handleStatus = async () => {
    if (selectedRowKeys.length === 0) {
      alert('Please select at least one delivery.');
      return;
    }

    // Fetch drivers only when this function is called
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/status`);
      const result = await response.json();
      
      if (result.success) {
        setStatus(result.data); // Set the list of drivers
        setIsStatusModal(true); // Open the modal
      } else {
        alert('Failed to load drivers.');
      }
    } catch (error) {
      console.error('Error fetching drivers:', error);
      alert('Error fetching drivers.');
    }
  };

  const handeStatusChange = async () => {
    if (!selectStatusId) {
      alert('Please select a status!');
      return;
    }
  
    // Send the selected driver ID and the selected delivery IDs to the backend
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/status`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          status_id: selectStatusId,
          delivery_ids: selectedRowKeys, // Pass the selected delivery IDs
        }),
      });
  
      const result = await response.json();
  
      if (result.success) {
        // Close the modal and reset the state
        setIsStatusModal(false);
        setSelectedStatusId(null);
        alert('Deliveries status changed successfully.');
  
        // Fetch updated delivery data here to refresh the table
        const updatedDeliveriesResponse = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery`);
        const updatedDeliveries = await updatedDeliveriesResponse.json();
  
        if (updatedDeliveries.success) {
          // Update the state with the new deliveries data
          setDeliveryData(updatedDeliveries.data);
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
  
  async function fetchItemsForDelivery(deliveryId: number): Promise<Item[]> {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/${deliveryId}/items`);
      if (!response.ok) {
        throw new Error(`Error fetching items: ${response.statusText}`);
      }
      const data = await response.json();
  
      // Assuming your API response format: { success: true, data: [...] }
      if (data.success && Array.isArray(data.data)) {
        return data.data;
      } else {
        throw new Error('Invalid data format received');
      }
    } catch (error) {
      console.error(error);
      return []; // Return empty array on error to avoid breaking UI
    }
  }

  // Add this handler function
const handleDistrictFilterChange = (value: number | null) => {
  setDistrictFilter(value);
  setPagination((prev) => ({ ...prev, current: 1 }));
};
  

  const handleExpand = async (expanded: boolean, record: Delivery) => {
    if (expanded) {
      setExpandedRowKeys([record.id]); // allow only 1 expanded row
  
      // If items not already loaded, fetch them
      if (!expandedItems[record.id]) {
        setLoadingRows((prev) => [...prev, record.id]);
        const items = await fetchItemsForDelivery(record.id);
        setExpandedItems((prev) => ({ ...prev, [record.id]: items }));
        setLoadingRows((prev) => prev.filter((id) => id !== record.id));
      }
    } else {
      setExpandedRowKeys([]);
    }
  };

  React.useEffect(() => {
    
    if (pullFromWarehouse) {
      if (!selectedMerchantId) {
        message.warning('Дэлгүүрийг эхлээд сонгоно уу!');
        setPullFromWarehouse(false); // uncheck checkbox automatically
        return;
      }
      // fetch products
      (async () => {
        try {
          const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/good?merchant_id=${selectedMerchantId}`);
          const json = await res.json();
  
          if (json.success) {
            const apiProducts = json.data.map((item: any) => ({
              id: item.id.toString(),
              name: item.name,
              stock: item.stock || 0,
            }));
            setProducts(apiProducts);
          } else {
            message.error('Барааг ачааллахад алдаа гарлаа');
            setProducts([]);
          }
        } catch (error) {
          message.error('Сүлжээний алдаа');
          setProducts([]);
        }
      })();
    } else {
      // If checkbox unchecked, clear products & product list
      setProducts([]);
      setProductList([]);
    }
  }, [pullFromWarehouse, merchantId]);
  const handleDelete = async () => {
    // Шалгах: бүх сонгогдсон item-уудын статус 1 эсэх
    const selectedDeliveries = deliveryData.filter(item => selectedRowKeys.includes(item.id));
    const nonDeletable = selectedDeliveries.filter(item => item.status !== 1);
  
    if (nonDeletable.length > 0) {
      message.warning("Устгах боломжгүй хүргэлт байна.");
      return;
    }
  
    Modal.confirm({
      title: `Та ${selectedRowKeys.length} ширхэг хүргэлтийг устгахдаа итгэлтэй байна уу?`,
      okText: "Тийм",
      cancelText: "Үгүй",
      onOk: async () => {
        try {
          const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/delete-multiple`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify({ ids: selectedRowKeys }),
          });
  
          if (!response.ok) throw new Error("Амжилтгүй боллоо");
  
          message.success("Амжилттай устгагдлаа");
  
          const refreshed = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery`);
          const refreshedResult = await refreshed.json();
          if (refreshedResult.success) {
            setDeliveryData(refreshedResult.data);
          }
  
          form.resetFields();
          setIsDrawerVisible(false);
          setSelectedRowKeys([]);
        }  catch (error) {
          const err = error as Error;
          message.error("Алдаа гарлаа: " + err.message);
        }
      },
    });
  };
  
  // Merchant Select onChange
  // const handleMerchantChange = (value: number) => {
  //   setMerchantId(value);
  //   // Reset products & selections when merchant changes
  //   setProducts([]);
  //   setSelectedProduct(null);
  //   setProductList([]);
  // };
 
  useEffect(() => {
    console.log('isMerchant:', isMerchant);

    form.setFieldsValue({ merchantId: selectedMerchantId });

    const fetchAllData = async () => {
      try {
        document.title = 'Хүргэлт';
  
        // Init user & permissions
        const storedUser = window.localStorage.getItem('user');
        const storedPermissions = window.localStorage.getItem('permissions');
  
        if (storedPermissions) setPermissions(JSON.parse(storedPermissions));
        const parsedUser = storedUser ? JSON.parse(storedUser) : null;
  
        const userIsMerchant = parsedUser?.role === 2;
        const merchantId = userIsMerchant ? parsedUser.id : null;
  
        if (userIsMerchant) {
          form.setFieldsValue({ merchantId });
        }
  
        // Fetch merchants only once
        if (merchants.length === 0) {
          const merchantRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/merchant`);
          const merchantsResult = await merchantRes.json();
          if (merchantsResult.success) setMerchants(merchantsResult.data);
        }
  
        // Fetch statuses only once
        if (statusList.length === 0) {
          const statusRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/status`);
          const statusResult = await statusRes.json();
          if (statusResult.success) setStatusList(statusResult.data);
        }
  
        // Build delivery URL with filters
        let url = `${process.env.NEXT_PUBLIC_API_URL}/api/delivery?page=${pagination.current}&limit=${pagination.pageSize}`;
  
        if (userIsMerchant) {
          url += `&merchant_id=${merchantId}`;
        } else if (merchantFilter) {
          url += `&merchant=${merchantFilter}`;
        }

        if (merchantFilter) {
          url += `&merchant_id=${merchantFilter}`;
        }

        if (districtFilter) {
        url += `&dist_id=${districtFilter}`;
        }


        if (driverFilter) {
          url += `&driver_id=${driverFilter}`;
        }


        if(phoneFilter) {
          url += `&phone=${phoneFilter}`;
        }
  
        if (selectedStatuses.length > 0) {
          url += `&status_ids=${selectedStatuses.join(',')}`;
        }
  
        if (dateRange[0] && dateRange[1]) {
          url += `&start_date=${dateRange[0]?.format('YYYY-MM-DD')}`;
          url += `&end_date=${dateRange[1]?.format('YYYY-MM-DD')}`;
        }
  
        const deliveryRes = await fetch(url);
        const deliveryResult = await deliveryRes.json();
        if (deliveryResult.success) {
          setDeliveryData(deliveryResult.data);
          setPagination((prev) => ({ ...prev, total: deliveryResult.pagination.total }));
        }
  
      } catch (err) {
        console.error('Error initializing or fetching data:', err);
      }
    };
  
    fetchAllData();
  }, [pagination.current, pagination.pageSize, merchantFilter, selectedStatuses, phoneFilter,dateRange,selectedMerchantId, driverFilter, districtFilter,refreshKey,statusIdsParam ]);
  
  
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

  const handleCheckboxChange = () => {
    setPullFromWarehouse(prev => !prev);

  };
  
  const handleAddProduct = () => {
    if (!selectedProduct || quantity < 1) {
      message.warning('Бараа болон тоо оруулна уу');
      return;
    }
  
    const productObj = products.find(p => p.id === selectedProduct);
  
    if (!productObj) {
      message.error("Сонгосон бараа олдсонгүй!");
      return;
    }

    // Check stock availability
    // Calculate total quantity needed (including items already in the list)
    const existingQuantity = productList
      .filter(item => item.productId === selectedProduct)
      .reduce((sum, item) => sum + item.quantity, 0);
    
    const totalQuantityNeeded = existingQuantity + quantity;
    const availableStock = productObj.stock || 0;

    if (totalQuantityNeeded > availableStock) {
      message.error(
        `Агуулахын үлдэгдэл хүрэлцэхгүй байна. Боломжтой: ${availableStock} ширхэг, Шаардлагатай: ${totalQuantityNeeded} ширхэг`
      );
      return;
    }
  
    setProductList(prev => {
      // Add new item with current productPrice (from input)
      const newList = [
        ...prev,
        {
          productId: productObj.id,
          productName: productObj.name,
          quantity,
          price: productPrice, // store input price per item here!
        }
      ];
  
      // Calculate total sum using each item's own price
      const totalSum = newList.reduce((acc, item) => acc + item.price * item.quantity, 0);
  
      if (totalSum > 0) {
        form.setFieldsValue({ price: totalSum });
      }
  
      return newList;
    });
  
    setSelectedProduct(null);
    setQuantity(1);
    setProductPrice(0); // reset price input if needed
  };
  

  // Handle form submission (for example, you could save data here)
const handleOk = async () => {
  // Prevent multiple submissions
  if (isSubmitting) return;
  
  setIsSubmitting(true); // Disable the button
  
  try {
    const values = await form.validateFields();

    // Construct payload including items from warehouse
    const payload = {
      merchant_id: isMerchant ? user.id : values.merchantId,
      phone: values.phone,
      address: values.address,
      status: 1,
      dist_id: values.dist_id, // Add district ID
      is_paid: isPaid,
      is_rural: isRural,
      price: Number(values.price),
      comment: values.comment,
      items: productList.map(item => ({
        good_id: item.productId,
        quantity: item.quantity,
      }))
    };

    const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    const result = await response.json();

    if (result.success) {
      message.success('Амжилттай бүртгэгдлээ');
      setRefreshKey(prev => prev + 1);
      form.resetFields();
      setProductList([]);
      setSelectedProduct(null);
      setQuantity(1);
      setProductPrice(0);
      setIsDrawerVisible(false);
    } else {
      message.error('Хадгалахад алдаа гарлаа: ' + result.message);
    }
  } catch (err) {
    console.error('Validation or request error:', err);
    message.error('Формыг шалгана уу.');
  } finally {
    // Re-enable the button whether success or failure
    setIsSubmitting(false);
  }
};

  
  const handleDeleteProduct = (productId: string) => {
    setProductList(prev => {
      const newList = prev.filter(item => item.productId !== productId);
  
      // Recalculate total sum after deletion
      const totalSum = newList.reduce((acc, item) => acc + item.price * item.quantity, 0);
  
      // Update form price field accordingly
      form.setFieldsValue({ price: totalSum > 0 ? totalSum : undefined });
  
      return newList;
    });
  };
  
  const toggleStatus = (id: number) => {
    setSelectedStatuses((prev) =>
      prev.includes(id) ? prev.filter((statusId) => statusId !== id) : [...prev, id]
    );
  };

  
// Inside your component:
const processExcelFile = async (file: File) => {
  const reader = new FileReader();
  reader.onload = async (e) => {
    const data = new Uint8Array(e.target?.result as ArrayBuffer);
    const workbook = XLSX.read(data, { type: 'array' });
    const sheet = workbook.Sheets[workbook.SheetNames[0]];
    const json = XLSX.utils.sheet_to_json(sheet, { header: 1 });

    const rows = json.slice(1); // Skip header row
    const formatted = rows.map((row: any) => ({
      merchantName: row[0],
      phone: row[1],
      address: row[2],
      price: row[3],
      comment: row[4],
    }));

    console.log('Parsed Excel:', formatted);

    const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/import`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ deliveries: formatted }),
    });

    const result = await response.json();
    if (result.success) {
      alert(`${result.inserted || formatted.length} deliveries imported successfully.`);
      const refreshed = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery`);
      const refreshedResult = await refreshed.json();
      if (refreshedResult.success) setDeliveryData(refreshedResult.data);
    } else {
      alert('Import failed');
    }
  };
  reader.readAsArrayBuffer(file);
};

const handleDrop = (e: React.DragEvent<HTMLDivElement>) => {
  e.preventDefault();
  const file = e.dataTransfer.files[0];
  if (file && file.name.endsWith('.xlsx')) {
    processExcelFile(file);
  }
};
const loadAllItemsForPrint = async (deliveryIds: number[]) => {
  const missingIds = deliveryIds.filter(id => !expandedItems[id] && !loadingRows.includes(id));
  
  if (missingIds.length === 0) return expandedItems;
  
  setLoadingRows(prev => [...prev, ...missingIds]);
  
  try {
    const promises = missingIds.map(id => fetchItemsForDelivery(id));
    const results = await Promise.all(promises);
    
    const newExpandedItems = { ...expandedItems };
    missingIds.forEach((id, index) => {
      newExpandedItems[id] = results[index];
    });
    
    // Return the updated items immediately
    return newExpandedItems;
  } catch (error) {
    console.error('Error loading items for print:', error);
    message.warning('Failed to load some items for printing');
    return expandedItems; // Return current items on error
  } finally {
    setLoadingRows(prev => prev.filter(id => !missingIds.includes(id)));
  }
};

const handleExcelImport = (e: React.ChangeEvent<HTMLInputElement>) => {
  const file = e.target.files?.[0];
  if (file && file.name.endsWith('.xlsx')) {
    processExcelFile(file);
  }
};

  const handleCloseDrawer = () => {
    setIsDrawerVisible(false);
  };

  

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
  const hasPermission = (perm: string) => permissions.includes(perm);

  const handleSaveAllocation = async () => {
    if (!selectedDriverId) {
      alert('Please select a driver!');
      return;
    }
  
    // Send the selected driver ID and the selected delivery IDs to the backend
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/allocate`, {
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
        const updatedDeliveriesResponse = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery`);
        const updatedDeliveries = await updatedDeliveriesResponse.json();
  
        if (updatedDeliveries.success) {
          // Update the state with the new deliveries data
          setDeliveryData(updatedDeliveries.data);
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
      <h1 style={{ marginBottom: 24 }}>Хүргэлт</h1>

      <Space style={{ marginBottom: 16 }} wrap>
      <Input
    placeholder="Filter by Phone"
    value={phoneFilter}
    onChange={(e) => setPhoneFilter(e.target.value)}
    allowClear
  />
          {hasPermission('delivery:excel_import_delivery') && (

       <Select
  placeholder="Filter by Driver"
  style={{ width: 200 }}
  onChange={handleRealDriverFilterChange}
  onDropdownVisibleChange={(open) => {
    if (open) fetchDriver(); // if you want to fetch on demand
  }}
  allowClear
  showSearch
  optionFilterProp="children"
>
  {realdriver.map((driver) => (
    <Option key={driver.id} value={driver.id}>
      {driver.username || `Driver #${driver.id}`}
    </Option>
  ))}
</Select>
)}
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
         border: selectedStatuses.includes(status.id) ? '2px solid #52c41a' : '2px solid transparent',
         borderRadius: '4px',
       }}
     >
       {status.status}
     </Tag>
     
      ))}
         <Button
          type="primary"
          style={{ marginLeft: 'auto' }}
          onClick={handleDeliveryButton}
        >
          + Add Delivery
        </Button>
     {hasPermission('delivery:excel_import_delivery') && (
  <>
    {/* Add this to your filter section with other filters */}
    <Select
      placeholder="Дүүргээр шүүх"
      style={{ width: 200 }}
      value={districtFilter}
      onChange={handleDistrictFilterChange}
      allowClear
    >
      {districts.map((district) => (
        <Option key={district.id} value={district.id}>
          {district.name}
        </Option>
      ))}
    </Select>
    <Select
      placeholder="Filter by Merchant"
      style={{ width: 200 }}
      onChange={handleDriverFilterChange}
      onDropdownVisibleChange={(open) => {
        if (open) fetchMerchant();
      }}
      allowClear
      showSearch
      optionFilterProp="children"
    >
      {merchants.map((driver) => (
        <Option key={driver.id} value={driver.id}>
          {driver.username || `Driver #${driver.id}`}
        </Option>
      ))}
    </Select>
  </>
)}
        {hasPermission('delivery:excel_import_delivery') && (

        <div
  onClick={() => fileInputRef.current?.click()}
  onDragOver={(e) => e.preventDefault()}
  onDrop={handleDrop}
  style={{
    display: 'inline-block',
    padding: '8px 16px',
    border: '1px dashed #52c41a',
    borderRadius: '4px',
    backgroundColor: '#f6ffed',
    color: '#389e0d',
    fontWeight: 500,
    cursor: 'pointer',
    fontSize: '14px',
  }}
>
  📂 Import Excel
</div>
)}

<input
  ref={fileInputRef}
  type="file"
  accept=".xlsx, .xls"
  style={{ display: 'none' }}
  onChange={handleExcelImport}
/>

      </Space>

      <Table
  rowSelection={rowSelection}
  columns={columns}
  dataSource={deliveryData}
  rowKey="id"
  pagination={{
    current: pagination.current,
    pageSize: pagination.pageSize,
    total: pagination.total,
    showSizeChanger: true,
    pageSizeOptions: ['10', '50', '100', '1000'], // Add this line
    onChange: (page, pageSize) => {
      setPagination((prev) => ({
        ...prev,
        current: page,
        pageSize: pageSize || prev.pageSize,
      }));
    },
  }}
  rowClassName={(record) => (record.is_paid ? 'paid-row' : '')}
  expandable={{
    expandedRowRender: (record) => {
      if (loadingRows.includes(record.id)) {
        return <p>Loading items...</p>;
      }
      const items = expandedItems[record.id];
      if (!items || items.length === 0) return <p>No items found.</p>;

      const columns = [
        {
          dataIndex: ['good', 'name'],
          key: 'name',
          render: (text: string | undefined) => text || '-',
        },
        {
          dataIndex: 'quantity',
          key: 'quantity',
        },
      ];    

      return (
        <Table
          columns={columns}
          dataSource={items}
          pagination={false}
          rowKey="id"
          size="small"
          bordered
        />
      );
    },
    expandedRowKeys,
    onExpand: handleExpand,
    expandRowByClick: false,
  }}
/>
<Drawer
  title="Хүргэлт үүсгэх"
  placement="right"
  visible={isDrawerVisible}
  onClose={handleCloseDrawer}
  width={500}  // wider drawer
  bodyStyle={{ padding: '20px' }}
>
  <Form form={form}  initialValues={{ merchantId: selectedMerchantId }}
   layout="vertical">
    {/* Merchant, phone, address, price (total), comment ... */}

    {isMerchant ? (
    <>
      <Form.Item>
        <div style={{
          padding: '4px 11px',
          border: '1px solid #d9d9d9',
          borderRadius: 2,
          backgroundColor: '#f5f5f5',
          color: 'rgba(0, 0, 0, 0.85)',
          minHeight: 25,
        }}>
          {username}
        </div>
      </Form.Item>

      <Form.Item name="merchantId" hidden>
        <Input type="hidden" value={selectedMerchantId} />
      </Form.Item>
    </>
  ) : (
    <Form.Item
      label="Дэлгүүрийн нэр"
      name="merchantId"
      rules={[{ required: true, message: 'Please select a merchant!' }]}
    >
      <Select
        placeholder="Select a merchant"
        value={selectedMerchantId}
        onChange={(value) => setSelectedMerchantId(value)}
      >
        {merchants.map((merchant) => (
          <Select.Option key={merchant.id} value={merchant.id}>
            {merchant.username}
          </Select.Option>
        ))}
      </Select>
    </Form.Item>
  )}
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
  label="Дүүрэг"
  name="dist_id"
  rules={[{ required: true, message: 'Дүүрэг сонгоно уу!' }]}
>
  <Select placeholder="Дүүрэг сонгох">
    {districts.map((district) => (
      <Select.Option key={district.id} value={district.id}>
        {district.name}
      </Select.Option>
    ))}
  </Select>
</Form.Item>

    <Form.Item
  label="Үнэ"
  name="price"
  rules={[{ required: true, message: 'Please input the price!' }]}
>
  <Input
    placeholder="Enter price"
    disabled={priceDisabled}
    type="number"
  />
</Form.Item>

    <Form.Item
      label="Тайлбар"
      name="comment"
      rules={[{ required: true, message: 'Please input the comment!' }]}
    >
      <Input placeholder="Enter comment" />
    </Form.Item>
    <Form.Item>
  <Checkbox
    checked={isPaid}
    onChange={handleIsPaidChange}
  >
    Тооцоо хийсэн
  </Checkbox>
</Form.Item>


<Form.Item>
  <Checkbox
    checked={isRural}
    onChange={(e) => setIsRural(e.target.checked)}
  >
    Орон нутаг
  </Checkbox>
</Form.Item>
   <Form.Item>
  <Button 
    type="primary" 
    onClick={handleOk} 
    block
    loading={isSubmitting} // Show loading state
    disabled={isSubmitting} // Disable when submitting
  >
    {isSubmitting ? 'Үүсгэж байна...' : 'Үүсгэх'}
  </Button>
</Form.Item>
    <Form.Item>
        <Checkbox checked={pullFromWarehouse} onChange={handleCheckboxChange}>
          Агуулахаас бараа татах?
        </Checkbox>
      </Form.Item>

    {pullFromWarehouse && (
      <>
        <Row gutter={8} style={{ marginBottom: 10 }}>
          <Col span={8}>
          <Select
          value={selectedProduct}
          placeholder="Бараа сонгох"
          onChange={setSelectedProduct}
          style={{ width: '100%' }}
          showSearch
          optionFilterProp="children"
        >
          {products.map(p => (
            <Option key={p.id} value={p.id}>
              {p.name} (Үлдэгдэл: {p.stock})
            </Option>
          ))}
        </Select>

          </Col>

          <Col span={6}>
            <InputNumber
              min={1}
              value={quantity}
              onChange={value => setQuantity(value || 1)}
              style={{ width: '100%' }}
              placeholder="Тоо ширхэг"
            />
          </Col>

          <Col span={6}>
            <InputNumber
              min={0}
              value={productPrice}
              onChange={value => setProductPrice(value || 0)}
              style={{ width: '100%' }}
              placeholder="Үнэ"
              formatter={value => `${value} ₮`}
              parser={value => {
                if (!value) return 0; // Return 0 when empty
                const numericString = value.replace(/₮\s?|(,*)/g, '');
                return Number(numericString);
              }}
                      />
          </Col>

          <Col span={4}>
            <Button
              type="primary"
              onClick={handleAddProduct}
              icon={<PlusOutlined />}
              block
            />
          </Col>
        </Row>

        <List
        bordered
        size="small"
        locale={{ emptyText: 'Бараа нэмэгдээгүй' }}
        dataSource={productList}
        renderItem={item => (
          <List.Item
            actions={[
              <Button
                danger
                size="small"
                icon={<DeleteOutlined />}
                onClick={() => handleDeleteProduct(item.productId)}
              />
            ]}
          >
            <strong>{item.productName}</strong> - {item.quantity} ширхэг - {item.price.toLocaleString()} ₮
          </List.Item>
          )}
        />

      </>
    )}
  </Form>
</Drawer>
      {/* Fixed Bottom Section */}
      {hasPermission('delivery:excel_import_delivery') && (


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
          <Button
            type="primary"
            onClick={handleDelete}
            disabled={selectedRowKeys.length === 0}
          >
            Устгах
          </Button>
          <Button
            type="primary"
            onClick={handleStatus}
            disabled={selectedRowKeys.length === 0}
          >
            Төлөв солих
          </Button>
<Button
  type="primary"
  disabled={selectedRowKeys.length === 0}
  onClick={async () => {
    try {
      const selectedIds = selectedRowKeys.map(id => Number(id));
      
      // Get the updated items directly from the function
      const updatedItems = await loadAllItemsForPrint(selectedIds);
      
      const selectedRows = deliveryData.filter(item =>
        selectedRowKeys.includes(item.id)
      );

      // Use the returned items directly instead of relying on state
      const rowsWithItems = selectedRows.map(row => ({
        ...row,
        items: updatedItems[row.id] || []
      }));

      console.log('Selected rows with items:', rowsWithItems);

      // Get unique driver names
      const uniqueDrivers = [...new Set(rowsWithItems
        .map(row => row.driver?.username)
        .filter(Boolean)
      )].join(', ');

      const printWindow = window.open('', '_blank');
      if (printWindow) {
        printWindow.document.write('<html><head><title>Print</title>');
        printWindow.document.write(`
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .header {
              text-align: center;
              margin-bottom: 20px;
              border-bottom: 2px solid #333;
              padding-bottom: 10px;
            }
            .logo {
              max-width: 200px;
              height: auto;
              margin-bottom: 10px;
            }
            .driver-info {
              text-align: center;
              margin: 10px 0;
              font-weight: bold;
              font-size: 14px;
            }
            table {
              width: 100%;
              border-collapse: collapse;
              margin-top: 20px;
              font-size: 9px;
            }
            th, td {
              border: 1px solid #ccc;
              padding: 4px 6px;
              text-align: left;
            }
            th {
              background-color: #f5f5f5;
              font-weight: bold;
            }
            .items-cell {
              max-width: 200px;
              white-space: normal;
            }
            @page {
              size: A4 portrait;
              margin: 10mm 10mm 10mm 10mm;
            }
            .page-break {
              page-break-before: always;
            }
          </style>
        `);
        printWindow.document.write('</head><body>');
        
        // Header with logo
       printWindow.document.write(`
  <div class="header" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px;">
    <div style="flex: 1;">
      <img src="/logoo.png" alt="Logo" class="logo" onerror="this.style.display='none'" style="max-width: 120px; height: auto;">
    </div>
    ${uniqueDrivers ? `
      <div style="flex: 1; text-align: right;">
        <div style="font-weight: bold; font-size: 14px; margin-bottom: 5px;">Жолооч:</div>
        <div style="font-size: 13px;">${uniqueDrivers}</div>
      </div>
    ` : ''}
  </div>
`);
        printWindow.document.write(`
          <table>
            <thead>
              <tr>
                <th>Дэлгүүр</th>
                <th>Хаяг</th>
                <th>Утас</th>
                <th>Үнэ</th>
                <th>Бараа</th>
                <th>Тайлбар</th>
              </tr>
            </thead>
            <tbody>
        `);

        rowsWithItems.forEach(row => {
          // Format dates
          const createdAt = row.createdAt ? dayjs(row.createdAt).format('YYYY-MM-DD HH:mm') : '-';
          
          // Format items as "Item1 (2), Item2 (1), ..."
          const itemsText = row.items && row.items.length > 0 
            ? row.items.map(item => 
                `${item.good?.name || 'Unknown'} (${item.quantity})`
              ).join(', ')
            : 'Бараа байхгүй';

          printWindow.document.write(`
            <tr>
              <td>${row.merchant?.username ?? '-'}</td>
              <td>${row.address}</td>
              <td>${row.phone}</td>
              <td>${row.price?.toLocaleString() ?? '0'}₮</td>
              <td class="items-cell">${itemsText}</td>
              <td>${row.comment ?? '-'}</td>
            </tr>
          `);
        });

        printWindow.document.write('</tbody></table>');
        
        // Footer with total count
        printWindow.document.write(`
          <div style="margin-top: 20px; text-align: right; font-size: 10px;">
            Нийт: ${rowsWithItems.length} хүргэлт
          </div>
        `);
        
        printWindow.document.write('</body></html>');
        printWindow.document.close();
        printWindow.print();
      }
    } catch (error) {
      console.error('Print error:', error);
      message.error('Failed to load items for printing');
    }
  }}
>
  Print Selected
</Button>
<Button
  type="default"
  disabled={selectedRowKeys.length === 0}
  onClick={() => {
    const selectedRows = deliveryData.filter(item =>
      selectedRowKeys.includes(item.id)
    );

    // Prepare data for Excel
    const excelData = selectedRows.map(row => ({
      'Дэлгүүр': row.merchant?.username ?? '-',
      'Хаяг': row.address,
      'Утас': row.phone,
      'Үнэ': row.price,
      'Тайлбар': row.comment ?? '-',
    }));

    // Convert to worksheet
    const worksheet = XLSX.utils.json_to_sheet(excelData);

    // Create workbook and add worksheet
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Selected Deliveries');

    // Export Excel file
    XLSX.writeFile(workbook, 'selected_deliveries.xlsx');
  }}
  style={{ marginLeft: 8 }} // Хажууд зай авах
>
  Export Excel
</Button>
        </Space>
        
      </div>
      )}
      <Modal
  title="Select Driver"
  visible={isModalVisible}
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
    showSearch
    filterOption={(input, option) => {
      if (!option || !option.children) return false;
      const optionText = String(option.children);
      return optionText.toLowerCase().includes(input.toLowerCase());
    }}
    optionFilterProp="children"
  >
    {drivers.map((driver) => (
      <Option key={driver.id} value={driver.id}>
        {driver.username}
      </Option>
    ))}
  </Select>
</Modal>
      <Modal
        title="Select status"
        visible={isStatusModal}
        onCancel={() => setIsStatusModal(false)}
        onOk={handeStatusChange}
        okText="Save"
        cancelText="Cancel"
      >
        <Select
          style={{ width: '100%' }}
          placeholder="Select a status"
          onChange={handleStatusSelection}
          value={selectStatusId}
        >
          {status.map((stat) => (
            <Option key={stat.id} value={stat.id}>
              {stat.status}
            </Option>
          ))}
        </Select>
      </Modal>

<Modal
  title="Delivery History"
  visible={isHistoryModal}
  onCancel={() => setIsHistoryModal(false)}
  footer={[
    <Button key="close" onClick={() => setIsHistoryModal(false)}>
      Close
    </Button>
  ]}
  width={800}
>
  {deliveryHistory.length === 0 ? (
    <p>No history found</p>
  ) : (
    <Table
      dataSource={deliveryHistory}
      rowKey="id"
      pagination={false}
      size="small"
      columns={[
        {
          title: 'Date',
          dataIndex: 'createdAt',
          key: 'createdAt',
          render: (text: string) => dayjs(text).format('YYYY-MM-DD HH:mm'),
          width: 150,
        },
        {
          title: 'Status',
          dataIndex: ['status_name', 'status'],
          key: 'status',
          render: (status: string, record: DeliveryHistory) => (
            <Tag color={record.status_name.color}>
              {status}
            </Tag>
          ),
        },
        {
          title: 'Driver',
          dataIndex: ['driver', 'username'],
          key: 'driver',
          render: (driverName: string, record: DeliveryHistory) => 
            record.driver ? `${driverName} (${record.driver.phone})` : '-',
        },
      ]}
    />
  )}
</Modal>
    
      <Modal
  title="Edit Phone & Address"
  visible={isEditModal}
  onOk={handleEdit}
  onCancel={handleCancel}
  okText="Save"
  cancelText="Cancel"
>
  <Form form={form} layout="vertical">
    <Form.Item name="phone" label="Phone" rules={[{ required: true, message: 'Please enter phone number' }]}>
      <Input />
    </Form.Item>
    <Form.Item name="address" label="Address" rules={[{ required: true, message: 'Please enter address' }]}>
      <Input />
    </Form.Item>
    <Form.Item name="price" label="Price" rules={[{ required: true, message: 'Please enter Price' }]}>
      <Input />
    </Form.Item>
  </Form>
</Modal>
    </div>
  );
}