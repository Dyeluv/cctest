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
            <span class="user-name">
              👤 {{ store.username }}
              <el-icon><arrow-down /></el-icon>
            </span>
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
import { useUserStore } from '../../store'
import LoginDialog from '../ui/LoginDialog.vue'

const route = useRoute()
const store = useUserStore()
</script>

<style scoped>
.app-header {
  background: var(--white);
  border-bottom: 1px solid var(--border);
  position: sticky;
  top: 0;
  z-index: 1000;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
}
.header-inner {
  display: flex;
  align-items: center;
  height: 64px;
  gap: 40px;
}
.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}
.logo-icon { font-size: 24px; }
.logo-text {
  font-size: 16px;
  font-weight: 700;
  color: var(--primary);
}
.logo-divider { color: var(--border); font-size: 20px; }
.logo-sub { font-size: 14px; color: var(--text-light); }
.nav-links {
  display: flex;
  gap: 8px;
  flex: 1;
}
.nav-item {
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  color: var(--text);
  transition: all 0.2s;
}
.nav-item:hover, .nav-item.active {
  color: var(--primary);
  background: rgba(26, 86, 219, 0.06);
}
.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}
.user-name {
  cursor: pointer;
  font-size: 14px;
  color: var(--text);
  display: flex;
  align-items: center;
  gap: 4px;
}
.admin-link {
  font-size: 12px;
  color: var(--text-light);
  padding: 4px 8px;
  border: 1px solid var(--border);
  border-radius: 4px;
  transition: all 0.2s;
}
.admin-link:hover {
  color: var(--primary);
  border-color: var(--primary);
}
</style>
