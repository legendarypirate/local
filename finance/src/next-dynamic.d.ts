declare module 'next/dynamic' {
  import type { ComponentType, ReactNode } from 'react';
  type DynamicOptions<P = {}> = {
    ssr?: boolean;
    loading?: () => ReactNode;
    [key: string]: unknown;
  };
  function dynamic<P = {}>(
    loader: () => Promise<{ default: ComponentType<P> }>,
    options?: DynamicOptions<P>
  ): ComponentType<P>;
  export default dynamic;
}
