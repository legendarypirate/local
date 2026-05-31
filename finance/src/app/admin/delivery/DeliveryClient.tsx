'use client';

import './delivery-admin.css';
import React, { useState, useMemo, useRef, useEffect, Suspense } from 'react';
import { Table, Button, Space, Input, DatePicker, Drawer, Form, Select, Tag, Modal, App, Checkbox, message, InputNumber, List, Row, Col, Tooltip, Image } from 'antd';
import type { CheckboxProps } from 'antd';
import type { TableColumnsType } from 'antd';
import { EditOutlined, DeleteOutlined, PlusOutlined, HistoryOutlined, PictureOutlined } from '@ant-design/icons';
import dayjs, { Dayjs } from 'dayjs';
import isSameOrAfter from 'dayjs/plugin/isSameOrAfter';
import isSameOrBefore from 'dayjs/plugin/isSameOrBefore';
import * as XLSX from 'xlsx';
const { Option } = Select;
import { useSearchParams } from 'next/navigation';
import GoogleAddressAutocomplete from '@/components/GoogleAddressAutocomplete';

const { RangePicker } = DatePicker;
dayjs.extend(isSameOrAfter);
dayjs.extend(isSameOrBefore);

/** Remove spaces, dashes, parentheses, etc. — e.g. "9909 0099" → "99090099" */
function normalizeDeliveryPhone(raw: unknown): string {
  if (raw == null) return '';
  return String(raw).replace(/\D/g, '');
}

const RETURN_PRINT_STATUS_NAMES = [
  'буцаасан',
  'утсаа аваагүй',
  'хаягаар очсон',
  'дараа авна',
  'маргааш авна',
];

const DELIVERY_PRINT_STYLES = `
  body { font-family: Arial, sans-serif; margin: 0; padding: 20px; }
  .header { text-align: center; margin-bottom: 20px; border-bottom: 2px solid #333; padding-bottom: 10px; }
  .logo { max-width: 200px; height: auto; margin-bottom: 10px; }
  .driver-section { margin-top: 6px; }
  .driver-title { font-weight: bold; font-size: 11px; margin: 4px 0 2px; border-bottom: 1px solid #ccc; padding-bottom: 2px; }
  table { width: 100%; border-collapse: collapse; margin-top: 8px; font-size: 9px; }
  th, td { border: 1px solid #ccc; padding: 4px 6px; text-align: left; }
  th { background-color: #f5f5f5; font-weight: bold; }
  .items-cell { max-width: 200px; white-space: normal; }
  td.merchant-by-status {
    font-weight: 600;
    background-color: transparent !important;
    -webkit-print-color-adjust: exact;
    print-color-adjust: exact;
  }
  @page { size: A4 portrait; margin: 10mm; }
`;

function printMerchantCellStyle(color: string | undefined): string {
  if (!color || typeof color !== 'string') return 'color: #111; background-color: transparent;';
  const c = color.trim();
  if (!/^#[0-9A-Fa-f]{3,8}$/.test(c) && !/^[a-zA-Z]+$/.test(c)) {
    return 'color: #111; background-color: transparent;';
  }
  return `color: ${c}; background-color: transparent;`;
}

function escapePrintHtml(text: string): string {
  return String(text)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

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
  delivery_price?: number;
  delivery_image?: string | null;
  price_setting_id?: number | null;
  price_setting?: {
    id: number;
    label?: string | null;
    merchant_price: number;
    driver_price: number;
    is_default?: boolean;
  } | null;
  driver_report_price?: number;
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
  const [editModalItems, setEditModalItems] = useState<Item[]>([]);
  const [editModalLoading, setEditModalLoading] = useState(false);
  const [hasItemsLoaded, setHasItemsLoaded] = useState(false);


  // Add to your existing state variables
  const [districts, setDistricts] = useState<{ id: number; name: string }[]>([]);
  const [districtsLoading, setDistrictsLoading] = useState(false);

  const [selectedDistrict, setSelectedDistrict] = useState<number | null>(null);
  const [districtFilter, setDistrictFilter] = useState<number | null>(null);

  const [khoroos, setKhoroos] = useState<{ id: number; name: string }[]>([]);
  const [khoroosLoading, setKhoroosLoading] = useState(false);
  const [khorooFilter, setKhorooFilter] = useState<number | null>(null);
  const [formKhoroos, setFormKhoroos] = useState<{ id: number; name: string }[]>([]);
  const [formKhoroosLoading, setFormKhoroosLoading] = useState(false);
  const [selectedKhorooId, setSelectedKhorooId] = useState<number | null>(null);
  const [isDeliveryPriceModal, setIsDeliveryPriceModal] = useState(false);
  const [priceSettings, setPriceSettings] = useState<
    { id: number; label?: string | null; merchant_price: number; driver_price: number; is_default?: boolean }[]
  >([]);
  const [selectedPriceSettingId, setSelectedPriceSettingId] = useState<number | null>(null);
  const [deliveryPriceSubmitting, setDeliveryPriceSubmitting] = useState(false);
  const [deliveryImageModalOpen, setDeliveryImageModalOpen] = useState(false);
  const [deliveryImageUrl, setDeliveryImageUrl] = useState<string | null>(null);
  const [returnPrintLoading, setReturnPrintLoading] = useState(false);
  const { modal, message: msg } = App.useApp();

  const handleEditClick = async (record: Delivery) => {
    setSelectedDelivery(record);
    form.setFieldsValue({
      phone: normalizeDeliveryPhone(record.phone),
      address: record.address,
      price: record.price,
      comment: record.comment || '',
    });

    // Fetch items if delivery has items
    setEditModalLoading(true);
    setHasItemsLoaded(false);
    try {
      const items = await fetchItemsForDelivery(record.id);
      setEditModalItems(items);
      setHasItemsLoaded(true); // Mark that we've checked for items
    } catch (error) {
      console.error('Error fetching items:', error);
      setEditModalItems([]);
      setHasItemsLoaded(true); // Still mark as loaded even on error
    } finally {
      setEditModalLoading(false);
    }

    setIsEditModal(true);
  };

  const handleEdit = async () => {
    try {
      // Merchant can only edit deliveries with status 1
      if (isMerchant && selectedDelivery) {
        const statusVal = typeof selectedDelivery.status === 'number' ? selectedDelivery.status : parseInt(String(selectedDelivery.status), 10);
        if (statusVal !== 1 && selectedDelivery.status_name?.status !== 'шинэ') {
          msg.error('Зөвхөн шинэ хүргэлтийг засах боломжтой');
          return;
        }
      }

      const values = await form.validateFields();

      const updateData: any = {
        phone: normalizeDeliveryPhone(values.phone),
        address: values.address,
        price: values.price,
        comment: values.comment,
      };

      // Include items array if we've loaded items (even if empty, to allow deleting all items)
      if (hasItemsLoaded) {
        updateData.items = editModalItems.map(item => ({
          id: item.id, // Include id for existing items
          good_id: item.good_id,
          quantity: item.quantity,
        }));
      }

      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/${selectedDelivery?.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updateData),
      });

      const result = await response.json();

      if (response.ok && result.success) {
        msg.success('Delivery updated successfully');
        setIsEditModal(false);
        setEditModalItems([]);
        setHasItemsLoaded(false);
        setRefreshKey(prev => prev + 1); // Refresh the table
      } else {
        msg.error('Failed to update delivery: ' + (result.message || 'Unknown error'));
      }

    } catch (err) {
      console.error('Validation or request failed:', err);
      msg.error('Error updating delivery');
    }
  };

  const handleEditItemQuantity = (itemId: number, newQuantity: number) => {
    if (newQuantity < 1) {
      msg.warning('Quantity must be at least 1');
      return;
    }
    setEditModalItems(prev =>
      prev.map(item =>
        item.id === itemId ? { ...item, quantity: newQuantity } : item
      )
    );
  };

  const handleDeleteEditItem = (itemId: number) => {
    setEditModalItems(prev => prev.filter(item => item.id !== itemId));
  };

  const baseColumns: TableColumnsType<Delivery> = [
    {
      title: 'Үүссэн огноо',
      dataIndex: 'createdAt',
      width: 128,
      render: (text: string) => {
        return dayjs(text).format('YYYY-MM-DD hh:mm A');
      },
    },
    {
      title: 'Хүргэсэн огноо',
      dataIndex: 'delivered_at',
      width: 128,
      render: (text: string) => {
        return text ? dayjs(text).format('YYYY-MM-DD hh:mm A') : '-';
      },
    },
    {
      title: 'Мерчанд нэр',
      dataIndex: ['merchant', 'username'],
      key: 'merchant',
      width: 110,
      ellipsis: true,
      render: (_, record) => record.merchant?.username || '-'
    },
    {
      title: 'Утас / Хаяг',
      dataIndex: 'phone',
      key: 'phone_address',
      width: 180,
      className: 'delivery-cell-wrap',
      render: (phone: string, record: Delivery) => (
        <div className="delivery-cell-wrap">
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
      width: 110,
      render: (status_name: { status: string, color: string }) => (
        <Tag color={status_name.color}>
          {status_name.status}
        </Tag>
      ),
    },
    { title: 'Барааны үнэ', dataIndex: 'price', key: 'price', width: 96 },
    {
      title: 'Үнийн тохиргоо',
      key: 'price_setting',
      width: 160,
      ellipsis: true,
      render: (_: unknown, record: Delivery) => {
        const ps = record.price_setting;
        if (ps?.label) {
          return `${ps.label} (${Number(ps.merchant_price).toLocaleString()} / ${Number(ps.driver_price).toLocaleString()})`;
        }
        if (ps) {
          return `${Number(ps.merchant_price).toLocaleString()} / ${Number(ps.driver_price).toLocaleString()} ₮`;
        }
        return `${Number(record.delivery_price ?? 6000).toLocaleString()} / 4,000 ₮`;
      },
    },
    { title: 'Тайлбар', dataIndex: 'comment', width: 120, ellipsis: true },
    {
      title: 'Ж/тайлбар',
      dataIndex: 'driver_comment',
      key: 'driver_comment',
      width: 100,
      ellipsis: true,
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
      width: 100,
      ellipsis: true,
      render: (_, record) => record.driver?.username || '-'
    },
    {
      title: 'Үйлдэл',
      key: 'actions',
      width: 130,
      fixed: 'right',
      className: 'delivery-cell-actions',
      render: (_: any, record: Delivery) => {
        const statusValue = typeof record.status === 'number' ? record.status : parseInt(String(record.status), 10);
        const isNewDelivery = statusValue === 1 || record.status_name?.status === 'шинэ';

        return (
          <Space size="small">
            <Tooltip title="Засах">
              <Button
                type="text"
                size="small"
                icon={<EditOutlined />}
                onClick={() => handleEditClick(record)}
                aria-label="Засах"
              />
            </Tooltip>
            <Tooltip title="Түүх">
              <Button
                type="text"
                size="small"
                icon={<HistoryOutlined />}
                onClick={() => handleViewHistory(record.id)}
                loading={historyLoading}
                aria-label="Түүх"
              />
            </Tooltip>
            <Tooltip title={record.delivery_image ? 'VIEW IMAGE' : 'Зураг байхгүй'}>
              <Button
                type="text"
                size="small"
                icon={<PictureOutlined />}
                disabled={!record.delivery_image}
                onClick={() => {
                  setDeliveryImageUrl(record.delivery_image ?? null);
                  setDeliveryImageModalOpen(true);
                }}
                aria-label="VIEW IMAGE"
              />
            </Tooltip>
            {isNewDelivery && (
              <Tooltip title="Устгах">
                <Button
                  type="text"
                  size="small"
                  danger
                  icon={<DeleteOutlined />}
                  onClick={() => handleDeleteSingle(record.id)}
                  aria-label="Устгах"
                />
              </Tooltip>
            )}
          </Space>
        );
      },
    }
  ];

  // Merchant (customer): Edit only for status 1; no History, no Delete. Admin: full actions.
  const merchantActionsColumn: TableColumnsType<Delivery>[0] = {
    title: 'Үйлдэл',
    key: 'actions',
    render: (_: any, record: Delivery) => {
      const statusValue = typeof record.status === 'number' ? record.status : parseInt(String(record.status), 10);
      const canEdit = statusValue === 1 || record.status_name?.status === 'шинэ';

      return (
        <Space size="small">
          {canEdit && (
            <Tooltip title="Засах">
              <Button
                type="text"
                size="small"
                icon={<EditOutlined />}
                onClick={() => handleEditClick(record)}
                aria-label="Засах"
              />
            </Tooltip>
          )}
        </Space>
      );
    },
  };

  const columns: TableColumnsType<Delivery> = isMerchant
    ? ([...baseColumns.filter(col => col.key !== 'merchant' && col.key !== 'driver' && col.key !== 'actions'), merchantActionsColumn] as TableColumnsType<Delivery>)
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

  const [merchantFilter, setMerchantFilter] = useState<number | null>(null);
  const [driverFilter, setDriverFilter] = useState<number | null>(null);

  const [phoneFilter, setPhoneFilter] = useState('');
  const handleIsPaidChange: NonNullable<CheckboxProps['onChange']> = (e) => {
    const checked = e.target.checked;
    setIsPaid(checked);
    setPriceDisabled(checked);
    if (checked) {
      form.setFieldsValue({ price: 0 });
    }
  };

  const handleMerchantFilterChange = (value: number | null) => {
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

  /** Дэлгүүрийн шүүлт: `users` хүснэгтийн харилцагч (role_id=2), id + username */
  const ensureMerchantsForFilter = async () => {
    if (merchants.length > 0) return;
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/merchant`);
      const result = await response.json();
      if (result.success && Array.isArray(result.data)) {
        setMerchants(result.data);
      }
    } catch (error) {
      console.error('Failed to fetch merchants:', error);
    }
  };

  const fetchDriver = async () => {
    if (realdriver.length > 0) return;
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/drivers`);
      const result = await response.json();
      if (result.success && Array.isArray(result.data)) {
        setRealdriver(result.data);
      }
    } catch (error) {
      console.error('Failed to fetch drivers:', error);
    }
  };

  const fetchDistricts = async () => {
    if (districts.length > 0) return; // only fetch once if already loaded
    setDistrictsLoading(true);
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/region`);
      const result = await response.json();
      if (result.success) {
        setDistricts(result.data);
      } else {
        msg.error('Failed to load districts');
      }
    } catch (error) {
      console.error('Failed to fetch districts:', error);
      msg.error('Error loading districts');
    } finally {
      setDistrictsLoading(false);
    }
  };

  const fetchKhoroos = async (regionId: number, isForForm: boolean = false): Promise<{ id: number; name: string }[]> => {
    if (!regionId) {
      if (isForForm) {
        setFormKhoroos([]);
      } else {
        setKhoroos([]);
      }
      return [];
    }
    if (isForForm) {
      setFormKhoroosLoading(true);
    } else {
      setKhoroosLoading(true);
    }
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/khoroo?region_id=${regionId}`);
      const result = await response.json();
      if (result.success) {
        const khoroosData = result.data || [];
        if (isForForm) {
          setFormKhoroos(khoroosData);
        } else {
          setKhoroos(khoroosData);
        }
        return khoroosData;
      } else {
        msg.error('Failed to load khoroos');
        if (isForForm) {
          setFormKhoroos([]);
        } else {
          setKhoroos([]);
        }
        return [];
      }
    } catch (error) {
      console.error('Failed to fetch khoroos:', error);
      msg.error('Error loading khoroos');
      if (isForForm) {
        setFormKhoroos([]);
      } else {
        setKhoroos([]);
      }
      return [];
    } finally {
      if (isForForm) {
        setFormKhoroosLoading(false);
      } else {
        setKhoroosLoading(false);
      }
    }
  };

  const createKhoroo = async (regionId: number, khorooName: string): Promise<{ id: number; name: string } | null> => {
    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/khoroo`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: khorooName,
          region_id: regionId,
        }),
      });

      const result = await response.json();
      if (result.success) {
        console.log(`Auto-created khoroo: ${khorooName} for region ${regionId}`);
        return result.data;
      } else {
        console.error('Failed to create khoroo:', result.message);
        return null;
      }
    } catch (error) {
      console.error('Error creating khoroo:', error);
      return null;
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
        msg.error('Failed to load delivery history');
      }
    } catch (error) {
      console.error('Error fetching delivery history:', error);
      msg.error('Error loading delivery history');
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
    setKhorooFilter(null); // Clear khoroo filter when district changes
    if (value) {
      fetchKhoroos(value); // Fetch khoroos for the selected district
    } else {
      setKhoroos([]); // Clear khoroos if no district selected
    }
    setPagination((prev) => ({ ...prev, current: 1 }));
  };

  const handleKhorooFilterChange = (value: number | null) => {
    setKhorooFilter(value);
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
        msg.warning('Дэлгүүрийг эхлээд сонгоно уу!');
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
            msg.error('Барааг ачааллахад алдаа гарлаа');
            setProducts([]);
          }
        } catch (error) {
          msg.error('Сүлжээний алдаа');
          setProducts([]);
        }
      })();
    } else {
      // If checkbox unchecked, clear products & product list
      setProducts([]);
      setProductList([]);
    }
  }, [pullFromWarehouse, merchantId]);
  const handleDeleteSingle = async (deliveryId: number) => {
    // Find the delivery to check its status
    const delivery = deliveryData.find(item => item.id === deliveryId);

    if (!delivery) {
      msg.error("Хүргэлт олдсонгүй");
      return;
    }

    // Check if status is 1 (new delivery) - handle both numeric and string status
    const statusValue = typeof delivery.status === 'number' ? delivery.status : parseInt(String(delivery.status), 10);
    const isNewDelivery = statusValue === 1 || delivery.status_name?.status === 'шинэ';

    if (!isNewDelivery) {
      msg.warning("Зөвхөн шинэ хүргэлтийг устгах боломжтой");
      return;
    }

    // Defer so modal opens after click handling (fixes production where table/overlay can unmount)
    const id = deliveryId;
    setTimeout(() => {
      modal.confirm({
        title: 'Хүргэлт устгах',
        content: 'Та энэ хүргэлтийг устгахдаа итгэлтэй байна уу?',
        okText: "Тийм",
        cancelText: "Үгүй",
        okButtonProps: { danger: true },
        onOk: async () => {
          try {
            const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/${id}`, {
              method: "DELETE",
              headers: {
                "Content-Type": "application/json",
              },
            });

            if (!response.ok) throw new Error("Амжилтгүй боллоо");

            msg.success("Амжилттай устгагдлаа");
            setRefreshKey(prev => prev + 1); // Refresh the table
          } catch (error) {
            const err = error as Error;
            msg.error("Алдаа гарлаа: " + err.message);
          }
        },
      });
    }, 0);
  };

  const handleDelete = async () => {
    // Шалгах: бүх сонгогдсон item-уудын статус 1 эсэх
    const selectedDeliveries = deliveryData.filter(item => selectedRowKeys.includes(item.id));
    const nonDeletable = selectedDeliveries.filter(item => item.status !== 1);

    if (nonDeletable.length > 0) {
      msg.warning("Устгах боломжгүй хүргэлт байна.");
      return;
    }

    const keysToDelete = [...selectedRowKeys];
    // Defer so modal opens after click handling (fixes production)
    setTimeout(() => {
      modal.confirm({
        title: `Та ${keysToDelete.length} ширхэг хүргэлтийг устгахдаа итгэлтэй байна уу?`,
        okText: "Тийм",
        cancelText: "Үгүй",
        onOk: async () => {
          try {
            const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/delete-multiple`, {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
              },
              body: JSON.stringify({ ids: keysToDelete }),
            });

            if (!response.ok) throw new Error("Амжилтгүй боллоо");

            msg.success("Амжилттай устгагдлаа");

            const refreshed = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery`);
            const refreshedResult = await refreshed.json();
            if (refreshedResult.success) {
              setDeliveryData(refreshedResult.data);
            }

            form.resetFields();
            setIsDrawerVisible(false);
            setSelectedRowKeys([]);
          } catch (error) {
            const err = error as Error;
            msg.error("Алдаа гарлаа: " + err.message);
          }
        },
      });
    }, 0);
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

        if (priceSettings.length === 0) {
          const psRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery-price-settings`);
          const psResult = await psRes.json();
          if (psResult.success && Array.isArray(psResult.data)) {
            setPriceSettings(psResult.data);
          }
        }

        // Fetch districts (regions) only once
        if (districts.length === 0) {
          await fetchDistricts();
        }

        // Build delivery URL with filters
        let url = `${process.env.NEXT_PUBLIC_API_URL}/api/delivery?page=${pagination.current}&limit=${pagination.pageSize}`;

        if (userIsMerchant) {
          url += `&merchant_id=${merchantId}`;
        } else if (merchantFilter) {
          url += `&merchant_id=${merchantFilter}`;
        }

        if (districtFilter) {
          url += `&dist_id=${districtFilter}`;
        }

        if (khorooFilter) {
          url += `&khoroo_id=${khorooFilter}`;
        }

        if (driverFilter) {
          url += `&driver_id=${driverFilter}`;
        }


        if (phoneFilter) {
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
  }, [pagination.current, pagination.pageSize, merchantFilter, selectedStatuses, phoneFilter, dateRange, selectedMerchantId, driverFilter, districtFilter, khorooFilter, refreshKey, statusIdsParam]);


  const rowSelection = {
    selectedRowKeys,
    onChange: (selectedKeys: React.Key[]) => {
      setSelectedRowKeys(selectedKeys);
    },
  };

  const handleDeliveryButton = () => {
    setIsDrawerVisible(true);
  };

  const openDeliveryPriceModal = () => {
    if (priceSettings.length === 0) {
      msg.warning('Үнийн тохиргоо байхгүй. Эхлээд Үнийн тохиргоо цэсээр нэмнэ үү.');
      return;
    }
    const selectedRows = deliveryData.filter((d) => selectedRowKeys.includes(d.id));
    const first = selectedRows[0];
    setSelectedPriceSettingId(first?.price_setting_id ?? priceSettings.find((p) => p.is_default)?.id ?? priceSettings[0]?.id ?? null);
    setIsDeliveryPriceModal(true);
  };

  const handleBulkDeliveryPriceSave = async () => {
    if (!selectedPriceSettingId) {
      msg.warning('Үнийн тохиргоо сонгоно уу');
      return;
    }
    if (selectedRowKeys.length === 0) {
      msg.warning('Хүргэлт сонгоно уу');
      return;
    }

    const setting = priceSettings.find((p) => p.id === selectedPriceSettingId);
    const ids = selectedRowKeys.map((k) => Number(k));

    setDeliveryPriceSubmitting(true);
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery/bulk-delivery-price`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          delivery_ids: ids,
          price_setting_id: selectedPriceSettingId,
        }),
      });
      const result = await res.json();
      const updated = Number(result.updated ?? 0);

      if (!res.ok || !result.success || updated < 1) {
        msg.error(result.message || 'Хүргэлтийн үнэ шинэчлэгдсэнгүй');
        return;
      }

      msg.success(`${updated} хүргэлтэд тохиргоо оноогдлоо`);
      setIsDeliveryPriceModal(false);
      if (setting) {
        setDeliveryData((prev) =>
          prev.map((d) =>
            ids.includes(d.id)
              ? {
                  ...d,
                  price_setting_id: setting.id,
                  delivery_price: setting.merchant_price,
                  price_setting: setting,
                  driver_report_price: setting.driver_price,
                }
              : d
          )
        );
      }
      setRefreshKey((prev) => prev + 1);
    } catch {
      msg.error('Алдаа гарлаа');
    } finally {
      setDeliveryPriceSubmitting(false);
    }
  };

  // Handle modal cancel
  const handleCancel = () => {
    setIsModalVisible(false);
  };

  const handleEditModalCancel = () => {
    setIsEditModal(false);
    setEditModalItems([]);
    setHasItemsLoaded(false);
    form.resetFields();
  };

  const handleCheckboxChange = () => {
    setPullFromWarehouse(prev => !prev);

  };

  const handleAddProduct = () => {
    if (!selectedProduct || quantity < 1) {
      msg.warning('Бараа болон тоо оруулна уу');
      return;
    }

    const productObj = products.find(p => p.id === selectedProduct);

    if (!productObj) {
      msg.error("Сонгосон бараа олдсонгүй!");
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
      msg.error(
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

      // Validate dist_id is set
      if (!values.dist_id) {
        msg.error('Дүүрэг олдсонгүй. Дүүгийг эхлээд сонгоно уу.');
        setIsSubmitting(false);
        return;
      }

      // Verify the district exists in our districts list
      const selectedDistrict = districts.find(d => d.id === values.dist_id);
      if (!selectedDistrict) {
        msg.error('Дүүрэг олдсонгүй. Дүүгийг эхлээд сонгоно уу.');
        setIsSubmitting(false);
        return;
      }

      // Construct payload including items from warehouse
      const payload = {
        merchant_id: isMerchant ? user.id : values.merchantId,
        phone: normalizeDeliveryPhone(values.phone),
        address: values.address,
        status: 1,
        dist_id: values.dist_id, // Add district ID
        khoroo_id: values.khoroo_id || null, // Add khoroo ID (optional)
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
        msg.success('Амжилттай бүртгэгдлээ');
        setRefreshKey(prev => prev + 1);
        form.resetFields();
        setProductList([]);
        setSelectedProduct(null);
        setQuantity(1);
        setProductPrice(0);
        setIsRural(false); // Reset rural checkbox after successful submission
        setIsDrawerVisible(false);
      } else {
        msg.error('Хадгалахад алдаа гарлаа: ' + result.message);
      }
    } catch (err) {
      console.error('Validation or request error:', err);
      msg.error('Формыг шалгана уу.');
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
        phone: normalizeDeliveryPhone(row[1]),
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
      msg.warning('Failed to load some items for printing');
      return expandedItems; // Return current items on error
    } finally {
      setLoadingRows(prev => prev.filter(id => !missingIds.includes(id)));
    }
  };

  const getReturnPrintStatusIds = (): number[] => {
    if (statusList.length === 0) return [5, 6, 7, 8, 9];
    return statusList
      .filter((s) => RETURN_PRINT_STATUS_NAMES.includes(s.status.toLowerCase().trim()))
      .map((s) => s.id);
  };

  const handlePrintReturns = async () => {
    setReturnPrintLoading(true);
    try {
      const statusIds = getReturnPrintStatusIds();
      if (statusIds.length === 0) {
        msg.error('Буцаалтын төлөв олдсонгүй');
        return;
      }

      const yesterday = dayjs().subtract(1, 'day').format('YYYY-MM-DD');
      const apiBase = process.env.NEXT_PUBLIC_API_URL;
      const url =
        `${apiBase}/api/delivery?page=1&limit=10000` +
        `&status_ids=${statusIds.join(',')}` +
        `&start_date=${yesterday}&end_date=${yesterday}`;

      const res = await fetch(url);
      const json = await res.json();
      if (!json.success || !Array.isArray(json.data) || json.data.length === 0) {
        msg.info(`Өчигдөр (${yesterday}) буцаалтын хүргэлт олдсонгүй`);
        return;
      }

      const deliveries = json.data as Delivery[];
      const ids = deliveries.map((d) => d.id);
      const itemsMap = await loadAllItemsForPrint(ids);
      const rowsWithItems = deliveries.map((row) => ({
        ...row,
        items: itemsMap[row.id] || [],
      }));

      const byDriver = new Map<string, typeof rowsWithItems>();
      for (const row of rowsWithItems) {
        const driverName = row.driver?.username?.trim() || 'Жолоочгүй';
        if (!byDriver.has(driverName)) byDriver.set(driverName, []);
        byDriver.get(driverName)!.push(row);
      }

      const driverNames = [...byDriver.keys()].sort((a, b) =>
        a.localeCompare(b, 'mn', { sensitivity: 'base' })
      );

      const printWindow = window.open('', '_blank');
      if (!printWindow) {
        msg.error('Хэвлэх цонх нээх боломжгүй');
        return;
      }

      printWindow.document.write('<html><head><title>Буцаалт</title>');
      printWindow.document.write(`<style>${DELIVERY_PRINT_STYLES}</style></head><body>`);
      printWindow.document.write(`
        <div class="header" style="display:flex;justify-content:space-between;align-items:flex-start;">
          <img src="/logoo.png" alt="Logo" class="logo" onerror="this.style.display='none'" style="max-width:120px;height:auto;">
          <div style="text-align:right;">
            <div style="font-weight:bold;font-size:16px;">Буцаалт</div>
            <div style="font-size:13px;">Өдөр: ${yesterday}</div>
            <div style="font-size:12px;margin-top:4px;">Нийт: ${rowsWithItems.length} хүргэлт</div>
          </div>
        </div>
      `);

      driverNames.forEach((driverName) => {
        const driverRows = byDriver.get(driverName) ?? [];
        printWindow.document.write(
          `<div class="driver-section"><div class="driver-title">Жолооч: ${escapePrintHtml(driverName)} (${driverRows.length})</div>`
        );
        printWindow.document.write(`
          <table>
            <thead>
              <tr>
                <th>Дэлгүүр</th>
                <th>Хаяг</th>
                <th>Утас</th>
                <th>Төлөв</th>
                <th>Үнэ</th>
                <th>Бараа</th>
                <th>Тайлбар</th>
              </tr>
            </thead>
            <tbody>
        `);

        driverRows.forEach((row) => {
          const itemsText =
            row.items && row.items.length > 0
              ? row.items
                  .map((item) => `${item.good?.name || 'Unknown'} (${item.quantity})`)
                  .join(', ')
              : 'Бараа байхгүй';
          const merchantStyle = printMerchantCellStyle(row.status_name?.color);
          const merchantName = escapePrintHtml(String(row.merchant?.username ?? '-'));
          const statusLabel = escapePrintHtml(String(row.status_name?.status ?? '-'));

          printWindow.document.write(`
            <tr>
              <td class="merchant-by-status" style="${merchantStyle}">${merchantName}</td>
              <td>${escapePrintHtml(String(row.address ?? ''))}</td>
              <td>${escapePrintHtml(String(row.phone ?? ''))}</td>
              <td>${statusLabel}</td>
              <td>${row.price?.toLocaleString() ?? '0'}₮</td>
              <td class="items-cell">${escapePrintHtml(itemsText)}</td>
              <td>${escapePrintHtml(String(row.comment ?? '-'))}</td>
            </tr>
          `);
        });

        printWindow.document.write('</tbody></table></div>');
      });

      printWindow.document.write('</body></html>');
      printWindow.document.close();
      printWindow.print();
    } catch (error) {
      console.error('Return print error:', error);
      msg.error('Буцаалт хэвлэхэд алдаа гарлаа');
    } finally {
      setReturnPrintLoading(false);
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
    setFormKhoroos([]);
    setSelectedKhorooId(null);
    setIsRural(false); // Reset rural checkbox when drawer closes
    form.setFieldsValue({ khoroo_id: undefined });
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
    <div className="delivery-admin-page" style={{ paddingBottom: '100px' }}>
      <h1 style={{ marginBottom: 24 }}>Хүргэлт</h1>

      <div className="delivery-admin-filters">
        <Input
          placeholder="Filter by Phone"
          value={phoneFilter}
          onChange={(e) => setPhoneFilter(e.target.value)}
          allowClear
          className="delivery-filter-control"
        />
        {hasPermission('delivery:excel_import_delivery') && (

          <Select
            placeholder="Filter by Driver"
            className="delivery-filter-control"
            value={driverFilter ?? undefined}
            onChange={handleRealDriverFilterChange}
            onDropdownVisibleChange={(open) => {
              if (open) fetchDriver();
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
        <button
          type="button"
          className="delivery-filter-add-btn"
          style={{
            padding: '4px 15px',
            fontSize: 14,
            borderRadius: 6,
            border: 'none',
            background: '#1677ff',
            color: '#fff',
            cursor: 'pointer',
            fontWeight: 400,
            lineHeight: 1.5715,
          }}
          onClick={handleDeliveryButton}
        >
          + Add Delivery
        </button>
        {hasPermission('delivery:excel_import_delivery') && (
          <>
            {/* Add this to your filter section with other filters */}
            <Select
              placeholder="Дүүргээр шүүх"
              className="delivery-filter-control"
              value={districtFilter}
              onChange={handleDistrictFilterChange}
              onDropdownVisibleChange={(open) => {
                if (open) fetchDistricts();
              }}
              allowClear
              showSearch
              optionFilterProp="children"
              loading={districtsLoading}
            >
              {districts.map((district) => (
                <Option key={district.id} value={district.id}>
                  {district.name}
                </Option>
              ))}
            </Select>
            {districtFilter && (
              <Select
                placeholder="Хороогоор шүүх"
                className="delivery-filter-control"
                value={khorooFilter}
                onChange={handleKhorooFilterChange}
                allowClear
                showSearch
                optionFilterProp="children"
                loading={khoroosLoading}
              >
                {khoroos.map((khoroo) => (
                  <Option key={khoroo.id} value={khoroo.id}>
                    {khoroo.name}
                  </Option>
                ))}
              </Select>
            )}
            <Select
              placeholder="Дэлгүүрээр шүүх (users.id)"
              className="delivery-filter-control"
              value={merchantFilter ?? undefined}
              onChange={handleMerchantFilterChange}
              onDropdownVisibleChange={(open) => {
                if (open) void ensureMerchantsForFilter();
              }}
              allowClear
              showSearch
              optionFilterProp="label"
            >
              {merchants.map((m) => (
                <Option key={m.id} value={m.id} label={`${m.username ?? ''} ${m.id}`}>
                  {m.username ?? '—'} (#{m.id})
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

      </div>

      <div className="delivery-admin-table-wrap">
      <Table
        className="delivery-admin-table"
        rowSelection={rowSelection}
        columns={columns}
        dataSource={deliveryData}
        rowKey="id"
        scroll={{ x: 1180 }}
        tableLayout="fixed"
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
        size="small"
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
      </div>
      <Drawer
        title="Хүргэлт үүсгэх"
        placement="right"
        open={isDrawerVisible}
        onClose={handleCloseDrawer}
        width={800}  // wider drawer
        styles={{ body: { padding: '20px' } }}
      >
        <Form form={form} initialValues={{ merchantId: selectedMerchantId }}
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
                showSearch
                optionFilterProp="children"
                filterOption={(input, option) => {
                  const label = String(option?.children ?? '');
                  return label.toLowerCase().includes((input || '').toLowerCase());
                }}
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
            normalize={(v) => normalizeDeliveryPhone(v)}
            rules={[{ required: true, message: 'Please input the phone number!' }]}
          >
            <Input placeholder="99090099 (зайгүй)" inputMode="numeric" />
          </Form.Item>

          <Form.Item
            label="Хаяг"
            name="address"
            rules={[{ required: true, message: 'Please input the address!' }]}
          >
            <GoogleAddressAutocomplete
              onAddressChange={async (address, components) => {
                // Helper function to normalize district names for matching
                const normalizeDistrictName = (name: string) => {
                  return name.toLowerCase().trim()
                    .replace(/\s*дүүрэг\s*/g, '')
                    .replace(/\s*дүүргийн\s*/g, '')
                    .replace(/\s*district\s*/gi, '')
                    .trim();
                };

                // Helper function to match district
                const matchDistrict = (districtText: string) => {
                  if (!districtText || districts.length === 0) return null;

                  const normalizedInput = normalizeDistrictName(districtText);

                  return districts.find(d => {
                    const dbName = d.name.toLowerCase().trim();
                    const normalizedDbName = normalizeDistrictName(dbName);

                    // Try exact match
                    if (normalizedDbName === normalizedInput) return true;
                    // Try contains match (either direction)
                    if (normalizedDbName.includes(normalizedInput) ||
                      normalizedInput.includes(normalizedDbName)) return true;
                    // Try original names
                    if (dbName === districtText.toLowerCase().trim()) return true;
                    return false;
                  });
                };

                // Helper function to extract district from address text
                const extractDistrictFromAddress = (addr: string) => {
                  // Check for БЗД first and map it to Баянзүрх
                  if (/бзд/i.test(addr)) {
                    // Find Баянзүрх district in the districts list
                    const bayanzurkhDistrict = districts.find(d =>
                      normalizeDistrictName(d.name) === 'баянзүрх'
                    );
                    if (bayanzurkhDistrict) {
                      return bayanzurkhDistrict.name;
                    }
                  }

                  // Check for СБД and map it to Сүхбаатар
                  if (/сбд/i.test(addr)) {
                    // Find Сүхбаатар district in the districts list
                    const sukhbaatarDistrict = districts.find(d =>
                      normalizeDistrictName(d.name) === 'сүхбаатар' || normalizeDistrictName(d.name) === 'сухбаатар'
                    );
                    if (sukhbaatarDistrict) {
                      return sukhbaatarDistrict.name;
                    }
                  }

                  // Check for БГД and map it to Баянгол (Баянгол дүүрэг)
                  if (/бгд/i.test(addr)) {
                    const bayangolDistrict = districts.find(d =>
                      normalizeDistrictName(d.name) === 'баянгол' || normalizeDistrictName(d.name) === 'баян-гол'
                    );
                    if (bayangolDistrict) {
                      return bayangolDistrict.name;
                    }
                  }

                  // СХД → Сонгинохайрхан
                  if (/схд/i.test(addr)) {
                    const songinokhairkhanDistrict = districts.find(d =>
                      normalizeDistrictName(d.name).includes('сонгино') && normalizeDistrictName(d.name).includes('хайрхан')
                    );
                    if (songinokhairkhanDistrict) {
                      return songinokhairkhanDistrict.name;
                    }
                  }

                  // ХУД → Хан-Уул
                  if (/худ/i.test(addr)) {
                    const khanuulDistrict = districts.find(d =>
                      normalizeDistrictName(d.name) === 'хан-уул' || normalizeDistrictName(d.name) === 'хануул'
                    );
                    if (khanuulDistrict) {
                      return khanuulDistrict.name;
                    }
                  }

                  // ЧД → Чингэлтэй
                  if (/чд/i.test(addr)) {
                    const chingelteiDistrict = districts.find(d =>
                      normalizeDistrictName(d.name) === 'чингэлтэй' || normalizeDistrictName(d.name) === 'чингэлтей'
                    );
                    if (chingelteiDistrict) {
                      return chingelteiDistrict.name;
                    }
                  }

                  // Common district patterns in Mongolian addresses
                  const districtPatterns = [
                    /(баянзүрх|баян-зүрх|баянзурх)/i,
                    /(хан-уул|хануул)/i,
                    /(баянгол|баян-гол)/i,
                    /(сүхбаатар|сухбаатар)/i,
                    /(сонгинохайрхан|сонгино-хайрхан)/i,
                    /(чингэлтэй|чингэлтей)/i,
                  ];

                  for (const pattern of districtPatterns) {
                    const match = addr.match(pattern);
                    if (match) {
                      return match[1];
                    }
                  }

                  // Try to find district name from districts list
                  for (const district of districts) {
                    const normalizedDistrict = normalizeDistrictName(district.name);
                    if (addr.toLowerCase().includes(normalizedDistrict)) {
                      return district.name;
                    }
                  }

                  return null;
                };

                // Helper function to extract khoroo number from address
                const extractKhorooFromAddress = (addr: string) => {
                  // Patterns like "22 хороо", "БЗД - 22 хороо", "22-р хороо", "СБД - хороо 6", "хороо 6", etc.
                  // Order matters: check district abbreviation patterns first, then number-before patterns, then number-after patterns
                  const khorooPatterns = [
                    // District abbreviation patterns: "СБД - хороо 6", "БЗД - хороо 19", etc.
                    /[а-я]{2,4}\s*-\s*хороо\s*(\d+)/i,  // Matches any district abbreviation (2-4 Cyrillic letters) followed by " - хороо [number]"
                    // District abbreviation with number before: "БЗД - 19 хороо", "СБД - 6 хороо"
                    /[а-я]{2,4}\s*-\s*(\d+)\s*(?:хороо)?/i,  // Matches "БЗД - 19" or "БЗД - 19 хороо" or "СБД - 6"
                    // Number before хороо: "22 хороо", "22-р хороо"
                    /(\d+)\s*-?\s*р\s*хороо/i,  // "22-р хороо"
                    /(\d+)\s*-?\s*хороо/i,  // "22 хороо" or "22-хороо"
                    /(\d+)\s*хор/i,  // "22 хор"
                    // Number after хороо: "хороо 6", "хороо - 6"
                    /хороо\s*-?\s*(\d+)/i,  // Matches "хороо 6" or "хороо - 6"
                  ];

                  for (const pattern of khorooPatterns) {
                    const match = addr.match(pattern);
                    if (match) {
                      return match[1]; // Return the number (without "хороо")
                    }
                  }

                  return null;
                };


                let matchedDistrict = null;
                let matchedKhoroo = null;
                let khorooNumber = null;

                // Step 1: Try to match district from components
                if (components?.district) {
                  matchedDistrict = matchDistrict(components.district);
                }

                // Step 2: If no district from components, try to extract from address text
                if (!matchedDistrict && address) {
                  const extractedDistrict = extractDistrictFromAddress(address);
                  if (extractedDistrict) {
                    matchedDistrict = matchDistrict(extractedDistrict);
                  }
                }

                // Step 3: If district is matched, fetch khoroos and then match khoroo
                if (matchedDistrict) {
                  setIsRural(false); // Uncheck "Орон нутаг" when district is found
                  form.setFieldsValue({ dist_id: matchedDistrict.id });
                  const loadedKhoroos = await fetchKhoroos(matchedDistrict.id, true);

                  // Extract khoroo number from address (just the number, no "хороо")
                  khorooNumber = extractKhorooFromAddress(address);

                  // Update matchKhoroo to use loaded khoroos
                  const matchKhorooWithData = (khorooText: string, khorooNum: string | null, khoroosData: { id: number; name: string }[]) => {
                    if (!khoroosData || khoroosData.length === 0) return null;

                    // First try to match by number if we have it (match only the number part, ignore "хороо")
                    if (khorooNum) {
                      const matchedByNumber = khoroosData.find(k => {
                        const khorooName = k.name.toLowerCase();
                        // Extract just the number from khoroo name (remove "хороо", "р", etc.)
                        const khorooNameNumber = khorooName.replace(/\s*хороо\s*/g, '').replace(/\s*р\s*/g, '').replace(/\s*-\s*/g, '').trim();
                        // Match by exact number or number at word boundary
                        return khorooNameNumber === khorooNum ||
                          khorooName.includes(khorooNum) &&
                          (khorooName.match(new RegExp(`\\b${khorooNum}\\b`)) || khorooNameNumber === khorooNum);
                      });
                      if (matchedByNumber) return matchedByNumber;
                    }

                    // Then try to match by text
                    if (khorooText) {
                      const normalizedKhoroo = khorooText.toLowerCase().trim().replace(/\s*хороо\s*/g, '').trim();
                      return khoroosData.find(k => {
                        const kName = k.name.toLowerCase().replace(/\s*хороо\s*/g, '').trim();
                        return kName.includes(normalizedKhoroo) ||
                          normalizedKhoroo.includes(kName);
                      });
                    }

                    return null;
                  };

                  // Try to match khoroo from components
                  if (components?.khoroo) {
                    matchedKhoroo = matchKhorooWithData(components.khoroo, khorooNumber, loadedKhoroos);
                  }

                  // If no khoroo from components, try to match from address text
                  if (!matchedKhoroo && khorooNumber) {
                    matchedKhoroo = matchKhorooWithData('', khorooNumber, loadedKhoroos);
                  }

                  // Also try matching any khoroo text from address (fallback pattern matching)
                  if (!matchedKhoroo && address) {
                    // Try to extract khoroo number using the same patterns as extractKhorooFromAddress
                    const fallbackPatterns = [
                      /[а-я]{2,4}\s*-\s*хороо\s*(\d+)/i,
                      /[а-я]{2,4}\s*-\s*(\d+)\s*(?:хороо)?/i,
                      /(\d+)\s*-?\s*р\s*хороо/i,
                      /(\d+)\s*-?\s*хороо/i,
                      /(\d+)\s*хор/i,
                      /хороо\s*-?\s*(\d+)/i,
                    ];

                    for (const pattern of fallbackPatterns) {
                      const khorooMatch = address.match(pattern);
                      if (khorooMatch) {
                        const extractedNum = khorooMatch[1];
                        matchedKhoroo = matchKhorooWithData('', extractedNum, loadedKhoroos);
                        if (matchedKhoroo) break;
                      }
                    }
                  }

                  if (matchedKhoroo) {
                    form.setFieldsValue({ khoroo_id: matchedKhoroo.id });
                    setSelectedKhorooId(matchedKhoroo.id);
                  } else if (khorooNumber && matchedDistrict) {
                    // If khoroo number was extracted but not found in DB, create it
                    const khorooName = khorooNumber;
                    const newKhoroo = await createKhoroo(matchedDistrict.id, khorooName);
                    if (newKhoroo) {
                      // Refresh khoroos list and set the newly created khoroo
                      const updatedKhoroos = await fetchKhoroos(matchedDistrict.id, true);
                      const foundKhoroo = updatedKhoroos.find(k => k.id === newKhoroo.id);
                      if (foundKhoroo) {
                        form.setFieldsValue({ khoroo_id: foundKhoroo.id });
                        setSelectedKhorooId(foundKhoroo.id);
                      }
                    } else {
                      // If creation failed, clear khoroo
                      form.setFieldsValue({ khoroo_id: undefined });
                      setSelectedKhorooId(null);
                    }
                  } else {
                    // Clear khoroo if no match found and no number extracted
                    form.setFieldsValue({ khoroo_id: undefined });
                    setSelectedKhorooId(null);
                  }
                } else {
                  // If no district info from Google, check "Орон нутаг" and leave dist/khoroo empty
                  setIsRural(true);
                  form.setFieldsValue({ dist_id: undefined });
                  form.setFieldsValue({ khoroo_id: undefined });
                  setSelectedKhorooId(null);
                  setFormKhoroos([]);
                  // Log for debugging if district not found
                  console.log('District not matched:', {
                    address,
                    googleDistrict: components?.district,
                    availableDistricts: districts.map(d => d.name)
                  });
                }
              }}
              placeholder="Хаяг оруулж захиалга эхлүүлэх. Жич: Та сайтар шалгаж зөв хаяг оруулна уу"
            />
          </Form.Item>

          <Form.Item
            label="Дүүрэг"
            name="dist_id"
            rules={[{ required: true, message: 'Дүүрэг сонгоно уу!' }]}
          >
            <Select
              placeholder="Дүүрэг сонгох"
              onDropdownVisibleChange={(open) => {
                if (open) fetchDistricts();
              }}
              onChange={(value) => {
                // Explicitly set the form value to ensure it's set
                form.setFieldsValue({ dist_id: value });
                setSelectedKhorooId(null);
                setFormKhoroos([]);
                form.setFieldsValue({ khoroo_id: undefined });
                if (value) {
                  setIsRural(false); // Uncheck "Орон нутаг" when district is manually selected
                  fetchKhoroos(value, true);
                } else {
                  setIsRural(true); // Check "Орон нутаг" when district is cleared
                }
              }}
              showSearch
              optionFilterProp="children"
              loading={districtsLoading}
            >
              {districts.map((district) => (
                <Select.Option key={district.id} value={district.id}>
                  {district.name}
                </Select.Option>
              ))}
            </Select>
          </Form.Item>

          <Form.Item
            label="Хороо"
            name="khoroo_id"
          >
            <Select
              placeholder="Хороо сонгох (сонголттой)"
              value={selectedKhorooId}
              onChange={(value) => {
                setSelectedKhorooId(value);
              }}
              disabled={!form.getFieldValue('dist_id')}
              showSearch
              optionFilterProp="children"
              loading={formKhoroosLoading}
              allowClear
            >
              {formKhoroos.map((khoroo) => (
                <Select.Option key={khoroo.id} value={khoroo.id}>
                  {khoroo.name}
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
              {/* Row 1: Product Selection */}
              <Row gutter={8} style={{ marginBottom: 10 }}>
                <Col span={24}>
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
              </Row>

              {/* Row 2: Quantity, Price, and Add Button */}
              <Row gutter={8} style={{ marginBottom: 10 }}>
                <Col span={10}>
                  <InputNumber
                    min={1}
                    value={quantity}
                    onChange={value => setQuantity(value || 1)}
                    style={{ width: '100%' }}
                    placeholder="Тоо ширхэг"
                  />
                </Col>

                <Col span={10}>
                  <InputNumber
                    min={0}
                    value={productPrice}
                    onChange={value => setProductPrice(value || 0)}
                    style={{ width: '100%' }}
                    placeholder="Нэгж үнэ"
                    formatter={value => {
                      if (value == null) return '';
                      const num = typeof value === 'number' ? value : Number(String(value).replace(/[^\d.-]/g, ''));
                      if (Number.isNaN(num)) return String(value);
                      return `${num.toLocaleString('en-US')} ₮`;
                    }}
                    parser={value => {
                      if (!value) return 0;
                      const numericString = String(value).replace(/₮\s?|[\s,]/g, '');
                      return Number(numericString) || 0;
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


        <div className="delivery-admin-actions">
          <Space wrap>
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
              type="default"
              onClick={openDeliveryPriceModal}
              disabled={selectedRowKeys.length === 0}
            >
              Үнийн тохиргоо оноох
            </Button>
            <Button type="default" loading={returnPrintLoading} onClick={handlePrintReturns}>
              Буцаалт хэвлэх
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
            td.merchant-by-status {
              font-weight: 600;
              background-color: transparent !important;
              -webkit-print-color-adjust: exact;
              print-color-adjust: exact;
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

                    /** Дэлгүүрийн нэрийг төлөвийн өнгөөр текстээр — эсгүүний дэвсгэр өнгөгүй (хэвлэхэд илүү тод). */
                    const printMerchantCellStyle = (color: string | undefined): string => {
                      if (!color || typeof color !== 'string') {
                        return 'color: #111; background-color: transparent;';
                      }
                      const c = color.trim();
                      if (!/^#[0-9A-Fa-f]{3,8}$/.test(c) && !/^[a-zA-Z]+$/.test(c)) {
                        return 'color: #111; background-color: transparent;';
                      }
                      return `color: ${c}; background-color: transparent;`;
                    };

                    rowsWithItems.forEach(row => {
                      // Format dates
                      const createdAt = row.createdAt ? dayjs(row.createdAt).format('YYYY-MM-DD HH:mm') : '-';

                      // Format items as "Item1 (2), Item2 (1), ..."
                      const itemsText = row.items && row.items.length > 0
                        ? row.items.map(item =>
                          `${item.good?.name || 'Unknown'} (${item.quantity})`
                        ).join(', ')
                        : 'Бараа байхгүй';

                      const merchantStyle = printMerchantCellStyle(row.status_name?.color);
                      const merchantName = String(row.merchant?.username ?? '-')
                        .replace(/&/g, '&amp;')
                        .replace(/</g, '&lt;')
                        .replace(/>/g, '&gt;');

                      printWindow.document.write(`
            <tr>
              <td class="merchant-by-status" style="${merchantStyle}">${merchantName}</td>
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
                  msg.error('Failed to load items for printing');
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
        open={isModalVisible}
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
        open={isStatusModal}
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
        title="Үнийн тохиргоо оноох"
        open={isDeliveryPriceModal}
        onCancel={() => setIsDeliveryPriceModal(false)}
        onOk={handleBulkDeliveryPriceSave}
        okText="Хадгалах"
        cancelText="Болих"
        confirmLoading={deliveryPriceSubmitting}
      >
        <div style={{ marginBottom: 8 }}>
          Сонгосон {selectedRowKeys.length} хүргэлтэд тайланд ашиглах үнийн тохиргоо (дэлгүүр / жолооч).
        </div>
        <Select
          style={{ width: '100%' }}
          placeholder="Тохиргоо сонгох"
          value={selectedPriceSettingId ?? undefined}
          onChange={(v) => setSelectedPriceSettingId(v)}
          options={priceSettings.map((p) => ({
            value: p.id,
            label: p.label
              ? `${p.label} — дэлгүүр ${Number(p.merchant_price).toLocaleString()}₮, жолооч ${Number(p.driver_price).toLocaleString()}₮`
              : `Дэлгүүр ${Number(p.merchant_price).toLocaleString()}₮ / Жолооч ${Number(p.driver_price).toLocaleString()}₮`,
          }))}
        />
      </Modal>

      <Modal
        title="VIEW IMAGE"
        open={deliveryImageModalOpen}
        onCancel={() => setDeliveryImageModalOpen(false)}
        footer={[
          <Button key="close" onClick={() => setDeliveryImageModalOpen(false)}>
            Close
          </Button>,
        ]}
        width={720}
        destroyOnClose
      >
        {deliveryImageUrl ? (
          <Image
            src={deliveryImageUrl}
            alt="Delivery proof"
            style={{ maxWidth: '100%' }}
            preview
          />
        ) : (
          <p>Зураг байхгүй</p>
        )}
      </Modal>

      <Modal
        title="Delivery History"
        open={isHistoryModal}
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
        title="Edit Delivery"
        open={isEditModal}
        onOk={handleEdit}
        onCancel={handleEditModalCancel}
        okText="Save"
        cancelText="Cancel"
        width={600}
      >
        <Form form={form} layout="vertical">
          <Form.Item
            name="phone"
            label="Phone"
            normalize={(v) => normalizeDeliveryPhone(v)}
            rules={[{ required: true, message: 'Please enter phone number' }]}
          >
            <Input inputMode="numeric" />
          </Form.Item>
          <Form.Item name="address" label="Address" rules={[{ required: true, message: 'Please enter address' }]}>
            <Input />
          </Form.Item>
          <Form.Item name="price" label="Price" rules={[{ required: true, message: 'Please enter Price' }]}>
            <InputNumber style={{ width: '100%' }} min={0} />
          </Form.Item>
          <Form.Item name="comment" label="Comment" rules={[{ required: true, message: 'Please enter comment' }]}>
            <Input.TextArea rows={3} />
          </Form.Item>

          {editModalLoading ? (
            <div style={{ textAlign: 'center', padding: '20px' }}>Loading items...</div>
          ) : editModalItems.length > 0 ? (
            <div>
              <div style={{ marginBottom: 8, fontWeight: 500 }}>Items:</div>
              <List
                bordered
                size="small"
                dataSource={editModalItems}
                renderItem={(item) => (
                  <List.Item
                    actions={[
                      <InputNumber
                        key="quantity"
                        min={1}
                        value={item.quantity}
                        onChange={(value) => handleEditItemQuantity(item.id, value || 1)}
                        style={{ width: 80 }}
                      />,
                      <Button
                        key="delete"
                        danger
                        size="small"
                        icon={<DeleteOutlined />}
                        onClick={() => handleDeleteEditItem(item.id)}
                      />
                    ]}
                  >
                    <div>
                      <strong>{item.good?.name || `Item #${item.good_id}`}</strong>
                      <div style={{ fontSize: '12px', color: '#666' }}>
                        Quantity: {item.quantity}
                      </div>
                    </div>
                  </List.Item>
                )}
              />
            </div>
          ) : null}
        </Form>
      </Modal>
    </div>
  );
}