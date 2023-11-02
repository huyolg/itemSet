import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import FiveChess from '../pages/wuziqi/FiveChess.vue'
import HomePage from '../pages/homePage/HomePage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/five-chess',
      name: 'fivechess',
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('../pages/wuziqi/FiveChess.vue')
    },
    {
      path: '/',
      name: 'home',
      component: HomePage
    }
  ]
})

export default router
