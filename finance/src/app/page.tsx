'use client';
import { Button,Form, Input ,notification,Spin } from 'antd';
import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { CloseOutlined , IdcardOutlined,
  EnvironmentOutlined,
  PhoneOutlined,
  InfoCircleOutlined,
  ClockCircleOutlined,
  CheckCircleOutlined,} from '@ant-design/icons';
import {
  ShoppingCart,
  Truck,
  CheckCircle,
  Facebook,
  Instagram,
  Twitter,
  Smartphone,
} from 'lucide-react';
import Image from 'next/image';

const center = {
  lat: 47.918873,
  lng: 106.917701,
};

export default function Home() {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const openNotification = (type: 'success' | 'error', messageText: string) => {
    notification.open({
      message: null,
      description: <div style={{ color: 'white' }}>{messageText}</div>,
      duration: 4,
      style: {
        backgroundColor: type === 'success' ? '#52c41a' : '#ff4d4f',
        borderRadius: '4px',
      },
      closeIcon: <CloseOutlined style={{ color: '#fff' }} />,
    });
  };
  const handleLogin = async () => {
    if (!username || !password) {
      openNotification('error', 'Нэвтрэх нэр болон нууц үгээ оруулна уу!');
      return;
    }
  
    setLoading(true);
  
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password }),
      });
  
      const data = await res.json();
  
      if (res.ok && data.success) {
        openNotification('success', 'Амжилттай нэвтрэлээ!');
  
        // Store all relevant info
        const { token, user } = data;
        localStorage.setItem('token', token);
        localStorage.setItem('user', JSON.stringify(user));
        localStorage.setItem('permissions', JSON.stringify(user.permissions));
        localStorage.setItem('role', user.role?.toString() ?? '');
        localStorage.setItem('username', user.username);
  
        router.push('/admin');
      } else {
        openNotification('error', data.message || 'Нэвтрэх нэр эсвэл нууц үг буруу байна!');
      }
    } catch (error) {
      console.error(error);
      openNotification('error', 'Сервертэй холбогдож чадсангүй!');
    } finally {
      setLoading(false);
    }
  };
  
  return (
    <main className="min-h-screen bg-white text-gray-800">
      {/* Hero Section */}
      <section
      className="relative bg-cover bg-center py-20 px-6 min-h-[500px] flex items-center"
      style={{ backgroundImage: "url('bg.avif')" }}
    >
      {/* Overlay for better contrast */}
      <div className="absolute inset-0 bg-black opacity-50"></div>

      {/* Content container */}
      <div className="relative max-w-7xl mx-auto w-full flex flex-col md:flex-row items-center text-white">
        {/* Left side - Text */}
        <div className="md:w-1/2 px-6 md:px-12">
          <h1 className="text-4xl md:text-6xl font-bold mb-6">
            Хүргэлтийн Үйлчилгээг Хялбаршуулсан
          </h1>
          <p className="text-lg md:text-2xl mb-8">
            Таны захиалгыг аюулгүй, хурдан хүргэж өгнө
          </p>
        </div>

        {/* Right side - Login Form */}
        <div className="md:w-1/2 bg-white rounded-lg p-10 shadow-lg text-gray-800 max-w-md w-full">
          <h2 className="text-2xl font-semibold mb-6 text-center text-blue-700">Нэвтрэх</h2>
          <Form
            name="login"
            layout="vertical"
            initialValues={{ remember: true }}
            onFinish={(values) => {
              console.log('Login form values:', values);
              // handle login here
            }}
          >
            <input
      type="text"
      placeholder="Нэвтрэх нэр"
      className="w-full mb-4 px-4 py-3 text-gray-700 placeholder-gray-500 border border-gray-300 rounded-lg"
      value={username}
      onChange={(e) => setUsername(e.target.value)}
    />
    <input
      type="password"
      placeholder="Нууц үг"
      className="w-full mb-6 px-4 py-3 text-gray-700 placeholder-gray-500 border border-gray-300 rounded-lg"
      value={password}
      onChange={(e) => setPassword(e.target.value)}
    />

            <Form.Item>
            <button
      onClick={handleLogin}
      disabled={loading}
      className={`w-full bg-[#082c5c] text-white py-3 rounded-lg font-semibold hover:bg-[#061f40] transition ${
        loading ? 'opacity-50 cursor-not-allowed' : ''
      }`}
    >
      {loading ? <Spin size="small" /> : 'Нэвтрэх'}
    </button>
            </Form.Item>
          </Form>
        </div>
      </div>
    </section>
      {/* How We Work */}
      <section className="py-20 px-6 max-w-6xl mx-auto text-center">
        <h2 className="text-3xl font-bold mb-12">Бид хэрхэн ажилладаг вэ?</h2>
        <div className="grid md:grid-cols-3 gap-10">
          <div className="p-6 border rounded-xl shadow-sm">
            <ShoppingCart size={48} className="mx-auto mb-4 text-blue-600" />
            <h3 className="text-xl font-semibold mb-2">1. Захиалга өгөх</h3>
            <p>Та апп-аар эсвэл вэб сайтаар дамжуулан захиалга өгнө.</p>
          </div>
          <div className="p-6 border rounded-xl shadow-sm">
            <Truck size={48} className="mx-auto mb-4 text-blue-600" />
            <h3 className="text-xl font-semibold mb-2">2. Хүргэлт хийх</h3>
            <p>Манай жолооч нар таны барааг түргэн шуурхай хүргэнэ.</p>
          </div>
          <div className="p-6 border rounded-xl shadow-sm">
            <CheckCircle size={48} className="mx-auto mb-4 text-blue-600" />
            <h3 className="text-xl font-semibold mb-2">3. Амжилттай хүргэлт</h3>
            <p>Харилцагч таныг баталгаажуулж, хүргэлт дуусна.</p>
          </div>
        </div>
      </section>

      {/* Delivery Map Section */}
      <section className="bg-gray-50 py-20 px-6">
        <div className="max-w-6xl mx-auto text-center">
          <h2 className="text-3xl font-bold mb-6">Хүргэлтийн Бүсчлэл</h2>
          <div className="w-full h-auto rounded-lg overflow-hidden border">
            <Image
              src="/bus.webp"
              alt="Хүргэлтийн бүсийн зураг"
              width={1000}
              height={400}
              className="mx-auto rounded-md"
            />
          </div>
          <p className="mt-4 text-lg text-gray-600">Бид Улаанбаатар хотын бүх дүүрэгт хүргэлт хийдэг.</p>
        </div>
      </section>

      {/* App Download Section */}
      <section className="bg-blue-100 py-20 px-6 text-center">
  <h2 className="text-3xl font-bold mb-6">Апп-аа татаж аваарай</h2>
  <p className="mb-6 text-lg">Манай мобайл апп-аар захиалга өгөх бүр хялбар!</p>
  <div className="flex justify-center gap-4 flex-wrap">
    <a href="https://apps.apple.com/app/idXXXXXXXXXX" target="_blank" rel="noopener noreferrer">
      <img
        src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg"
        alt="App Store-с татах"
        style={{ height: '60px' }}
      />
    </a>
    <a href="https://play.google.com/store/apps/details?id=com.example.app" target="_blank" rel="noopener noreferrer">
      <img
        src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg"
        alt="Google Play-с татах"
        style={{ height: '60px' }}
      />
    </a>
  </div>
</section>

      {/* Footer */}
      <footer className="bg-gray-800 text-white py-10 px-6">
        <div className="max-w-6xl mx-auto grid md:grid-cols-3 gap-6">
          <div>
            <h4 className="text-xl font-semibold mb-2">LocalExpress</h4>
            <p>Хүргэлтийн ухаалаг шийдэл бүхий стартап компани.</p>
          </div>
          <div>
            <h4 className="text-xl font-semibold mb-2">Холбоо барих</h4>
            <p>Утас: 9009-5797</p>
            <p>Email: info@localexpress.mn</p>
          </div>
          <div>
            <h4 className="text-xl font-semibold mb-2">Сошиал</h4>
            <div className="flex gap-4">
              <a href="#"><Facebook size={20} /></a>
              <a href="#"><Instagram size={20} /></a>
              <a href="#"><Twitter size={20} /></a>
            </div>
          </div>
        </div>
        <p className="text-center text-gray-400 mt-10">
          © {new Date().getFullYear()} localexpress.mn. Бүх эрх хуулиар хамгаалагдсан.
        </p>
      </footer>
    </main>
  );
}
