<template>
  <div class="user-manage">
    <el-card shadow="never">
      <template #header>
        <span style="font-size: 16px; font-weight: 600">用户管理</span>
      </template>

      <div class="query-bar">
        <el-select v-model="query.type" placeholder="类别" clearable multiple style="width: 200px">
          <el-option label="行内用户" value="行内用户" />
          <el-option label="企业用户" value="企业用户" />
        </el-select>
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
          <template #default="{ row }">
            <el-button type="primary" link @click="openEdit(row)">修改</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination-wrap">
        <el-pagination
          v-model:current-page="currentPage"
          :page-size="pageSize"
          :page-sizes="[20, 50, 100]"
          :total="total"
          layout="total, sizes, prev, pager, next"
          background
        />
      </div>
    </el-card>

    <!-- 修改弹窗 -->
    <el-dialog v-model="dialogVisible" title="修改" width="400px">
      <el-form :model="form" label-width="80px">
        <el-form-item label="用户名">
          <el-input v-model="form.username" disabled />
        </el-form-item>
        <el-form-item label="角色">
          <el-select v-model="form.role" style="width: 100%">
            <el-option label="行内用户" value="行内用户" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { mockUsers } from '../../../mocks/index'

const query = reactive({ type: [], username: '' })
const currentPage = ref(1)
const pageSize = ref(20)

const allData = ref(mockUsers.map(u => ({ ...u })))
const tableData = ref([...allData.value])
const total = ref(allData.value.length)

const dialogVisible = ref(false)
const form = reactive({ id: null, username: '', role: '' })

function openEdit(row) {
  Object.assign(form, { id: row.id, username: row.username, role: row.role })
  dialogVisible.value = true
}

function handleSubmit() {
  const idx = allData.value.findIndex(d => d.id === form.id)
  if (idx > -1) {
    allData.value[idx].role = form.role
  }
  ElMessage.success('修改成功')
  dialogVisible.value = false
  handleQuery()
}

function handleQuery() {
  tableData.value = allData.value.filter(d => {
    if (query.type.length && !query.type.includes(d.type)) return false
    if (query.username && !d.username.includes(query.username)) return false
    return true
  })
  total.value = tableData.value.length
}

function resetQuery() {
  query.type = []
  query.username = ''
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
