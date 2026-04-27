<template>
  <footer class="app-footer">
    <div class="container">
      <div class="footer-links">
        <a href="#">关于我们</a>
        <a href="#">服务协议</a>
        <a href="#">隐私政策</a>
        <a href="#">联系方式</a>
      </div>
      <div class="footer-copy">
        © 2026 宁波银行股份有限公司 版权所有
      </div>
    </div>
  </footer>
</template>

<style scoped>
.app-footer {
  background: #1f2937;
  color: #9ca3af;
  padding: 32px 0;
  text-align: center;
  margin-top: 80px;
}
.footer-links {
  display: flex;
  justify-content: center;
  gap: 24px;
  margin-bottom: 16px;
}
.footer-links a {
  color: #9ca3af;
  font-size: 14px;
  transition: color 0.2s;
}
.footer-links a:hover {
  color: #fff;
}
.footer-copy {
  font-size: 13px;
}
</style>
