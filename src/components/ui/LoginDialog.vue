<template>
  <el-dialog
    v-model="store.showLoginDialog"
    title="用户登录"
    width="420px"
    :close-on-click-modal="false"
    class="login-dialog"
  >
    <p class="login-subtitle">欢迎使用财资API开放平台</p>

    <el-form ref="formRef" :model="form" :rules="rules" label-position="top">
      <el-form-item label="用户名" prop="username">
        <el-input v-model="form.username" placeholder="请输入用户名（工号）" prefix-icon="User" size="large" />
      </el-form-item>

      <el-form-item label="密码" prop="password">
        <el-input v-model="form.password" type="password" placeholder="请输入密码" prefix-icon="Lock" size="large" show-password>
          <template #append>
            <el-button @click="getVerifyCode" :disabled="countdown > 0">
              {{ countdown > 0 ? `${countdown}秒后重新获取` : '获取验证码' }}
            </el-button>
          </template>
        </el-input>
      </el-form-item>

      <el-form-item prop="captcha">
        <SliderCaptcha ref="captchaRef" @success="onCaptchaSuccess" />
        <div v-if="captchaError" class="captcha-error">请进行滑块校验</div>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" size="large" style="width: 100%" @click="handleLogin" :loading="loading">
          立即登录
        </el-button>
      </el-form-item>
    </el-form>
  </el-dialog>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { useUserStore } from '../../store'
import SliderCaptcha from './SliderCaptcha.vue'

const store = useUserStore()
const formRef = ref()
const captchaRef = ref()
const loading = ref(false)
const countdown = ref(0)
const captchaPassed = ref(false)
const captchaError = ref(false)

const form = reactive({
  username: '',
  password: ''
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

function getVerifyCode() {
  if (!form.username) {
    ElMessage.warning('请先输入用户名')
    return
  }
  ElMessage.success('验证码已发送（模拟）')
  countdown.value = 60
  const timer = setInterval(() => {
    countdown.value--
    if (countdown.value <= 0) clearInterval(timer)
  }, 1000)
}

function onCaptchaSuccess() {
  captchaPassed.value = true
  captchaError.value = false
}

async function handleLogin() {
  captchaError.value = !captchaPassed.value
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return
  if (!captchaPassed.value) return

  loading.value = true
  setTimeout(() => {
    loading.value = false
    // 模拟：任何用户名密码都可登录
    store.login(form.username)
    ElMessage.success('登录成功！')
    form.username = ''
    form.password = ''
    captchaPassed.value = false
    captchaRef.value?.reset()
  }, 800)
}
</script>

<style scoped>
.login-subtitle {
  text-align: center;
  color: var(--text-light);
  font-size: 14px;
  margin-bottom: 24px;
  margin-top: -8px;
}
.captcha-error {
  color: #f56c6c;
  font-size: 12px;
  margin-top: 4px;
}
</style>
