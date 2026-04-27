<template>
  <div class="log-manage">
    <el-card shadow="never">
      <template #header>
        <span style="font-size: 16px; font-weight: 600">操作日志</span>
      </template>

      <div class="query-bar">
        <el-input v-model="query.user" placeholder="用户名" clearable style="width: 180px" />
        <el-select v-model="query.action" placeholder="操作类型" clearable style="width: 140px">
          <el-option label="登录" value="登录" />
          <el-option label="下载" value="下载" />
          <el-option label="浏览" value="浏览" />
        </el-select>
        <el-date-picker
          v-model="query.dateRange"
          type="daterange"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          style="width: 260px"
        />
        <el-button @click="resetQuery">重置</el-button>
        <el-button type="primary" @click="handleQuery">查询</el-button>
      </div>

      <el-table :data="tableData" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="user" label="用户名" width="140" />
        <el-table-column prop="action" label="操作" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="actionType(row.action)" size="small">{{ row.action }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="target" label="操作对象" min-width="220" />
        <el-table-column prop="ip" label="IP地址" width="160" />
        <el-table-column prop="time" label="操作时间" width="180" align="center" />
      </el-table>

      <div class="pagination-wrap">
        <el-pagination
          v-model:current-page="currentPage"
          :page-size="pageSize"
          :total="total"
          layout="total, prev, pager, next"
          background
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { mockLogs } from '../../../mocks/index'

const query = reactive({ user: '', action: '', dateRange: null })
const currentPage = ref(1)
const pageSize = ref(20)

const allData = ref(mockLogs.map(l => ({ ...l })))
const tableData = ref([...allData.value])
const total = ref(allData.value.length)

function actionType(action) {
  const map = { 登录: 'success', 下载: 'primary', 浏览: 'info' }
  return map[action] || ''
}

function handleQuery() {
  tableData.value = allData.value.filter(d => {
    if (query.user && !d.user.includes(query.user)) return false
    if (query.action && d.action !== query.action) return false
    return true
  })
  total.value = tableData.value.length
}

function resetQuery() {
  query.user = ''
  query.action = ''
  query.dateRange = null
  handleQuery()
}
</script>

<style scoped>
.query-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  align-items: center;
}
.pagination-wrap {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
