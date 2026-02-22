'use client';

import React, { useState, useTransition, useEffect } from 'react';
import { Layout, Menu, message, Spin, Modal, Dropdown, Avatar, MenuProps } from 'antd';
import {
  DashboardOutlined, UserOutlined, SettingOutlined, TruckOutlined, ShoppingCartOutlined,
  AppstoreAddOutlined, BellOutlined, HomeOutlined, FileTextOutlined, KeyOutlined,
  LogoutOutlined, BarChartOutlined, ShoppingOutlined
} from '@ant-design/icons';
import { usePathname, useRouter } from 'next/navigation';

const { Header, Sider, Content } = Layout;

interface MenuItemType {
  key: string;
  icon: React.ReactNode;
  label: React.ReactNode;
  permission?: string;
  children?: MenuItemType[];
}

/* ------------------------ USER HELPERS ------------------------ */

function getUserPermissions(): string[] {
  try {
    const userStr = localStorage.getItem('user');
    if (!userStr) return [];
    const user = JSON.parse(userStr);
    return user.permissions || [];
  } catch (e) {
    console.error('Failed to parse user from localStorage', e);
    return [];
  }
}

function getUserName(): string {
  try {
    const userStr = localStorage.getItem('user');
    if (!userStr) return 'Хэрэглэгч';
    const user = JSON.parse(userStr);
    return user.name || 'Хэрэглэгч';
  } catch {
    return 'Хэрэглэгч';
  }
}

function getUserRole(): number | null {
  try {
    const userStr = localStorage.getItem('user');
    if (!userStr) return null;
    const user = JSON.parse(userStr);
    return user.role ?? null;
  } catch {
    return null;
  }
}

/* ------------------------ PERMISSION HELPERS ------------------------ */

function hasPermission(permission: string, userPermissions: string[]): boolean {
  if (!permission) return true;
  return userPermissions.includes(permission);
}

function filterMenuByPermission(items: MenuItemType[], userPermissions: string[]): MenuItemType[] {
  return items
    .filter(item => hasPermission(item.permission || '', userPermissions))
    .map(item => {
      if (item.children) {
        return { ...item, children: filterMenuByPermission(item.children, userPermissions) };
      }
      return item;
    });
}

// Check if current route path is allowed for user (role 2 = merchant can access /admin/report)
function hasAccessToPath(pathname: string, menuItems: MenuItemType[], userPermissions: string[], userRole: number | null): boolean {
  if (userRole === 2 && pathname === '/admin/report') return true;
  for (const item of menuItems) {
    if (item.key === pathname) {
      if (!item.permission) return true;
      return userPermissions.includes(item.permission);
    }
    if (item.children && hasAccessToPath(pathname, item.children, userPermissions, userRole)) {
      return true;
    }
  }
  return false;
}

/* ------------------------ MAIN LAYOUT COMPONENT ------------------------ */

export default function AdminLayout({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const [loading, setLoading] = useState(false);
  const [isPending, startTransition] = useTransition();
  const [userPermissions, setUserPermissions] = useState<string[] | null>(null);
  const [userName, setUserName] = useState<string>('Хэрэглэгч');
  const [userRole, setUserRole] = useState<number | null>(null);
  const [userDropdownOpen, setUserDropdownOpen] = useState(false);

  useEffect(() => {
    const permissions = getUserPermissions();
    setUserPermissions(permissions);
    setUserName(getUserName());
    setUserRole(getUserRole());
  }, []);

  /* ------------------------ MENU CONFIG ------------------------ */
  const menuItems: MenuItemType[] = [
    { key: '/admin', icon: <DashboardOutlined />, label: 'Хянах самбар', permission: 'dashboard:view_dashboard' },
    { key: '/admin/delivery', icon: <TruckOutlined />, label: 'Хүргэлт', permission: 'delivery:view_delivery' },
    { key: '/admin/order', icon: <ShoppingCartOutlined />, label: 'Татан авалт', permission: 'order:view_order' },
    { key: '/admin/region', icon: <AppstoreAddOutlined />, label: 'Бүс', permission: 'region:view_region' },
    { key: '/admin/notification', icon: <BellOutlined />, label: 'Масс мэдэгдэл', permission: 'notification:view_notification' },
    {
      key: 'good',
      icon: <FileTextOutlined />,
      label: 'Агуулахын бараа',
      permission: 'good:view_good',
      children: [
        { key: '/admin/good', icon: <ShoppingOutlined />, label: 'Барааны жагсаалт', permission: 'good:view_good' },
        { key: '/admin/good-request', icon: <FileTextOutlined />, label: 'Барааны хүсэлт', permission: 'good:view_good' },
      ],
    },
    {
      key: 'report',
      icon: <FileTextOutlined />,
      label: 'Тайлан',
      permission: 'reports:view_reports',
      children: [
        { key: '/admin/report', icon: <FileTextOutlined />, label: 'Тайлан', permission: 'log:view_log' },
        { key: '/admin/summary', icon: <BarChartOutlined />, label: 'Тайлан жагсаалт', permission: 'reports:view_reports' },
        { key: '/admin/driver-tootsoo', icon: <BarChartOutlined />, label: 'Жолоочийн тооцоо', permission: 'log:view_log' },

      ],
    },
    { key: '/admin/log', icon: <FileTextOutlined />, label: 'Үйлдлийн лог', permission: 'log:view_log' },
    {
      key: 'user',
      icon: <FileTextOutlined />,
      label: 'Хэрэглэгч',
      permission: 'log:view_log',
      children: [
        { key: '/admin/user', icon: <UserOutlined />, label: 'Харилцагч нар', permission: 'log:view_log' },
        { key: '/admin/request', icon: <FileTextOutlined />, label: 'Жолооч', permission: 'log:view_log' },
      ],
    },
    {
      key: 'settings',
      icon: <SettingOutlined />,
      label: 'Тохиргоо',
      permission: 'settings:view_settings',
      children: [
        { key: '/admin/status', label: 'Хүргэлтийн төлөвүүд', icon: <UserOutlined />, permission: 'status:view_status' },
        { key: '/admin/role', label: 'Эрхийн зохицуулалт', icon: <KeyOutlined />, permission: 'role:view_role' },
        { key: '/admin/warehouse', label: 'Агуулах бүртгэх', icon: <HomeOutlined />, permission: 'warehouse:view_warehouse' },
      ],
    },
  ];

  let filteredMenuItems = userPermissions ? filterMenuByPermission(menuItems, userPermissions) : [];
  if (userRole === 2) {
    const hasReport = filteredMenuItems.some((m) => m.key === 'report' || m.key === '/admin/report');
    if (!hasReport) {
      filteredMenuItems = [
        ...filteredMenuItems,
        {
          key: 'report',
          icon: <FileTextOutlined />,
          label: 'Тайлан',
          permission: undefined,
          children: [{ key: '/admin/report', icon: <FileTextOutlined />, label: 'Тайлан', permission: undefined }],
        } as MenuItemType,
      ];
    } else {
      filteredMenuItems = filteredMenuItems.map((m) => {
        if (m.key === 'report' && m.children && !m.children.some((c) => c.key === '/admin/report')) {
          return { ...m, children: [...m.children, { key: '/admin/report', icon: <FileTextOutlined />, label: 'Тайлан', permission: undefined } as MenuItemType] };
        }
        return m;
      });
    }
    // Customer (role 2): show only "Тайлан" (/admin/report), hide "Тайлан жагсаалт" (/admin/summary)
    filteredMenuItems = filteredMenuItems.map((m) => {
      if (m.key === 'report' && m.children) {
        return { ...m, children: m.children.filter((c) => c.key !== '/admin/summary') };
      }
      return m;
    });
  }

  /* ------------------------ ROUTE ACCESS CONTROL ------------------------ */
  useEffect(() => {
    // If permissions not loaded yet, skip
    if (userPermissions === null) return;

    // Block unauthenticated users
    if (userPermissions.length === 0 && pathname.startsWith('/admin')) {
      message.error('Та эхлээд нэвтэрнэ үү!');
      router.push('/login');
      return;
    }

    const allowed = hasAccessToPath(pathname, menuItems, userPermissions, userRole);
    if (pathname.startsWith('/admin') && !allowed) {
      message.error('Танд энэ хуудас руу хандах эрх байхгүй!');
      router.push('/admin');
    }
  }, [pathname, userPermissions, userRole]);

  /* ------------------------ LOGOUT HANDLER ------------------------ */
  const handleLogout = () => {
    localStorage.removeItem('user');
    localStorage.removeItem('token');
    localStorage.removeItem('username');
    message.success('Амжилттай гарлаа');
    window.location.href = '/';
  };

  const showLogoutConfirm = () => {
    Modal.confirm({
      title: 'Та гарахдаа итгэлтэй байна уу?',
      okText: 'Тийм',
      cancelText: 'Үгүй',
      centered: true,
      width: 500,
      onOk: handleLogout,
    });
  };

  const onLogoutClick = () => {
    setUserDropdownOpen(false);
    // Show modal after dropdown has closed so it is not unmounted with the dropdown
    setTimeout(() => showLogoutConfirm(), 0);
  };

  const userDropdownContent = (
    <div style={{ minWidth: 200, padding: '4px 0' }}>
      <div style={{ padding: '8px 12px', color: 'rgba(0,0,0,0.65)', cursor: 'default' }}>
        Таны нэр: {userName}
      </div>
      <div style={{ borderTop: '1px solid #f0f0f0', margin: '4px 0' }} />
      <button
        type="button"
        onClick={onLogoutClick}
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: 8,
          width: '100%',
          padding: '8px 12px',
          border: 'none',
          background: 'none',
          cursor: 'pointer',
          color: '#ff4d4f',
          fontSize: 14,
        }}
      >
        <LogoutOutlined /> Гарах
      </button>
    </div>
  );

  const handleMenuClick: MenuProps['onClick'] = (e) => {
    setLoading(true);
    router.push(e.key);
    setTimeout(() => setLoading(false), 500);
  };

  /* ------------------------ RENDER ------------------------ */
  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Sider breakpoint="lg" collapsedWidth="0">
        <div className="logo" style={{ color: 'white', padding: '16px', textAlign: 'center' }}>
          Local Express
        </div>
        <Menu
          theme="dark"
          mode="inline"
          selectedKeys={[pathname]}
          onClick={handleMenuClick}
          items={filteredMenuItems}
        />
      </Sider>

      <Layout>
        <Header
          style={{
            background: '#fff',
            padding: '0 24px',
            display: 'flex',
            justifyContent: 'flex-end',
            alignItems: 'center',
          }}
        >
          <Dropdown
            open={userDropdownOpen}
            onOpenChange={setUserDropdownOpen}
            dropdownRender={() => userDropdownContent}
            trigger={['click']}
            placement="bottomRight"
            arrow
          >
            <Avatar
              size="large"
              style={{ cursor: 'pointer', backgroundColor: '#1890ff' }}
              icon={<UserOutlined />}
            />
          </Dropdown>
        </Header>

        <Content style={{ margin: '24px 16px 0' }}>
          <Spin spinning={loading || isPending} tip="Ачааллаж байна..." size="large">
            <div style={{ padding: 24, background: '#fff', minHeight: 360 }}>
              {children}
            </div>
          </Spin>
        </Content>
      </Layout>
    </Layout>
  );
}
