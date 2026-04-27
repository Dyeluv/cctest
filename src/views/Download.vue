<template>
  <div class="download-page">
    <div class="page-hero hero-gradient">
      <div class="container">
        <h1>下载中心</h1>
        <p>帮助您快速了解财资开放平台对接方式，并提供Demo等</p>
      </div>
    </div>

    <div class="container download-body">
      <el-tabs v-model="activeLang" type="border-card" class="lang-tabs">
        <el-tab-pane v-for="(items, lang) in downloads" :key="lang" :label="lang" :name="lang">
          <div class="download-cards">
            <div
              v-for="item in items"
              :key="item.id"
              class="download-card card-hover"
              @click="handleDownload(item)"
            >
              <div class="card-icon">
                {{ langIcon(lang) }}
              </div>
              <div class="card-info">
                <h3>{{ item.name }}</h3>
                <p>{{ item.desc }}</p>
                <div class="card-meta">
                  <span class="file-name">{{ item.fileName }}</span>
                  <span class="update-time">更新: {{ item.updateTime }}</span>
                </div>
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
import { getMockDownloads } from '../../mocks/index'
import { useUserStore } from '../store'

const store = useUserStore()
const downloads = getMockDownloads()
const activeLang = ref('Java')

function langIcon(lang) {
  const icons = { Java: '☕', PHP: '🐘', 'C#': '🔷' }
  return icons[lang] || '📦'
}

function handleDownload(item) {
  if (!store.isLoggedIn) {
    store.openLogin()
    return
  }
  ElMessage.success(`正在下载：${item.fileName}（模拟）`)
}
</script>

<style scoped>
.page-hero {
  padding: 48px 0;
  text-align: center;
}
.page-hero h1 {
  font-size: 32px;
  margin-bottom: 8px;
}
.page-hero p {
  font-size: 16px;
  opacity: 0.85;
}
.download-body {
  padding: 32px 24px;
}
.lang-tabs {
  border-radius: 12px;
}
.download-cards {
  display: flex;
  flex-direction: column;
  gap: 16px;
  padding: 8px 0;
}
.download-card {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 20px 24px;
  background: var(--white);
  border-radius: 12px;
  border: 1px solid var(--border);
}
.card-icon {
  font-size: 40px;
  flex-shrink: 0;
}
.card-info {
  flex: 1;
}
.card-info h3 {
  font-size: 16px;
  margin-bottom: 4px;
}
.card-info p {
  font-size: 13px;
  color: var(--text-light);
  margin-bottom: 6px;
}
.card-meta {
  display: flex;
  gap: 16px;
  font-size: 12px;
  color: var(--text-light);
}
.file-name {
  background: #f3f4f6;
  padding: 2px 8px;
  border-radius: 4px;
}
.download-icon {
  font-size: 24px;
  color: var(--primary);
  flex-shrink: 0;
}
</style>
