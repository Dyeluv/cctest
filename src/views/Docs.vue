<template>
  <div class="docs-page">
    <div class="page-hero hero-gradient">
      <div class="container">
        <h1>文档中心</h1>
        <p>按类别浏览和下载API接口文档</p>
      </div>
    </div>

    <div class="container docs-body">
      <!-- 搜索栏 -->
      <div class="docs-toolbar">
        <el-input
          v-model="searchKey"
          placeholder="请输入关键词进行搜索"
          prefix-icon="Search"
          size="large"
          clearable
          @keyup.enter="handleSearch"
          style="max-width: 400px"
        />
        <el-button type="primary" size="large" @click="batchDownload">
          <el-icon><download /></el-icon>
          一键下载
        </el-button>
      </div>

      <!-- 分类标签 -->
      <div class="category-tabs">
        <el-radio-group v-model="activeCategory" size="large">
          <el-radio-button value="">全部文档</el-radio-button>
          <el-radio-button v-for="c in docCategories" :key="c.key" :value="c.key">
            {{ c.label }}
          </el-radio-button>
        </el-radio-group>
      </div>

      <!-- 文档列表 -->
      <div class="docs-list">
        <el-table :data="filteredDocs" stripe style="width: 100%">
          <el-table-column type="index" label="序号" width="60" />
          <el-table-column prop="title" label="文档名称" min-width="260" />
          <el-table-column prop="fileName" label="文件名" min-width="240" />
          <el-table-column prop="updateTime" label="更新时间" width="180" />
          <el-table-column label="操作" width="100" fixed="right">
            <template #default="{ row }">
              <el-button type="primary" link size="small" @click="handleDownload(row)">
                <el-icon><download /></el-icon> 下载
              </el-button>
            </template>
          </el-table-column>
        </el-table>

        <div class="docs-pagination">
          <el-pagination
            v-model:current-page="currentPage"
            :page-size="10"
            :total="filteredDocs.length"
            layout="total, prev, pager, next"
            background
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { docCategories, getMockDocs } from '../../mocks/index'
import { useUserStore } from '../store'

const store = useUserStore()
const searchKey = ref('')
const activeCategory = ref('')
const currentPage = ref(1)

const filteredDocs = computed(() => {
  let docs = getMockDocs(activeCategory.value || null)
  if (searchKey.value) {
    const key = searchKey.value.toLowerCase()
    docs = docs.filter(d =>
      d.title.toLowerCase().includes(key) || d.fileName.toLowerCase().includes(key)
    )
  }
  return docs
})

function handleSearch() {
  currentPage.value = 1
}

function handleDownload(row) {
  if (!store.isLoggedIn) {
    store.openLogin()
    return
  }
  ElMessage.success(`正在下载：${row.fileName}（模拟）`)
}

function batchDownload() {
  if (!store.isLoggedIn) {
    store.openLogin()
    return
  }
  ElMessage.success('正在打包下载：财资API开放平台接入手册.zip（模拟）')
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
.docs-body {
  padding: 32px 24px;
}
.docs-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}
.category-tabs {
  margin-bottom: 24px;
}
.docs-pagination {
  margin-top: 24px;
  display: flex;
  justify-content: flex-end;
}
</style>
