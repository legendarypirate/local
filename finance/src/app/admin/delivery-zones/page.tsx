'use client';

import React, { useEffect, useState, useRef, useCallback } from 'react';
import { Card, Button, Select, List, message, Modal, Form, Input, App } from 'antd';
import { DeleteOutlined, PlusOutlined } from '@ant-design/icons';

const API_KEY = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY || '';
const DEFAULT_CENTER = { lat: 47.9192, lng: 106.9176 }; // Ulaanbaatar

interface Driver {
  id: number;
  username: string;
}

interface DeliveryZone {
  id: number;
  name: string;
  driver_id: number;
  coordinates: { lat: number; lng: number }[];
  driver?: { id: number; username: string };
}

declare global {
  interface Window {
    google: typeof google;
    initDeliveryZonesMap: () => void;
  }
}

export default function DeliveryZonesPage() {
  const { message: msg } = App.useApp();
  const mapRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<google.maps.Map | null>(null);
  const drawingManagerRef = useRef<google.maps.drawing.DrawingManager | null>(null);
  const polygonsRef = useRef<google.maps.Polygon[]>([]);

  const [zones, setZones] = useState<DeliveryZone[]>([]);
  const [drivers, setDrivers] = useState<Driver[]>([]);
  const [loading, setLoading] = useState(true);
  const [saveModalOpen, setSaveModalOpen] = useState(false);
  const [pendingPath, setPendingPath] = useState<{ lat: number; lng: number }[]>([]);
  const [form] = Form.useForm();
  const [saving, setSaving] = useState(false);

  const fetchZones = useCallback(async () => {
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery-zone`);
      const result = await res.json();
      if (result.success && Array.isArray(result.data)) {
        setZones(result.data);
      } else {
        setZones([]);
      }
    } catch {
      setZones([]);
    }
  }, []);

  const fetchDrivers = useCallback(async () => {
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/user/drivers`);
      const result = await res.json();
      if (result.success && Array.isArray(result.data)) {
        setDrivers(result.data);
      } else {
        setDrivers([]);
      }
    } catch {
      setDrivers([]);
    }
  }, []);

  const drawZonesOnMap = useCallback((map: google.maps.Map) => {
    polygonsRef.current.forEach((p) => p.setMap(null));
    polygonsRef.current = [];
    zones.forEach((zone) => {
      if (!zone.coordinates || zone.coordinates.length < 3) return;
      const path = zone.coordinates.map((c) => ({ lat: Number(c.lat), lng: Number(c.lng) }));
      const poly = new window.google.maps.Polygon({
        paths: path,
        strokeColor: '#1976d2',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#1976d2',
        fillOpacity: 0.2,
        map,
      });
      polygonsRef.current.push(poly);
    });
  }, [zones]);

  useEffect(() => {
    document.title = 'Хүргэлтийн бүс зургаар';
    fetchZones();
    fetchDrivers();
  }, [fetchZones, fetchDrivers]);

  useEffect(() => {
    if (!API_KEY || typeof window === 'undefined') return;

    window.initDeliveryZonesMap = () => {
      if (!mapRef.current || !window.google) return;
      const map = new window.google.maps.Map(mapRef.current, {
        center: DEFAULT_CENTER,
        zoom: 12,
        mapTypeId: 'roadmap',
      });
      mapInstanceRef.current = map;

      const drawingManager = new window.google.maps.drawing.DrawingManager({
        drawingMode: window.google.maps.drawing.OverlayType.POLYGON,
        drawingControl: true,
        drawingControlOptions: {
          position: window.google.maps.ControlPosition.TOP_CENTER,
          drawingModes: [
            window.google.maps.drawing.OverlayType.POLYGON,
          ],
        },
      });
      drawingManager.setMap(map);
      drawingManagerRef.current = drawingManager;

      window.google.maps.event.addListener(drawingManager, 'polygoncomplete', (polygon: google.maps.Polygon) => {
        const path = polygon.getPath();
        const arr: { lat: number; lng: number }[] = [];
        for (let i = 0; i < path.getLength(); i++) {
          const p = path.getAt(i);
          arr.push({ lat: p.lat(), lng: p.lng() });
        }
        polygon.setMap(null);
        setPendingPath(arr);
        setSaveModalOpen(true);
        form.resetFields();
      });

      setLoading(false);
    };

    if (window.google?.maps?.drawing) {
      window.initDeliveryZonesMap();
      return;
    }

    const script = document.createElement('script');
    script.src = `https://maps.googleapis.com/maps/api/js?key=${API_KEY}&libraries=drawing&callback=initDeliveryZonesMap`;
    script.async = true;
    script.defer = true;
    document.head.appendChild(script);
    return () => {
      script.remove();
    };
  }, []);

  useEffect(() => {
    if (mapInstanceRef.current && zones.length >= 0) {
      drawZonesOnMap(mapInstanceRef.current);
    }
  }, [zones, drawZonesOnMap]);

  const handleSaveZone = async () => {
    try {
      const values = await form.validateFields();
      setSaving(true);
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery-zone`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          name: values.name,
          driver_id: values.driver_id,
          coordinates: pendingPath,
        }),
      });
      const result = await res.json();
      if (result.success) {
        msg.success('Бүс амжилттай нэмэгдлээ');
        setSaveModalOpen(false);
        setPendingPath([]);
        await fetchZones();
      } else {
        msg.error(result.message || 'Алдаа гарлаа');
      }
    } catch (e) {
      if (e && typeof (e as Error).message === 'string') msg.error((e as Error).message);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (id: number) => {
    try {
      const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/delivery-zone/${id}`, {
        method: 'DELETE',
      });
      const result = await res.json();
      if (result.success) {
        msg.success('Бүс устгагдлаа');
        await fetchZones();
      } else {
        msg.error(result.message || 'Устгахад алдаа');
      }
    } catch {
      msg.error('Устгахад алдаа');
    }
  };

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 16 }}>
      <Card title="Хүргэлтийн бүс зургаар">
        <p style={{ color: '#666', marginBottom: 16 }}>
          Зургийн дээр полигон зурж, бүс бүрт жолооч онооно. Шинэ захиалга үүсэхэд хаягийн координат (lat/lng) аль бүсэд байгааг шалгаад тухайн жолооч автоматаар оноогдоно.
        </p>
        <div style={{ display: 'flex', gap: 24, flexWrap: 'wrap' }}>
          <div style={{ flex: '1 1 400px', minHeight: 480 }}>
            <div
              ref={mapRef}
              style={{ width: '100%', height: 480, borderRadius: 8, background: '#f0f0f0' }}
            />
            {loading && (
              <div style={{ position: 'absolute', top: 100, left: '50%', transform: 'translateX(-50%)' }}>
                Газрын зург ачааллаж байна...
              </div>
            )}
          </div>
          <div style={{ width: 280 }}>
            <div style={{ marginBottom: 8, fontWeight: 600 }}>Бүсүүдийн жагсаалт</div>
            <List
              dataSource={zones}
              renderItem={(item) => (
                <List.Item
                  actions={[
                    <Button
                      key="delete"
                      type="text"
                      danger
                      icon={<DeleteOutlined />}
                      onClick={() => handleDelete(item.id)}
                    />,
                  ]}
                >
                  <div>
                    <div>{item.name}</div>
                    <div style={{ fontSize: 12, color: '#666' }}>
                      {item.driver?.username ?? `Driver #${item.driver_id}`}
                    </div>
                  </div>
                </List.Item>
              )}
            />
          </div>
        </div>
      </Card>

      <Modal
        title="Бүс бүртгэх"
        open={saveModalOpen}
        onOk={handleSaveZone}
        onCancel={() => {
          setSaveModalOpen(false);
          setPendingPath([]);
        }}
        okText="Хадгалах"
        cancelText="Цуцлах"
        confirmLoading={saving}
      >
        <Form form={form} layout="vertical">
          <Form.Item name="name" label="Бүсийн нэр" rules={[{ required: true, message: 'Нэр оруулна уу' }]}>
            <Input placeholder="Жишээ: Төв бүс" />
          </Form.Item>
          <Form.Item name="driver_id" label="Жолооч" rules={[{ required: true, message: 'Жолооч сонгоно уу' }]}>
            <Select
              placeholder="Жолооч сонгох"
              showSearch
              optionFilterProp="children"
              options={drivers.map((d) => ({ label: d.username, value: d.id }))}
            />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
