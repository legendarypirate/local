'use client';

import { Suspense } from 'react';
import dynamic from 'next/dynamic';
import { Spin } from 'antd';

// Heavy client-side component
const DeliveryClient = dynamic(
  () => import('./DeliveryClient'),
  {
    ssr: false,
    loading: () => (
      <div style={{ 
        display: 'flex', 
        justifyContent: 'center', 
        alignItems: 'center', 
        height: '60vh' 
      }}>
        <Spin size="large" />
      </div>
    ),
  }
);

export default function DeliveryPage() {
  return (
    <Suspense
      fallback={
        <div style={{ 
          display: 'flex', 
          justifyContent: 'center', 
          alignItems: 'center', 
          height: '60vh' 
        }}>
          <Spin size="large" />
        </div>
      }
    >
      <DeliveryClient />
    </Suspense>
  );
}
