'use client';

import React, { useEffect, useState } from 'react';
import { Card, Col, Row, Spin, message } from 'antd';
import { useRouter } from 'next/navigation';

type Status = {
  id: number;
  status: string;
  color: string | null;
};

const Dashboard = () => {
  const router = useRouter();

  const [statuses, setStatuses] = useState<Status[]>([]);
  const [counts, setCounts] = useState<Record<number, number>>({});
  const [loading, setLoading] = useState(true);
  const [merchantId, setMerchantId] = useState<number | null>(null);

  const fetchStatusesAndCounts = async (merchant_id: number | null) => {
    try {
      const statusRes = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/status`);
      const statusJson = await statusRes.json();
      const statusList: Status[] = statusJson.data;

      let countUrl = `${process.env.NEXT_PUBLIC_API_URL}/api/delivery/delivery-status-counts`;
      if (merchant_id) {
        countUrl += `?merchant_id=${merchant_id}`;
      }

      const countRes = await fetch(countUrl);
      const countJson = await countRes.json();
      const countData: Record<number, number> = countJson.data || {};

      setStatuses(statusList);
      setCounts(countData);
    } catch (error) {
      console.error('Error fetching data:', error);
      message.error('Алдаа гарлаа');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const userData = typeof window !== 'undefined' ? localStorage.getItem('user') : null;
    const parsedUser = userData ? JSON.parse(userData) : null;
    const merchant_id = parsedUser?.role === 2 ? parsedUser.id : null;
    setMerchantId(merchant_id);

    fetchStatusesAndCounts(merchant_id);
  }, []);

  return (
    <div style={{ padding: 24 }}>
      <h1 style={{ marginBottom: 24 }}>Хүргэлтийн төлөвийн хяналтын самбар</h1>

      {loading ? (
        <Spin size="large" />
      ) : (
        <Row gutter={[16, 16]}>
          {statuses.map((status) => {
            const borderColor = status.color || '#1890ff';
            return (
              <Col key={status.id} xs={24} sm={12} md={12} lg={6}>
                <Card
                  hoverable
                  title={status.status}
                  bordered
                  onClick={() =>
                    router.push(`/admin/delivery?status_ids=${status.id}`)
                  }
                  style={{
                    cursor: 'pointer',
                    textAlign: 'center',
                    borderLeft: `5px solid ${borderColor}`,
                    borderRadius: 12,
                    boxShadow: '0 2px 8px rgba(0,0,0,.06)',
                  }}
                  headStyle={{
                    background: '#f5f5f5',
                    fontWeight: 600,
                    fontSize: 16,
                  }}
                >
                  <div style={{ fontSize: 36, fontWeight: 'bold', color: borderColor }}>
                    {counts[status.id] || 0}
                  </div>
                </Card>
              </Col>
            );
          })}
        </Row>
      )}
    </div>
  );
};

export default Dashboard;


//tulbur tulugdsun esehiig jagsaaltad yalgah, anh uusgehed tulbur tulsun gej checkleed uusgeh, oron nutgiih gej neg uusgeh, oron nutgiinh bol hurgesen darah ued utas, mashinii nomer bicheed hadgalana, ugui bol hurgegdku , joloochiin tailan dr nogoortson bol -3999 g zuer 0 blgah, 
//hariltsagch report harah hesgiig zasah
