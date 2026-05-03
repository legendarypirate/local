declare namespace google {
  namespace maps {
    class Map {
      constructor(element: HTMLElement, opts?: Record<string, unknown>);
    }
    class Polygon {
      constructor(opts?: {
        paths?: { lat: number; lng: number }[];
        map?: Map | null;
        strokeColor?: string;
        strokeOpacity?: number;
        strokeWeight?: number;
        fillColor?: string;
        fillOpacity?: number;
      });
      setMap(map: Map | null): void;
      getPath(): {
        getLength(): number;
        getAt(i: number): { lat(): number; lng(): number };
      };
    }
    namespace drawing {
      class DrawingManager {
        constructor(opts?: Record<string, unknown>);
        setMap(map: Map | null): void;
      }
      enum OverlayType {
        POLYGON = 'polygon',
      }
    }
    enum ControlPosition {
      TOP_CENTER = 2,
    }
    namespace event {
      function addListener(
        instance: object,
        eventName: string,
        handler: (...args: any[]) => void
      ): unknown;
    }
  }
}
