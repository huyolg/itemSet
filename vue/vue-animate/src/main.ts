import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

import App from './App.vue'
import router from './router'
import HomePageVue from './pages/homePage/HomePage.vue'
import FiveChess from './pages/wuziqi/FiveChess.vue'

const app = createApp(FiveChess)

app.use(createPinia())
app.use(router)
app.use(ElementPlus)

app.mount('#app')
