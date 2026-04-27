<template>
  <div class="admin-layout">
    <aside class="admin-sidebar">
      <div class="sidebar-header">
        <h3>📋 后台管理</h3>
      </div>
      <el-menu
        :default-active="route.path"
        router
        class="sidebar-menu"
      >
        <el-menu-item index="/admin/attachments">
          <el-icon><folder /></el-icon>
          <span>附件管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/users">
          <el-icon><user /></el-icon>
          <span>用户管理</span>
        </el-menu-item>
        <el-menu-item index="/admin/logs">
          <el-icon><document /></el-icon>
          <span>操作日志</span>
        </el-menu-item>
      </el-menu>
      <div class="sidebar-footer">
        <el-button text @click="handleLogout">
          <el-icon><switch-button /></el-icon>
          退出登录
        </el-button>
      </div>
    </aside>
    <main class="admin-main">
      <div class="admin-topbar">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item>管理端</el-breadcrumb-item>
          <el-breadcrumb-item>{{ currentTitle }}</el-breadcrumb-item>
        </el-breadcrumb>
        <span class="admin-user">👤 {{ adminUser }}</span>
      </div>
      <div class="admin-content">
        <router-view />
      </div>
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

const titleMap = {
  '/admin/attachments': '附件管理',
  '/admin/users': '用户管理',
  '/admin/logs': '操作日志'
}
const currentTitle = computed(() => titleMap[route.path] || '管理')

function handleLogout() {
  localStorage.removeItem('admin_token')
  localStorage.removeItem('admin_user')
  ElMessage.success('已退出登录')
  router.push('/')
}
</script>

<style scoped>
.admin-layout {
  display: flex;
  min-height: calc(100vh - 64px);
}
.admin-sidebar {
  width: 220px;
  background: var(--white);
  border-right: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  flex-shrink: 0;
}
.sidebar-header {
  padding: 20px;
  border-bottom: 1px solid var(--border);
}
.sidebar-header h3 {
  font-size: 16px;
}
.sidebar-menu {
  border-right: none;
  flex: 1;
}
.sidebar-footer {
  padding: 16px;
  border-top: 1px solid var(--border);
}
.admin-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: var(--bg);
}
.admin-topbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 24px;
  background: var(--white);
  border-bottom: 1px solid var(--border);
}
.admin-user {
  font-size: 14px;
  color: var(--text-light);
}
.admin-content {
  padding: 24px;
  flex: 1;
}
</style>
