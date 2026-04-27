#!/bin/bash
# 财资API开放平台 - 一键创建项目脚本
# 使用方式: bash setup.sh

set -e
PROJECT="treasury-api-platform"
mkdir -p "$PROJECT/src"/{views/admin,components,router,assets,utils}
mkdir -p "$PROJECT/public"
cd "$PROJECT"

# ========== package.json ==========
cat > package.json << 'EOF'
{
  "name": "treasury-api-platform",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.4.0",
    "vue-router": "^4.3.0",
    "element-plus": "^2.7.0",
    "@element-plus/icons-vue": "^2.3.0",
    "pinia": "^2.1.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "vite": "^5.4.0"
  }
}
EOF

# ========== vite.config.js ==========
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 3000,
    open: true
  }
})
EOF

# ========== index.html ==========
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>宁波银行财资API开放平台</title>
</head>
<body>
  <div id="app"></div>
  <script type="module" src="/src/main.js"></script>
</body>
</html>
EOF

# ========== src/main.js ==========
cat > src/main.js << 'JSEOF'
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import App from './App.vue'
import router from './router'
import './assets/main.css'

const app = createApp(App)

for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

app.use(createPinia())
app.use(router)
app.use(ElementPlus, { locale: zhCn })
app.mount('#app')
JSEOF

# ========== src/App.vue ==========
cat > src/App.vue << 'EOF'
<template>
  <div id="app-root">
    <AppHeader />
    <router-view v-slot="{ Component }">
      <transition name="fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
    <AppFooter />
  </div>
</template>

<script setup>
import AppHeader from './components/AppHeader.vue'
import AppFooter from './components/AppFooter.vue'
</script>

<style>
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
EOF

# ========== src/assets/main.css ==========
cat > src/assets/main.css << 'EOF'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
:root {
  --primary: #1a56db;
  --primary-dark: #1244b0;
  --primary-light: #3b82f6;
  --bg: #f5f7fa;
  --text: #1f2937;
  --text-light: #6b7280;
  --border: #e5e7eb;
  --white: #ffffff;
  --shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  --shadow-lg: 0 8px 30px rgba(0, 0, 0, 0.12);
}
body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
  color: var(--text);
  background: var(--bg);
  line-height: 1.6;
}
a { text-decoration: none; color: inherit; }
.container { max-width: 1200px; margin: 0 auto; padding: 0 24px; }
.hero-gradient { background: linear-gradient(135deg, #1a3a8a 0%, #1a56db 50%, #3b82f6 100%); color: white; }
.card-hover { transition: all 0.3s ease; cursor: pointer; }
.card-hover:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg); }
.section-title { text-align: center; font-size: 28px; font-weight: 700; color: var(--text); margin-bottom: 12px; }
.section-desc { text-align: center; color: var(--text-light); font-size: 16px; margin-bottom: 48px; }
EOF

# ========== src/router/index.js ==========
cat > src/router/index.js << 'EOF'
import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', name: 'Home', component: () => import('../views/Home.vue') },
  { path: '/docs', name: 'Docs', component: () => import('../views/Docs.vue') },
  { path: '/download', name: 'Download', component: () => import('../views/Download.vue') },
  { path: '/admin/login', name: 'AdminLogin', component: () => import('../views/admin/AdminLogin.vue') },
  {
    path: '/admin', name: 'Admin', component: () => import('../views/admin/AdminLayout.vue'),
    meta: { requiresAdmin: true },
    children: [
      { path: 'attachments', name: 'Attachments', component: () => import('../views/admin/AttachmentManage.vue') },
      { path: 'users', name: 'Users', component: () => import('../views/admin/UserManage.vue') },
      { path: 'logs', name: 'Logs', component: () => import('../views/admin/LogManage.vue') }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() { return { top: 0 } }
})

router.beforeEach((to, from, next) => {
  if (to.meta.requiresAdmin) {
    const isAdmin = localStorage.getItem('admin_token')
    if (!isAdmin) next({ name: 'AdminLogin' })
    else next()
  } else {
    next()
  }
})

export default router
EOF

# ========== src/utils/store.js ==========
cat > src/utils/store.js << 'EOF'
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const isLoggedIn = ref(false)
  const username = ref('')
  const showLoginDialog = ref(false)

  function login(name) { isLoggedIn.value = true; username.value = name; showLoginDialog.value = false }
  function logout() { isLoggedIn.value = false; username.value = '' }
  function openLogin() { showLoginDialog.value = true }

  return { isLoggedIn, username, showLoginDialog, login, logout, openLogin }
})
EOF

# ========== src/utils/mock.js ==========
cat > src/utils/mock.js << 'EOF'
export const banners = [
  { id: 1, title: '财资API开放平台', subtitle: '提供标准化的访问接口，帮助合作伙伴快速接入', color: '#1a56db' },
  { id: 2, title: '安全可靠的金融服务', subtitle: '多重加密保障，数据安全无忧', color: '#0f766e' },
  { id: 3, title: '丰富的API产品矩阵', subtitle: '覆盖账户、转账、投资、融资等全场景', color: '#7c3aed' }
]

export const productModules = [
  { id: 1, name: '账户管理', icon: '🏦', desc: '账户查询、余额、交易明细等接口', route: '/docs' },
  { id: 2, name: '转账汇款', icon: '💸', desc: '行内转账、跨行转账、批量转账', route: '/docs' },
  { id: 3, name: '投资管理', icon: '📈', desc: '理财产品、基金、国债等接口', route: '/docs' },
  { id: 4, name: '融资管理', icon: '💰', desc: '贷款申请、额度查询、还款计划', route: '/docs' },
  { id: 5, name: '定额票据', icon: '📋', desc: '票据查询、开票、贴现等接口', route: '/docs' },
  { id: 6, name: '外汇业务', icon: '🌐', desc: '汇率查询、外汇买卖、结售汇', route: '/docs' },
  { id: 7, name: '报送业务', icon: '📨', desc: '数据报送、报表生成等接口', route: '/docs' },
  { id: 8, name: '企信服务', icon: '🔍', desc: '企业征信、工商信息查询', route: '/docs' }
]

export const onboardSteps = [
  { step: 1, title: '注册认证', desc: '完成企业信息注册与资质认证', icon: '📝' },
  { step: 2, title: '应用创建', desc: '创建应用获取AppKey和AppSecret', icon: '🔧' },
  { step: 3, title: '产品申请', desc: '选择需要的API产品并提交申请', icon: '📦' },
  { step: 4, title: '开发测试', desc: '使用沙箱环境进行对接开发', icon: '💻' },
  { step: 5, title: '证书申请', desc: '申请数字证书用于生产环境', icon: '🔐' },
  { step: 6, title: '应用上线', desc: '完成验收，正式上线使用', icon: '🚀' }
]

export const docCategories = [
  { key: 'account', label: '账户管理' }, { key: 'transfer', label: '转账汇款' },
  { key: 'invest', label: '投资管理' }, { key: 'finance', label: '融资管理' },
  { key: 'bill', label: '定额票据' }, { key: 'forex', label: '外汇业务' },
  { key: 'report', label: '报送业务' }, { key: 'credit', label: '企信服务' }
]

export function getMockDocs(category = null) {
  const allDocs = [
    { id: 1, category: 'account', title: '账户信息查询接口文档', fileName: 'AccountQueryAPI_v2.1.pdf', updateTime: '2026-04-08 10:30:00' },
    { id: 2, category: 'account', title: '交易明细查询接口文档', fileName: 'TransactionDetailAPI_v1.5.pdf', updateTime: '2026-04-07 14:20:00' },
    { id: 3, category: 'account', title: '余额通知接口文档', fileName: 'BalanceNotifyAPI_v1.0.pdf', updateTime: '2026-04-05 09:15:00' },
    { id: 4, category: 'transfer', title: '行内转账接口文档', fileName: 'InternalTransferAPI_v2.3.pdf', updateTime: '2026-04-06 16:45:00' },
    { id: 5, category: 'transfer', title: '跨行转账接口文档', fileName: 'CrossBankTransferAPI_v2.0.pdf', updateTime: '2026-04-04 11:30:00' },
    { id: 6, category: 'transfer', title: '批量转账接口文档', fileName: 'BatchTransferAPI_v1.2.pdf', updateTime: '2026-04-03 08:50:00' },
    { id: 7, category: 'invest', title: '理财产品查询接口文档', fileName: 'WealthMgmtAPI_v1.8.pdf', updateTime: '2026-04-02 15:00:00' },
    { id: 8, category: 'finance', title: '贷款申请接口文档', fileName: 'LoanApplyAPI_v1.1.pdf', updateTime: '2026-04-01 10:20:00' },
    { id: 9, category: 'bill', title: '票据查询接口文档', fileName: 'BillQueryAPI_v1.3.pdf', updateTime: '2026-03-30 14:10:00' },
    { id: 10, category: 'forex', title: '汇率查询接口文档', fileName: 'FxRateAPI_v2.5.pdf', updateTime: '2026-03-29 09:30:00' },
    { id: 11, category: 'report', title: '数据报送接口文档', fileName: 'DataReportAPI_v1.0.pdf', updateTime: '2026-03-28 16:00:00' },
    { id: 12, category: 'credit', title: '企业征信查询接口文档', fileName: 'CreditQueryAPI_v1.4.pdf', updateTime: '2026-03-27 11:40:00' }
  ]
  if (category) return allDocs.filter(d => d.category === category)
  return allDocs
}

export function getMockDownloads() {
  return {
    Java: [
      { id: 1, name: 'Java SDK v2.1.0', desc: '核心开发工具包', fileName: 'nbcx-sdk-java-2.1.0.jar', updateTime: '2026-04-08' },
      { id: 2, name: 'Java Demo项目', desc: 'Spring Boot 示例工程', fileName: 'nbcx-demo-java.zip', updateTime: '2026-04-07' },
      { id: 3, name: '签名工具包', desc: '请求签名验签工具', fileName: 'nbcx-sign-java-1.0.jar', updateTime: '2026-04-05' }
    ],
    PHP: [
      { id: 4, name: 'PHP SDK v1.5.0', desc: 'PHP开发工具包', fileName: 'nbcx-sdk-php-1.5.0.tar.gz', updateTime: '2026-04-06' },
      { id: 5, name: 'PHP Demo项目', desc: 'Laravel 示例工程', fileName: 'nbcx-demo-php.zip', updateTime: '2026-04-04' }
    ],
    'C#': [
      { id: 6, name: 'C# SDK v1.2.0', desc: '.NET开发工具包', fileName: 'nbcx-sdk-csharp-1.2.0.nupkg', updateTime: '2026-04-03' },
      { id: 7, name: 'C# Demo项目', desc: 'ASP.NET Core 示例工程', fileName: 'nbcx-demo-csharp.zip', updateTime: '2026-04-01' }
    ]
  }
}

export const mockUsers = [
  { id: 1, type: '行内用户', username: 'zhangsan', role: '行内用户', phone: '--', loginTime: '2026-04-14 18:30:00' },
  { id: 2, type: '行内用户', username: 'lisi', role: '行内用户', phone: '--', loginTime: '2026-04-14 17:20:00' },
  { id: 3, type: '行内用户', username: 'wangwu', role: '行内用户', phone: '--', loginTime: '2026-04-13 15:45:00' },
  { id: 4, type: '行内用户', username: 'zhaoliu', role: '行内用户', phone: '--', loginTime: '2026-04-12 10:10:00' }
]

export const mockLogs = [
  { id: 1, user: 'zhangsan', action: '登录', target: '用户登录', ip: '10.20.30.40', time: '2026-04-14 18:30:00' },
  { id: 2, user: 'zhangsan', action: '下载', target: 'AccountQueryAPI_v2.1.pdf', ip: '10.20.30.40', time: '2026-04-14 18:32:00' },
  { id: 3, user: 'lisi', action: '登录', target: '用户登录', ip: '10.20.30.41', time: '2026-04-14 17:20:00' },
  { id: 4, user: 'lisi', action: '下载', target: 'nbcx-sdk-java-2.1.0.jar', ip: '10.20.30.41', time: '2026-04-14 17:25:00' },
  { id: 5, user: 'wangwu', action: '登录', target: '用户登录', ip: '10.20.30.42', time: '2026-04-13 15:45:00' },
  { id: 6, user: 'wangwu', action: '浏览', target: '文档中心', ip: '10.20.30.42', time: '2026-04-13 15:47:00' }
]
EOF

# ========== src/components/AppHeader.vue ==========
cat > src/components/AppHeader.vue << 'EOF'
<template>
  <header class="app-header">
    <div class="header-inner container">
      <router-link to="/" class="logo">
        <span class="logo-icon">🏛️</span>
        <span class="logo-text">宁波银行财资大管家</span>
        <span class="logo-divider">|</span>
        <span class="logo-sub">API开放平台</span>
      </router-link>
      <nav class="nav-links">
        <router-link to="/" class="nav-item" :class="{ active: route.path === '/' }">首页</router-link>
        <router-link to="/docs" class="nav-item" :class="{ active: route.path === '/docs' }">文档中心</router-link>
        <router-link to="/download" class="nav-item" :class="{ active: route.path === '/download' }">下载中心</router-link>
        <a href="#" class="nav-item">产品中心</a>
      </nav>
      <div class="header-right">
        <template v-if="store.isLoggedIn">
          <el-dropdown>
            <span class="user-name">👤 {{ store.username }} <el-icon><arrow-down /></el-icon></span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="store.logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </template>
        <template v-else>
          <el-button type="primary" plain size="small" @click="store.openLogin">登录</el-button>
          <el-button size="small" style="margin-left: 8px" disabled>注册</el-button>
        </template>
        <router-link to="/admin/login" class="admin-link">管理端</router-link>
      </div>
    </div>
    <LoginDialog />
  </header>
</template>

<script setup>
import { useRoute } from 'vue-router'
import { useUserStore } from '../utils/store'
import LoginDialog from './LoginDialog.vue'
const route = useRoute()
const store = useUserStore()
</script>

<style scoped>
.app-header { background: var(--white); border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 1000; box-shadow: 0 1px 4px rgba(0,0,0,0.05); }
.header-inner { display: flex; align-items: center; height: 64px; gap: 40px; }
.logo { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
.logo-icon { font-size: 24px; }
.logo-text { font-size: 16px; font-weight: 700; color: var(--primary); }
.logo-divider { color: var(--border); font-size: 20px; }
.logo-sub { font-size: 14px; color: var(--text-light); }
.nav-links { display: flex; gap: 8px; flex: 1; }
.nav-item { padding: 8px 16px; border-radius: 6px; font-size: 14px; color: var(--text); transition: all 0.2s; }
.nav-item:hover, .nav-item.active { color: var(--primary); background: rgba(26,86,219,0.06); }
.header-right { display: flex; align-items: center; gap: 12px; }
.user-name { cursor: pointer; font-size: 14px; color: var(--text); display: flex; align-items: center; gap: 4px; }
.admin-link { font-size: 12px; color: var(--text-light); padding: 4px 8px; border: 1px solid var(--border); border-radius: 4px; transition: all 0.2s; }
.admin-link:hover { color: var(--primary); border-color: var(--primary); }
</style>
EOF

# ========== src/components/AppFooter.vue ==========
cat > src/components/AppFooter.vue << 'EOF'
<template>
  <footer class="app-footer">
    <div class="container">
      <div class="footer-links"><a href="#">关于我们</a><a href="#">服务协议</a><a href="#">隐私政策</a><a href="#">联系方式</a></div>
      <div class="footer-copy">© 2026 宁波银行股份有限公司 版权所有</div>
    </div>
  </footer>
</template>

<style scoped>
.app-footer { background: #1f2937; color: #9ca3af; padding: 32px 0; text-align: center; margin-top: 80px; }
.footer-links { display: flex; justify-content: center; gap: 24px; margin-bottom: 16px; }
.footer-links a { color: #9ca3af; font-size: 14px; transition: color 0.2s; }
.footer-links a:hover { color: #fff; }
.footer-copy { font-size: 13px; }
</style>
EOF

# ========== src/components/LoginDialog.vue ==========
cat > src/components/LoginDialog.vue << 'EOF'
<template>
  <el-dialog v-model="store.showLoginDialog" title="用户登录" width="420px" :close-on-click-modal="false" class="login-dialog">
    <p class="login-subtitle">欢迎使用财资API开放平台</p>
    <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
      <el-form-item label="用户名" prop="username">
        <el-input v-model="form.username" placeholder="请输入用户名（工号）" prefix-icon="User" size="large" />
      </el-form-item>
      <el-form-item label="密码" prop="password">
        <el-input v-model="form.password" type="password" placeholder="请输入密码" prefix-icon="Lock" size="large" show-password>
          <template #append>
            <el-button @click="getVerifyCode" :disabled="countdown > 0">{{ countdown > 0 ? countdown + '秒后重新获取' : '获取验证码' }}</el-button>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item prop="captcha">
        <SliderCaptcha ref="captchaRef" @success="onCaptchaSuccess" />
        <div v-if="captchaError" class="captcha-error">请进行滑块校验</div>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" size="large" style="width: 100%" @click="handleLogin" :loading="loading">立即登录</el-button>
      </el-form-item>
    </el-form>
  </el-dialog>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '../utils/store'
import SliderCaptcha from './SliderCaptcha.vue'

const store = useUserStore()
const formRef = ref()
const captchaRef = ref()
const loading = ref(false)
const countdown = ref(0)
const captchaPassed = ref(false)
const captchaError = ref(false)

const form = reactive({ username: '', password: '' })
const rules = { username: [{ required: true, message: '请输入用户名', trigger: 'blur' }], password: [{ required: true, message: '请输入密码', trigger: 'blur' }] }

function getVerifyCode() {
  if (!form.username) { ElMessage.warning('请先输入用户名'); return }
  ElMessage.success('验证码已发送（模拟）')
  countdown.value = 60
  const timer = setInterval(() => { countdown.value--; if (countdown.value <= 0) clearInterval(timer) }, 1000)
}

function onCaptchaSuccess() { captchaPassed.value = true; captchaError.value = false }

async function handleLogin() {
  captchaError.value = !captchaPassed.value
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid || !captchaPassed.value) return
  loading.value = true
  setTimeout(() => { loading.value = false; store.login(form.username); ElMessage.success('登录成功！'); form.username = ''; form.password = ''; captchaPassed.value = false; captchaRef.value?.reset() }, 800)
}
</script>

<style scoped>
.login-subtitle { text-align: center; color: var(--text-light); font-size: 14px; margin-bottom: 24px; margin-top: -8px; }
.captcha-error { color: #f56c6c; font-size: 12px; margin-top: 4px; }
</style>
EOF

# ========== src/components/SliderCaptcha.vue ==========
cat > src/components/SliderCaptcha.vue << 'EOF'
<template>
  <div class="captcha-container">
    <div class="captcha-track" ref="trackRef">
      <div class="captcha-bg">
        <div class="captcha-hole" :style="{ left: holeX + 'px' }"></div>
      </div>
      <div class="captcha-slider" :class="{ 'captcha-success': passed }" :style="{ left: sliderX + 'px' }" @mousedown.prevent="startDrag" @touchstart.prevent="startDrag">
        <span class="slider-icon">{{ passed ? '✓' : '⟩' }}</span>
      </div>
      <div class="captcha-text">{{ passed ? '验证通过' : '请拖动滑块完成验证' }}</div>
      <el-icon class="captcha-refresh" @click="reset"><refresh /></el-icon>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
const emit = defineEmits(['success'])
const trackRef = ref()
const holeX = ref(0)
const sliderX = ref(0)
const passed = ref(false)
let dragging = false
let startX = 0
const HOLE_SIZE = 40
const TRACK_WIDTH = 360

function randomHole() { holeX.value = 100 + Math.random() * (TRACK_WIDTH - HOLE_SIZE - 150) }

function startDrag(e) {
  if (passed.value) return
  dragging = true
  startX = (e.touches ? e.touches[0].clientX : e.clientX) - sliderX.value
  document.addEventListener('mousemove', onDrag)
  document.addEventListener('mouseup', endDrag)
  document.addEventListener('touchmove', onDrag)
  document.addEventListener('touchend', endDrag)
}

function onDrag(e) {
  if (!dragging) return
  const clientX = e.touches ? e.touches[0].clientX : e.clientX
  let x = clientX - startX
  x = Math.max(0, Math.min(x, TRACK_WIDTH - 44))
  sliderX.value = x
}

function endDrag() {
  dragging = false
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', endDrag)
  document.removeEventListener('touchmove', onDrag)
  document.removeEventListener('touchend', endDrag)
  const diff = Math.abs(sliderX.value - holeX.value)
  if (diff < 8) { passed.value = true; sliderX.value = holeX.value; emit('success') }
  else { const interval = setInterval(() => { sliderX.value -= 5; if (sliderX.value <= 0) { sliderX.value = 0; clearInterval(interval) } }, 10) }
}

function reset() { passed.value = false; sliderX.value = 0; randomHole() }
onMounted(() => { randomHole() })
defineExpose({ reset })
</script>

<style scoped>
.captcha-container { width: 100%; }
.captcha-track { position: relative; height: 44px; background: #f0f0f0; border-radius: 22px; overflow: hidden; user-select: none; }
.captcha-bg { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: #e8e8e8; }
.captcha-hole { position: absolute; top: 2px; width: 40px; height: 40px; background: #fff; border-radius: 4px; box-shadow: inset 0 0 6px rgba(0,0,0,0.15); }
.captcha-slider { position: absolute; top: 2px; left: 0; width: 44px; height: 40px; background: var(--primary); border-radius: 20px; display: flex; align-items: center; justify-content: center; cursor: grab; z-index: 2; transition: background 0.2s; }
.captcha-slider.captcha-success { background: #67c23a; cursor: default; }
.slider-icon { color: #fff; font-size: 18px; font-weight: bold; }
.captcha-text { position: absolute; top: 0; left: 0; right: 0; bottom: 0; display: flex; align-items: center; justify-content: center; color: #999; font-size: 13px; z-index: 1; }
.captcha-refresh { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #999; z-index: 3; transition: color 0.2s; }
.captcha-refresh:hover { color: var(--primary); }
</style>
EOF

echo "✅ Components done, creating views..."

# ========== src/views/Home.vue ==========
cat > src/views/Home.vue << 'VUEEOF'
<template>
  <div class="home-page">
    <section class="hero">
      <div class="container">
        <el-carousel height="320px" :interval="4000" indicator-position="outside" arrow="always">
          <el-carousel-item v-for="b in banners" :key="b.id">
            <div class="banner-slide" :style="{ background: b.color }">
              <div class="banner-content">
                <h1>{{ b.title }}</h1>
                <p>{{ b.subtitle }}</p>
                <el-button type="primary" size="large" plain round>立即入驻</el-button>
              </div>
              <div class="banner-visual">🌐</div>
            </div>
          </el-carousel-item>
        </el-carousel>
      </div>
    </section>
    <section class="intro-section">
      <div class="container">
        <div class="intro-card">
          <h2>财资开放API</h2>
          <p>提供标准化的访问接口，帮助合作伙伴快速接入财资开放平台</p>
        </div>
      </div>
    </section>
    <section class="products-section">
      <div class="container">
        <h2 class="section-title">产品模块</h2>
        <p class="section-desc">覆盖企业财资管理全场景</p>
        <div class="products-grid">
          <router-link v-for="p in productModules" :key="p.id" :to="p.route" class="product-card card-hover">
            <div class="product-icon">{{ p.icon }}</div>
            <h3>{{ p.name }}</h3>
            <p>{{ p.desc }}</p>
          </router-link>
        </div>
      </div>
    </section>
    <section class="flow-section">
      <div class="container">
        <h2 class="section-title">接入流程</h2>
        <p class="section-desc">六步快速接入，轻松开启数字金融之旅</p>
        <div class="flow-steps">
          <div v-for="(s, i) in onboardSteps" :key="s.step" class="flow-step">
            <div class="step-icon">{{ s.icon }}</div>
            <div class="step-num">Step {{ s.step }}</div>
            <h4>{{ s.title }}</h4>
            <p>{{ s.desc }}</p>
            <div v-if="i < onboardSteps.length - 1" class="step-arrow">→</div>
          </div>
        </div>
      </div>
    </section>
    <section class="cta-section">
      <div class="container">
        <div class="cta-card">
          <h2>准备好了吗？</h2>
          <p>立即开始对接，享受高效便捷的财资API服务</p>
          <el-button type="primary" size="large" round @click="$router.push('/docs')">查看文档 →</el-button>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { banners, productModules, onboardSteps } from '../utils/mock'
</script>

<style scoped>
.hero { padding: 40px 0 0; }
.banner-slide { height: 100%; border-radius: 16px; display: flex; align-items: center; justify-content: space-between; padding: 0 80px; color: white; overflow: hidden; }
.banner-content h1 { font-size: 36px; font-weight: 700; margin-bottom: 12px; }
.banner-content p { font-size: 18px; opacity: 0.9; margin-bottom: 28px; }
.banner-visual { font-size: 120px; opacity: 0.3; }
.intro-section { padding: 60px 0 20px; }
.intro-card { text-align: center; padding: 40px; background: linear-gradient(135deg, #f0f4ff 0%, #e8f0fe 100%); border-radius: 16px; }
.intro-card h2 { font-size: 24px; color: var(--primary); margin-bottom: 8px; }
.intro-card p { color: var(--text-light); font-size: 16px; }
.products-section { padding: 60px 0; }
.products-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
.product-card { background: var(--white); border-radius: 12px; padding: 28px 20px; text-align: center; border: 1px solid var(--border); }
.product-icon { font-size: 40px; margin-bottom: 12px; }
.product-card h3 { font-size: 16px; margin-bottom: 8px; color: var(--text); }
.product-card p { font-size: 13px; color: var(--text-light); line-height: 1.5; }
.flow-section { padding: 60px 0; background: var(--white); }
.flow-steps { display: flex; align-items: flex-start; justify-content: center; gap: 8px; flex-wrap: wrap; }
.flow-step { text-align: center; width: 160px; position: relative; }
.step-icon { font-size: 40px; margin-bottom: 8px; }
.step-num { font-size: 12px; color: var(--primary); font-weight: 600; margin-bottom: 4px; }
.flow-step h4 { font-size: 15px; margin-bottom: 4px; }
.flow-step p { font-size: 12px; color: var(--text-light); }
.step-arrow { position: absolute; right: -20px; top: 30px; font-size: 20px; color: var(--primary-light); font-weight: bold; }
.cta-section { padding: 60px 0; }
.cta-card { text-align: center; padding: 60px; background: linear-gradient(135deg, #1a3a8a 0%, #1a56db 100%); border-radius: 20px; color: white; }
.cta-card h2 { font-size: 32px; margin-bottom: 12px; }
.cta-card p { font-size: 16px; opacity: 0.9; margin-bottom: 28px; }
@media (max-width: 900px) { .products-grid { grid-template-columns: repeat(2, 1fr); } .banner-slide { padding: 0 32px; } .step-arrow { display: none; } }
</style>
VUEEOF

# ========== src/views/Docs.vue ==========
cat > src/views/Docs.vue << 'VUEEOF'
<template>
  <div class="docs-page">
    <div class="page-hero hero-gradient">
      <div class="container"><h1>文档中心</h1><p>按类别浏览和下载API接口文档</p></div>
    </div>
    <div class="container docs-body">
      <div class="docs-toolbar">
        <el-input v-model="searchKey" placeholder="请输入关键词进行搜索" prefix-icon="Search" size="large" clearable @keyup.enter="handleSearch" style="max-width: 400px" />
        <el-button type="primary" size="large" @click="batchDownload"><el-icon><download /></el-icon> 一键下载</el-button>
      </div>
      <div class="category-tabs">
        <el-radio-group v-model="activeCategory" size="large">
          <el-radio-button value="">全部文档</el-radio-button>
          <el-radio-button v-for="c in docCategories" :key="c.key" :value="c.key">{{ c.label }}</el-radio-button>
        </el-radio-group>
      </div>
      <el-table :data="filteredDocs" stripe style="width: 100%">
        <el-table-column type="index" label="序号" width="60" />
        <el-table-column prop="title" label="文档名称" min-width="260" />
        <el-table-column prop="fileName" label="文件名" min-width="240" />
        <el-table-column prop="updateTime" label="更新时间" width="180" />
        <el-table-column label="操作" width="100" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link size="small" @click="handleDownload(row)"><el-icon><download /></el-icon> 下载</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="docs-pagination"><el-pagination v-model:current-page="currentPage" :page-size="10" :total="filteredDocs.length" layout="total, prev, pager, next" background /></div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { docCategories, getMockDocs } from '../utils/mock'
import { useUserStore } from '../utils/store'

const store = useUserStore()
const searchKey = ref('')
const activeCategory = ref('')
const currentPage = ref(1)

const filteredDocs = computed(() => {
  let docs = getMockDocs(activeCategory.value || null)
  if (searchKey.value) { const key = searchKey.value.toLowerCase(); docs = docs.filter(d => d.title.toLowerCase().includes(key) || d.fileName.toLowerCase().includes(key)) }
  return docs
})

function handleSearch() { currentPage.value = 1 }
function handleDownload(row) { if (!store.isLoggedIn) { store.openLogin(); return } ElMessage.success('正在下载：' + row.fileName + '（模拟）') }
function batchDownload() { if (!store.isLoggedIn) { store.openLogin(); return } ElMessage.success('正在打包下载：财资API开放平台接入手册.zip（模拟）') }
</script>

<style scoped>
.page-hero { padding: 48px 0; text-align: center; }
.page-hero h1 { font-size: 32px; margin-bottom: 8px; }
.page-hero p { font-size: 16px; opacity: 0.85; }
.docs-body { padding: 32px 24px; }
.docs-toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
.category-tabs { margin-bottom: 24px; }
.docs-pagination { margin-top: 24px; display: flex; justify-content: flex-end; }
</style>
VUEEOF

# ========== src/views/Download.vue ==========
cat > src/views/Download.vue << 'VUEEOF'
<template>
  <div class="download-page">
    <div class="page-hero hero-gradient">
      <div class="container"><h1>下载中心</h1><p>帮助您快速了解财资开放平台对接方式，并提供Demo等</p></div>
    </div>
    <div class="container download-body">
      <el-tabs v-model="activeLang" type="border-card" class="lang-tabs">
        <el-tab-pane v-for="(items, lang) in downloads" :key="lang" :label="lang" :name="lang">
          <div class="download-cards">
            <div v-for="item in items" :key="item.id" class="download-card card-hover" @click="handleDownload(item)">
              <div class="card-icon">{{ langIcon(lang) }}</div>
              <div class="card-info">
                <h3>{{ item.name }}</h3>
                <p>{{ item.desc }}</p>
                <div class="card-meta"><span class="file-name">{{ item.fileName }}</span><span class="update-time">更新: {{ item.updateTime }}</span></div>
              </div>
              <el-icon class="download-icon"><download /></el-icon>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import { getMockDownloads } from '../utils/mock'
import { useUserStore } from '../utils/store'

const store = useUserStore()
const downloads = getMockDownloads()
const activeLang = ref('Java')

function langIcon(lang) { return { Java: '☕', PHP: '🐘', 'C#': '🔷' }[lang] || '📦' }
function handleDownload(item) { if (!store.isLoggedIn) { store.openLogin(); return } ElMessage.success('正在下载：' + item.fileName + '（模拟）') }
</script>

<style scoped>
.page-hero { padding: 48px 0; text-align: center; }
.page-hero h1 { font-size: 32px; margin-bottom: 8px; }
.page-hero p { font-size: 16px; opacity: 0.85; }
.download-body { padding: 32px 24px; }
.lang-tabs { border-radius: 12px; }
.download-cards { display: flex; flex-direction: column; gap: 16px; padding: 8px 0; }
.download-card { display: flex; align-items: center; gap: 20px; padding: 20px 24px; background: var(--white); border-radius: 12px; border: 1px solid var(--border); }
.card-icon { font-size: 40px; flex-shrink: 0; }
.card-info { flex: 1; }
.card-info h3 { font-size: 16px; margin-bottom: 4px; }
.card-info p { font-size: 13px; color: var(--text-light); margin-bottom: 6px; }
.card-meta { display: flex; gap: 16px; font-size: 12px; color: var(--text-light); }
.file-name { background: #f3f4f6; padding: 2px 8px; border-radius: 4px; }
.download-icon { font-size: 24px; color: var(--primary); flex-shrink: 0; }
</style>
VUEEOF

# ========== src/views/admin/AdminLogin.vue ==========
cat > src/views/admin/AdminLogin.vue << 'VUEEOF'
<template>
  <div class="admin-login-page">
    <div class="login-card">
      <div class="login-header"><h2>管理端登录</h2><p>财资API开放平台 · 后台管理</p></div>
      <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" prefix-icon="User" size="large" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" placeholder="请输入密码" prefix-icon="Lock" size="large" show-password />
        </el-form-item>
        <el-form-item prop="captcha">
          <SliderCaptcha ref="captchaRef" @success="captchaPassed = true" />
          <div v-if="captchaError" class="captcha-error">请进行滑块校验</div>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="large" style="width: 100%" @click="handleLogin" :loading="loading">立即登录</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import SliderCaptcha from '../../components/SliderCaptcha.vue'

const router = useRouter()
const formRef = ref()
const captchaRef = ref()
const loading = ref(false)
const captchaPassed = ref(false)
const captchaError = ref(false)

const form = reactive({ username: '', password: '' })
const rules = { username: [{ required: true, message: '请输入用户名', trigger: 'blur' }], password: [{ required: true, message: '请输入密码', trigger: 'blur' }] }

async function handleLogin() {
  captchaError.value = !captchaPassed.value
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid || !captchaPassed.value) return
  loading.value = true
  setTimeout(() => { loading.value = false; localStorage.setItem('admin_token', 'true'); localStorage.setItem('admin_user', form.username); ElMessage.success('登录成功！'); router.push('/admin/attachments') }, 600)
}
</script>

<style scoped>
.admin-login-page { min-height: calc(100vh - 120px); display: flex; align-items: center; justify-content: center; background: linear-gradient(135deg, #f0f4ff 0%, #e8f0fe 100%); }
.login-card { width: 440px; background: var(--white); border-radius: 16px; padding: 40px; box-shadow: var(--shadow-lg); }
.login-header { text-align: center; margin-bottom: 32px; }
.login-header h2 { font-size: 24px; color: var(--text); margin-bottom: 8px; }
.login-header p { font-size: 14px; color: var(--text-light); }
.captcha-error { color: #f56c6c; font-size: 12px; margin-top: 4px; }
</style>
VUEEOF

# ========== src/views/admin/AdminLayout.vue ==========
cat > src/views/admin/AdminLayout.vue << 'VUEEOF'
<template>
  <div class="admin-layout">
    <aside class="admin-sidebar">
      <div class="sidebar-header"><h3>📋 后台管理</h3></div>
      <el-menu :default-active="route.path" router class="sidebar-menu">
        <el-menu-item index="/admin/attachments"><el-icon><folder /></el-icon><span>附件管理</span></el-menu-item>
        <el-menu-item index="/admin/users"><el-icon><user /></el-icon><span>用户管理</span></el-menu-item>
        <el-menu-item index="/admin/logs"><el-icon><document /></el-icon><span>操作日志</span></el-menu-item>
      </el-menu>
      <div class="sidebar-footer">
        <el-button text @click="handleLogout"><el-icon><switch-button /></el-icon> 退出登录</el-button>
      </div>
    </aside>
    <main class="admin-main">
      <div class="admin-topbar">
        <el-breadcrumb separator="/"><el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item><el-breadcrumb-item>管理端</el-breadcrumb-item><el-breadcrumb-item>{{ currentTitle }}</el-breadcrumb-item></el-breadcrumb>
        <span class="admin-user">👤 {{ adminUser }}</span>
      </div>
      <div class="admin-content"><router-view /></div>
    </main>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
const route = useRoute()
const router = useRouter()
const adminUser = localStorage.getItem('admin_user') || 'admin'
const titleMap = { '/admin/attachments': '附件管理', '/admin/users': '用户管理', '/admin/logs': '操作日志' }
const currentTitle = computed(() => titleMap[route.path] || '管理')
function handleLogout() { localStorage.removeItem('admin_token'); localStorage.removeItem('admin_user'); ElMessage.success('已退出登录'); router.push('/') }
</script>

<style scoped>
.admin-layout { display: flex; min-height: calc(100vh - 64px); }
.admin-sidebar { width: 220px; background: var(--white); border-right: 1px solid var(--border); display: flex; flex-direction: column; flex-shrink: 0; }
.sidebar-header { padding: 20px; border-bottom: 1px solid var(--border); }
.sidebar-header h3 { font-size: 16px; }
.sidebar-menu { border-right: none; flex: 1; }
.sidebar-footer { padding: 16px; border-top: 1px solid var(--border); }
.admin-main { flex: 1; display: flex; flex-direction: column; background: var(--bg); }
.admin-topbar { display: flex; justify-content: space-between; align-items: center; padding: 16px 24px; background: var(--white); border-bottom: 1px solid var(--border); }
.admin-user { font-size: 14px; color: var(--text-light); }
.admin-content { padding: 24px; flex: 1; }
</style>
VUEEOF

# ========== src/views/admin/AttachmentManage.vue ==========
cat > src/views/admin/AttachmentManage.vue << 'VUEEOF'
<template>
  <div class="attachment-manage">
    <el-card shadow="never">
      <template #header><div class="card-header"><span>附件管理</span><el-button type="primary" @click="openDialog('add')"><el-icon><plus /></el-icon> 新增</el-button></div></template>
      <div class="query-bar">
        <el-select v-model="query.category" placeholder="所属类别" clearable style="width: 160px"><el-option label="文档中心" value="文档中心" /><el-option label="下载中心" value="下载中心" /></el-select>
        <el-input v-model="query.fileName" placeholder="请输入文件名" clearable style="width: 240px" />
        <el-button @click="resetQuery">重置</el-button>
        <el-button type="primary" @click="handleQuery">查询</el-button>
      </div>
      <el-table :data="tableData" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="category" label="所属类别" width="120" align="center" />
        <el-table-column prop="fileName" label="文件名称" min-width="200" />
        <el-table-column prop="updateTime" label="上传/修改时间" width="180" align="center" />
        <el-table-column label="操作" width="150" align="center" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="openDialog('edit', row)">修改</el-button>
            <el-popconfirm title="是否确认删除？" @confirm="handleDelete(row)"><template #reference><el-button type="danger" link>删除</el-button></template></el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap"><el-pagination v-model:current-page="currentPage" :page-size="pageSize" :page-sizes="[20, 50, 100]" :total="total" layout="total, sizes, prev, pager, next" background /></div>
    </el-card>
    <el-dialog v-model="dialogVisible" :title="dialogType === 'add' ? '新增' : '修改'" width="500px" :close-on-click-modal="false">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="所属类别" prop="category">
          <el-select v-model="form.category" placeholder="请选择" style="width: 100%"><el-option label="文档中心" value="文档中心" /><el-option label="下载中心" value="下载中心" /></el-select>
        </el-form-item>
        <el-form-item v-if="form.category === '下载中心'" label="语言类型" prop="langType">
          <el-select v-model="form.langType" placeholder="请选择" style="width: 100%"><el-option label="Java" value="Java" /><el-option label="PHP" value="PHP" /><el-option label="C#" value="C#" /></el-select>
        </el-form-item>
        <el-form-item label="文件名称" prop="fileName"><el-input v-model="form.fileName" placeholder="请输入" maxlength="100" show-word-limit /></el-form-item>
        <el-form-item label="附件"><el-upload action="#" :auto-upload="false" :limit="1" accept="*/*"><el-button type="primary">选择文件</el-button><template #tip><div class="upload-tip">支持任意格式，最大300MB</div></template></el-upload></el-form-item>
      </el-form>
      <template #footer><el-button @click="dialogVisible = false">取消</el-button><el-button type="primary" @click="handleSubmit">确定</el-button></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'

const query = reactive({ category: '', fileName: '' })
const currentPage = ref(1)
const pageSize = ref(20)
const allData = ref([
  { id: 1, category: '文档中心', fileName: '账户查询API文档_v2.1.pdf', langType: '', updateTime: '2026-04-08 10:30:00' },
  { id: 2, category: '文档中心', fileName: '转账接口文档_v2.0.pdf', langType: '', updateTime: '2026-04-06 16:45:00' },
  { id: 3, category: '下载中心', fileName: 'nbcx-sdk-java-2.1.0.jar', langType: 'Java', updateTime: '2026-04-08 09:00:00' },
  { id: 4, category: '下载中心', fileName: 'nbcx-sdk-php-1.5.0.tar.gz', langType: 'PHP', updateTime: '2026-04-06 14:00:00' }
])
const tableData = ref([...allData.value])
const total = ref(allData.value.length)

const dialogVisible = ref(false)
const dialogType = ref('add')
const formRef = ref()
const form = reactive({ id: null, category: '', fileName: '', langType: '' })
const rules = { category: [{ required: true, message: '请选择所属类别', trigger: 'change' }], fileName: [{ required: true, message: '请输入文件名称', trigger: 'blur' }] }

function openDialog(type, row) {
  dialogType.value = type
  if (type === 'edit' && row) Object.assign(form, { ...row })
  else Object.assign(form, { id: null, category: '', fileName: '', langType: '' })
  dialogVisible.value = true
}

async function handleSubmit() {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return
  const now = new Date().toLocaleString('zh-CN', { hour12: false }).replace(/\//g, '-')
  if (dialogType.value === 'add') {
    allData.value.push({ ...form, id: Math.max(...allData.value.map(d => d.id)) + 1, updateTime: now })
    ElMessage.success('附件信息新增成功！')
  } else {
    const idx = allData.value.findIndex(d => d.id === form.id)
    if (idx > -1) allData.value[idx] = { ...form, updateTime: now }
    ElMessage.success('附件信息修改成功！')
  }
  dialogVisible.value = false; handleQuery()
}

function handleDelete(row) { allData.value = allData.value.filter(d => d.id !== row.id); ElMessage.success('删除成功'); handleQuery() }
function handleQuery() { tableData.value = allData.value.filter(d => { if (query.category && d.category !== query.category) return false; if (query.fileName && !d.fileName.includes(query.fileName)) return false; return true }); total.value = tableData.value.length }
function resetQuery() { query.category = ''; query.fileName = ''; handleQuery() }
</script>

<style scoped>
.card-header { display: flex; justify-content: space-between; align-items: center; font-size: 16px; font-weight: 600; }
.query-bar { display: flex; gap: 12px; margin-bottom: 20px; align-items: center; }
.pagination-wrap { margin-top: 20px; display: flex; justify-content: flex-end; }
.upload-tip { color: var(--text-light); font-size: 12px; margin-top: 4px; }
</style>
VUEEOF

# ========== src/views/admin/UserManage.vue ==========
cat > src/views/admin/UserManage.vue << 'VUEEOF'
<template>
  <div class="user-manage">
    <el-card shadow="never">
      <template #header><span style="font-size: 16px; font-weight: 600">用户管理</span></template>
      <div class="query-bar">
        <el-select v-model="query.type" placeholder="类别" clearable multiple style="width: 200px"><el-option label="行内用户" value="行内用户" /><el-option label="企业用户" value="企业用户" /></el-select>
        <el-input v-model="query.username" placeholder="请输入用户名" clearable style="width: 240px" />
        <el-button @click="resetQuery">重置</el-button>
        <el-button type="primary" @click="handleQuery">查询</el-button>
      </div>
      <el-table :data="tableData" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="type" label="类别" width="120" align="center" />
        <el-table-column prop="username" label="用户名" min-width="160" />
        <el-table-column prop="role" label="角色" width="120" align="center" />
        <el-table-column prop="phone" label="联系电话" width="160" align="center" />
        <el-table-column prop="loginTime" label="最近登录" width="180" align="center" />
        <el-table-column label="操作" width="100" align="center" fixed="right">
          <template #default="{ row }"><el-button type="primary" link @click="openEdit(row)">修改</el-button></template>
        </el-table-column>
      </el-table>
      <div class="pagination-wrap"><el-pagination v-model:current-page="currentPage" :page-size="pageSize" :page-sizes="[20, 50, 100]" :total="total" layout="total, sizes, prev, pager, next" background /></div>
    </el-card>
    <el-dialog v-model="dialogVisible" title="修改" width="400px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="用户名"><el-input v-model="form.username" disabled /></el-form-item>
        <el-form-item label="角色"><el-select v-model="form.role" style="width: 100%"><el-option label="行内用户" value="行内用户" /></el-select></el-form-item>
      </el-form>
      <template #footer><el-button @click="dialogVisible = false">取消</el-button><el-button type="primary" @click="handleSubmit">确定</el-button></template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { mockUsers } from '../../utils/mock'

const query = reactive({ type: [], username: '' })
const currentPage = ref(1)
const pageSize = ref(20)
const allData = ref(mockUsers.map(u => ({ ...u })))
const tableData = ref([...allData.value])
const total = ref(allData.value.length)
const dialogVisible = ref(false)
const form = reactive({ id: null, username: '', role: '' })

function openEdit(row) { Object.assign(form, { id: row.id, username: row.username, role: row.role }); dialogVisible.value = true }
function handleSubmit() { const idx = allData.value.findIndex(d => d.id === form.id); if (idx > -1) allData.value[idx].role = form.role; ElMessage.success('修改成功'); dialogVisible.value = false; handleQuery() }
function handleQuery() { tableData.value = allData.value.filter(d => { if (query.type.length && !query.type.includes(d.type)) return false; if (query.username && !d.username.includes(query.username)) return false; return true }); total.value = tableData.value.length }
function resetQuery() { query.type = []; query.username = ''; handleQuery() }
</script>

<style scoped>
.query-bar { display: flex; gap: 12px; margin-bottom: 20px; align-items: center; }
.pagination-wrap { margin-top: 20px; display: flex; justify-content: flex-end; }
</style>
VUEEOF

# ========== src/views/admin/LogManage.vue ==========
cat > src/views/admin/LogManage.vue << 'VUEEOF'
<template>
  <div class="log-manage">
    <el-card shadow="never">
      <template #header><span style="font-size: 16px; font-weight: 600">操作日志</span></template>
      <div class="query-bar">
        <el-input v-model="query.user" placeholder="用户名" clearable style="width: 180px" />
        <el-select v-model="query.action" placeholder="操作类型" clearable style="width: 140px"><el-option label="登录" value="登录" /><el-option label="下载" value="下载" /><el-option label="浏览" value="浏览" /></el-select>
        <el-date-picker v-model="query.dateRange" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" style="width: 260px" />
        <el-button @click="resetQuery">重置</el-button>
        <el-button type="primary" @click="handleQuery">查询</el-button>
      </div>
      <el-table :data="tableData" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="user" label="用户名" width="140" />
        <el-table-column prop="action" label="操作" width="100" align="center">
          <template #default="{ row }"><el-tag :type="actionType(row.action)" size="small">{{ row.action }}</el-tag></template>
        </el-table-column>
        <el-table-column prop="target" label="操作对象" min-width="220" />
        <el-table-column prop="ip" label="IP地址" width="160" />
        <el-table-column prop="time" label="操作时间" width="180" align="center" />
      </el-table>
      <div class="pagination-wrap"><el-pagination v-model:current-page="currentPage" :page-size="pageSize" :total="total" layout="total, prev, pager, next" background /></div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { mockLogs } from '../../utils/mock'

const query = reactive({ user: '', action: '', dateRange: null })
const currentPage = ref(1)
const pageSize = ref(20)
const allData = ref(mockLogs.map(l => ({ ...l })))
const tableData = ref([...allData.value])
const total = ref(allData.value.length)

function actionType(action) { return { 登录: 'success', 下载: 'primary', 浏览: 'info' }[action] || '' }
function handleQuery() { tableData.value = allData.value.filter(d => { if (query.user && !d.user.includes(query.user)) return false; if (query.action && d.action !== query.action) return false; return true }); total.value = tableData.value.length }
function resetQuery() { query.user = ''; query.action = ''; query.dateRange = null; handleQuery() }
</script>

<style scoped>
.query-bar { display: flex; gap: 12px; margin-bottom: 20px; align-items: center; }
.pagination-wrap { margin-top: 20px; display: flex; justify-content: flex-end; }
</style>
VUEEOF

echo ""
echo "=========================================="
echo "✅ 项目创建完成！"
echo "=========================================="
echo ""
echo "下一步操作："
echo "  cd treasury-api-platform"
echo "  npm install"
echo "  npm run dev"
echo ""
echo "浏览器会自动打开 http://localhost:3000"
echo "=========================================="
