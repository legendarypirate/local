import { ConfigProvider, App } from 'antd';
import React from 'react';
import './globals.css'; // ✅ Import your reset

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <ConfigProvider>
          <App>
            {children}
          </App>
        </ConfigProvider>
      </body>
    </html>
  );
}
