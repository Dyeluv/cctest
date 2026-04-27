<template>
  <div class="admin-login-page">
    <div class="login-card">
      <div class="login-header">
        <h2>管理端登录</h2>
        <p>财资API开放平台 · 后台管理</p>
      </div>

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
          <el-button type="primary" size="large" style="width: 100%" @click="handleLogin" :loading="loading">
            立即登录
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import SliderCaptcha from '../../components/ui/SliderCaptcha.vue'

const router = useRouter()
const formRef = ref()
const captchaRef = ref()
const loading = ref(false)
const captchaPassed = ref(false)
const captchaError = ref(false)

const form = reactive({ username: '', password: '' })
const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

async function handleLogin() {
  captchaError.value = !captchaPassed.value
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid || !captchaPassed.value) return

  loading.value = true
  setTimeout(() => {
    loading.value = false
    localStorage.setItem('admin_token', 'true')
    localStorage.setItem('admin_user', form.username)
    ElMessage.success('登录成功！')
    router.push('/admin/attachments')
  }, 600)
}
</script>

<style scoped>
.admin-login-page {
  min-height: calc(100vh - 120px);
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f0f4ff 0%, #e8f0fe 100%);
}
.login-card {
  width: 440px;
  background: var(--white);
  border-radius: 16px;
  padding: 40px;
  box-shadow: var(--shadow-lg);
}
.login-header {
  text-align: center;
  margin-bottom: 32px;
}
.login-header h2 {
  font-size: 24px;
  color: var(--text);
  margin-bottom: 8px;
}
.login-header p {
  font-size: 14px;
  color: var(--text-light);
}
.captcha-error {
  color: #f56c6c;
  font-size: 12px;
  margin-top: 4px;
}
</style>
