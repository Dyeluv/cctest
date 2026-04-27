<template>
  <div class="attachment-manage">
    <el-card shadow="never">
      <template #header>
        <div class="card-header">
          <span>附件管理</span>
          <el-button type="primary" @click="openDialog('add')">
            <el-icon><plus /></el-icon> 新增
          </el-button>
        </div>
      </template>

      <!-- 查询区 -->
      <div class="query-bar">
        <el-select v-model="query.category" placeholder="所属类别" clearable style="width: 160px">
          <el-option label="文档中心" value="文档中心" />
          <el-option label="下载中心" value="下载中心" />
        </el-select>
        <el-input v-model="query.fileName" placeholder="请输入文件名" clearable style="width: 240px" />
        <el-button @click="resetQuery">重置</el-button>
        <el-button type="primary" @click="handleQuery">查询</el-button>
      </div>

      <!-- 表格 -->
      <el-table :data="tableData" stripe border>
        <el-table-column type="index" label="序号" width="60" align="center" />
        <el-table-column prop="category" label="所属类别" width="120" align="center" />
        <el-table-column prop="fileName" label="文件名称" min-width="200" />
        <el-table-column prop="updateTime" label="上传/修改时间" width="180" align="center" />
        <el-table-column label="操作" width="150" align="center" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="openDialog('edit', row)">修改</el-button>
            <el-popconfirm title="是否确认删除？" @confirm="handleDelete(row)">
              <template #reference>
                <el-button type="danger" link>删除</el-button>
              </template>
            </el-popconfirm>
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

    <!-- 新增/修改弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增' : '修改'"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="所属类别" prop="category">
          <template v-if="form.category === '文档中心' || dialogType === 'add'">
            <el-select v-model="form.category" placeholder="请选择" style="width: 100%">
              <el-option label="文档中心" value="文档中心" />
              <el-option label="下载中心" value="下载中心" />
            </el-select>
          </template>
        </el-form-item>

        <el-form-item v-if="form.category === '下载中心'" label="语言类型" prop="langType">
          <el-select v-model="form.langType" placeholder="请选择" style="width: 100%">
            <el-option label="Java" value="Java" />
            <el-option label="PHP" value="PHP" />
            <el-option label="C#" value="C#" />
          </el-select>
        </el-form-item>

        <el-form-item label="文件名称" prop="fileName">
          <el-input v-model="form.fileName" placeholder="请输入" maxlength="100" show-word-limit />
        </el-form-item>

        <el-form-item label="附件">
          <el-upload
            action="#"
            :auto-upload="false"
            :limit="1"
            accept="*/*"
          >
            <el-button type="primary">选择文件</el-button>
            <template #tip>
              <div class="upload-tip">支持任意格式，最大300MB</div>
            </template>
          </el-upload>
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

const query = reactive({ category: '', fileName: '' })
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(4)

// 模拟数据
const allData = ref([
  { id: 1, category: '文档中心', fileName: '账户查询API文档_v2.1.pdf', langType: '', updateTime: '2026-04-08 10:30:00' },
  { id: 2, category: '文档中心', fileName: '转账接口文档_v2.0.pdf', langType: '', updateTime: '2026-04-06 16:45:00' },
  { id: 3, category: '下载中心', fileName: 'nbcx-sdk-java-2.1.0.jar', langType: 'Java', updateTime: '2026-04-08 09:00:00' },
  { id: 4, category: '下载中心', fileName: 'nbcx-sdk-php-1.5.0.tar.gz', langType: 'PHP', updateTime: '2026-04-06 14:00:00' }
])

const tableData = ref([...allData.value])

const dialogVisible = ref(false)
const dialogType = ref('add')
const formRef = ref()
const form = reactive({ id: null, category: '', fileName: '', langType: '' })
const rules = {
  category: [{ required: true, message: '请选择所属类别', trigger: 'change' }],
  fileName: [{ required: true, message: '请输入文件名称', trigger: 'blur' }]
}

function openDialog(type, row) {
  dialogType.value = type
  if (type === 'edit' && row) {
    Object.assign(form, { ...row })
  } else {
    Object.assign(form, { id: null, category: '', fileName: '', langType: '' })
  }
  dialogVisible.value = true
}

async function handleSubmit() {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  if (dialogType.value === 'add') {
    const newId = Math.max(...allData.value.map(d => d.id)) + 1
    allData.value.push({
      ...form,
      id: newId,
      updateTime: new Date().toLocaleString('zh-CN', { hour12: false }).replace(/\//g, '-')
    })
    ElMessage.success('附件信息新增成功！')
  } else {
    const idx = allData.value.findIndex(d => d.id === form.id)
    if (idx > -1) {
      allData.value[idx] = { ...form, updateTime: new Date().toLocaleString('zh-CN', { hour12: false }).replace(/\//g, '-') }
    }
    ElMessage.success('附件信息修改成功！')
  }
  dialogVisible.value = false
  handleQuery()
}

function handleDelete(row) {
  allData.value = allData.value.filter(d => d.id !== row.id)
  ElMessage.success('删除成功')
  handleQuery()
}

function handleQuery() {
  tableData.value = allData.value.filter(d => {
    if (query.category && d.category !== query.category) return false
    if (query.fileName && !d.fileName.includes(query.fileName)) return false
    return true
  })
  total.value = tableData.value.length
}

function resetQuery() {
  query.category = ''
  query.fileName = ''
  handleQuery()
}
</script>

<style scoped>
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 16px;
  font-weight: 600;
}
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
.upload-tip {
  color: var(--text-light);
  font-size: 12px;
  margin-top: 4px;
}
</style>
