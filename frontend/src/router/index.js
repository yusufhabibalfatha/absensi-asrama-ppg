import { createRouter, createWebHistory } from "vue-router";
import Home from "../pages/Home.vue";
import Absensi from "../pages/Absensi.vue";

const routes = [
  { path: "/", name: "Home", component: Home },
  { path: "/absensi", name: "Absensi", component: Absensi },
];

// const router = createRouter({
//   history: createWebHistory(),
//   routes,
// });

const router = createRouter({
  history: createWebHistory(),
  routes: routes,
  scrollBehavior(to, from, savedPosition) {
    return { top: 0 };
  },
});

export default router;
