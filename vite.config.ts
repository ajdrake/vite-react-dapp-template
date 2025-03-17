import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';
import tsconfigPaths from 'vite-tsconfig-paths';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), tsconfigPaths()],
  server: {
    port: 3000, // Use the correct port
    strictPort: true,
    host: "0.0.0.0", // Bind to all interfaces
  },
  preview: {
    port: 4173,
    strictPort: true,
    host: "0.0.0.0",
  },
  build: {
    outDir: "dist", 
    emptyOutDir: true,
    sourcemap: false,
    modulePreload: {
      resolveDependencies: (_url, _deps, _context) => {
        return [];
      },
    },
    rollupOptions: {
      output: {
        sourcemap: false,
        manualChunks: {
          ethers: ['ethers'],
          router: ['react-router-dom'],
          rtk: ['@reduxjs/toolkit'],
          redux: ['react-redux'],
          mantine: ['@mantine/core', '@mantine/hooks'],
        },
      },
    },
  },
});
