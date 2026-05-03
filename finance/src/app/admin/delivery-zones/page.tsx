'use client';

import React, { useEffect, useState, useRef, useCallback } from 'react';
import { Card, Button, Select, List, Modal, Form, Input, App, Alert, Typography } from 'antd';
import { DeleteOutlined } from '@ant-design/icons';

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
    /** Google Maps JS дуудаж буй түлхүүр/төсөл татгалзсан үед (жишээ нь ProjectDeniedMapError). */
    gm_authFailure?: () => void;
  }
}

const MAP_INIT_RAF_MAX = 90; // ~1.5s: callback/Strict Mode — DOM холбогдохыг хүлээнэ

export default function DeliveryZonesPage() {
  const { message: msg } = App.useApp();
  const mapRef = useRef<HTMLDivElement>(null);
  const mapInstanceRef = useRef<google.maps.Map | null>(null);
  const drawingManagerRef = useRef<google.maps.drawing.DrawingManager | null>(null);
  const polygonsRef = useRef<google.maps.Polygon[]>([]);
  const mapInitRafAttempts = useRef(0);

  const mapEnabled = Boolean(API_KEY);

  const [zones, setZones] = useState<DeliveryZone[]>([]);
  const [drivers, setDrivers] = useState<Driver[]>([]);
  const [loading, setLoading] = useState(true);
  const [mapInitError, setMapInitError] = useState<string | null>(null);
  /** Түлхүүр татгалзсан — React-ийн map div-ийг нуугаад «Oops» overlay харагдуулахгүй. */
  const [mapBlockedByAuth, setMapBlockedByAuth] = useState(false);
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
    if (!mapEnabled || typeof window === 'undefined') {
      setLoading(false);
      return;
    }

    let cancelled = false;
    setMapInitError(null);
    setMapBlockedByAuth(false);

    const priorGmAuthFailure = window.gm_authFailure;
    window.gm_authFailure = () => {
      if (cancelled) return;
      const detail =
        'Google Maps ачаалагдахгүй (ProjectDeniedMapError эсвэл түлхүүр татгалзсан). Google Cloud төсөлд Billing холбогдсон эсэх, Maps JavaScript API идэвхтэй эсэх, түлхүүрийн HTTP referrer одоогийн домэйнд тохирсон эсэхийг шалгана уу.';
      console.error('[delivery-zones] gm_authFailure', detail);
      setMapInitError(detail);
      setMapBlockedByAuth(true);
      setLoading(false);
      polygonsRef.current.forEach((p) => p.setMap(null));
      polygonsRef.current = [];
      drawingManagerRef.current?.setMap(null);
      drawingManagerRef.current = null;
      mapInstanceRef.current = null;
    };

    const buildMap = () => {
      if (cancelled || !window.google?.maps?.drawing) return;
      const el = mapRef.current;
      if (!el || !el.isConnected || !(el instanceof HTMLElement)) {
        mapInitRafAttempts.current += 1;
        if (mapInitRafAttempts.current > MAP_INIT_RAF_MAX) {
          const err =
            'Газрын зургийн DOM элемент бэлэн болоогүй тул IntersectionObserver алдаа гарч болно. Хуудсыг дахин ачаална уу.';
          console.error('[delivery-zones]', err);
          setMapInitError(err);
          setLoading(false);
          return;
        }
        requestAnimationFrame(buildMap);
        return;
      }
      mapInitRafAttempts.current = 0;

      try {
        const map = new window.google.maps.Map(el, {
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
            drawingModes: [window.google.maps.drawing.OverlayType.POLYGON],
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
      } catch (e) {
        console.error('[delivery-zones] Map / DrawingManager init failed', e);
        setMapInitError(e instanceof Error ? e.message : 'Газрын зураг эхлүүлэхэд алдаа');
        setLoading(false);
      }
    };

    window.initDeliveryZonesMap = () => {
      if (cancelled) return;
      mapInitRafAttempts.current = 0;
      buildMap();
    };

    const scriptSelector = 'script[data-finance-delivery-zones-maps]';

    if (window.google?.maps?.drawing) {
      queueMicrotask(() => {
        if (!cancelled) window.initDeliveryZonesMap();
      });
    } else if (document.querySelector(scriptSelector)) {
      const waitLoaded = () => {
        if (cancelled) return;
        if (window.google?.maps?.drawing) {
          window.initDeliveryZonesMap();
        } else {
          requestAnimationFrame(waitLoaded);
        }
      };
      waitLoaded();
    } else {
      const script = document.createElement('script');
      script.setAttribute('data-finance-delivery-zones-maps', '1');
      script.src = `https://maps.googleapis.com/maps/api/js?key=${API_KEY}&libraries=drawing&callback=initDeliveryZonesMap`;
      script.async = true;
      script.defer = true;
      document.head.appendChild(script);
    }

    return () => {
      cancelled = true;
      window.initDeliveryZonesMap = () => {};
      window.gm_authFailure = priorGmAuthFailure;
      polygonsRef.current.forEach((p) => p.setMap(null));
      polygonsRef.current = [];
      drawingManagerRef.current?.setMap(null);
      drawingManagerRef.current = null;
      mapInstanceRef.current = null;
    };
  }, [mapEnabled]);

  useEffect(() => {
    if (mapInstanceRef.current && zones.length >= 0 && mapEnabled) {
      drawZonesOnMap(mapInstanceRef.current);
    }
  }, [zones, drawZonesOnMap, mapEnabled]);

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

  if (!API_KEY) {
    return (
      <div style={{ padding: 24 }}>
        <Alert
          type="error"
          showIcon
          message="Google Maps API түлхүүр байхгүй"
          description={
            <>
              <Typography.Paragraph>
                .env.local эсвэл deploy орчинд{' '}
                <Typography.Text code>NEXT_PUBLIC_GOOGLE_MAPS_API_KEY</Typography.Text> нэмнэ үү. Google Cloud Console
                дээр <strong>Maps JavaScript API</strong> болон зураг зурахын хувьд <strong>Drawing</strong> library
                идэвхжүүлнэ.
              </Typography.Paragraph>
              <Typography.Link href="https://console.cloud.google.com/google/maps-apis" target="_blank" rel="noreferrer">
                Google Maps API — console
              </Typography.Link>
            </>
          }
        />
        <Card title="Бүсүүдийн жагсаалт (зураггүй)" style={{ marginTop: 16 }}>
          <List
            dataSource={zones}
            renderItem={(item) => (
              <List.Item>
                <div>
                  <div>{item.name}</div>
                  <div style={{ fontSize: 12, color: '#666' }}>
                    {item.driver?.username ?? `Driver #${item.driver_id}`}
                  </div>
                </div>
              </List.Item>
            )}
          />
        </Card>
      </div>
    );
  }

  return (
    <div style={{ padding: 24, display: 'flex', flexDirection: 'column', gap: 16 }}>
      <Card title="Хүргэлтийн бүс зургаар">
        {mapInitError ? (
          <Alert
            type="error"
            showIcon
            style={{ marginBottom: 16 }}
            message={mapInitError}
            description={
              mapBlockedByAuth ? (
                <Typography.Link
                  href="https://developers.google.com/maps/documentation/javascript/error-messages#project-denied-map-error"
                  target="_blank"
                  rel="noreferrer"
                >
                  ProjectDeniedMapError — алдааны тайлбар (Google)
                </Typography.Link>
              ) : undefined
            }
          />
        ) : null}
        <p style={{ color: '#666', marginBottom: 16 }}>
          Зургийн дээр полигон зурж, бүс бүрт жолооч онооно. Шинэ захиалга үүсэхэд хаягийн координат (lat/lng) аль бүсэд
          байгааг шалгаад тухайн жолооч автоматаар оноогдоно.
        </p>
        <p style={{ color: '#888', marginBottom: 16, fontSize: 13 }}>
          Хэрэв консолд <Typography.Text code>ProjectDeniedMapError</Typography.Text> гарвал төсөлд billing холбогдсон
          эсэх, <Typography.Text code>Maps JavaScript API</Typography.Text> идэвхтэй эсэх, түлхүүрийн referrer-ийг
          шалгана уу —{' '}
          <Typography.Link
            href="https://developers.google.com/maps/documentation/javascript/error-messages#project-denied-map-error"
            target="_blank"
            rel="noreferrer"
          >
            Google — ProjectDeniedMapError
          </Typography.Link>
          . <Typography.Text type="secondary">Drawing library</Typography.Text> deprecation нь зөвхөн анхааруулга; одоогоор
          полигон зурахад ашиглана.
        </p>
        <div style={{ display: 'flex', gap: 24, flexWrap: 'wrap' }}>
          <div style={{ flex: '1 1 400px', minHeight: 480, position: 'relative' }}>
            {mapBlockedByAuth ? (
              <div
                style={{
                  width: '100%',
                  height: 480,
                  borderRadius: 8,
                  background: '#f5f5f5',
                  border: '1px dashed #d9d9d9',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  padding: 24,
                  textAlign: 'center',
                  color: '#666',
                  fontSize: 14,
                }}
              >
                Газрын зураг идэвхжээгүй — доорх алдааны мэдээллийг засаад хуудсыг дахин ачаална уу.
              </div>
            ) : (
              <div
                ref={mapRef}
                style={{ width: '100%', height: 480, borderRadius: 8, background: '#e8eaf0' }}
              />
            )}
            {loading && !mapBlockedByAuth && (
              <div
                style={{
                  position: 'absolute',
                  inset: 0,
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  background: 'rgba(255,255,255,0.75)',
                  borderRadius: 8,
                  fontSize: 14,
                  color: '#555',
                }}
              >
                Газрын зураг ачааллаж байна...
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
