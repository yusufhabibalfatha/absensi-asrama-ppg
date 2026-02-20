import { fileURLToPath, URL } from "node:url";
import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";
import vue from "@vitejs/plugin-vue";
import vueDevTools from "vite-plugin-vue-devtools";

// https://vite.dev/config/
export default defineConfig({
  base: "./", // penting agar path relatif, bisa dihosting di subfolder
  plugins: [tailwindcss(), vue(), vueDevTools()],
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
    },
  },
  build: {
    outDir: "dist",
    rollupOptions: {
      output: {
        assetFileNames: "[name].[ext]", // semua file asset di root
        chunkFileNames: "[name].js",
        entryFileNames: "[name].js",
      },
    },
  },
});
