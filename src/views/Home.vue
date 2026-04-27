<template>
  <div class="home-page">
    <!-- Hero -->
    <section class="hero">
      <div class="container">
        <el-carousel height="320px" :interval="4000" indicator-position="outside" arrow="always">
          <el-carousel-item v-for="b in banners" :key="b.id">
            <div class="banner-slide" :style="{ background: b.color }">
              <div class="banner-content">
                <h1>{{ b.title }}</h1>
                <p>{{ b.subtitle }}</p>
                <el-button type="primary" size="large" plain round>立即入驻</el-button>
              </div>
              <div class="banner-visual">🌐</div>
            </div>
          </el-carousel-item>
        </el-carousel>
      </div>
    </section>

    <!-- API介绍 -->
    <section class="intro-section">
      <div class="container">
        <div class="intro-card">
          <h2>财资开放API</h2>
          <p>提供标准化的访问接口，帮助合作伙伴快速接入财资开放平台</p>
        </div>
      </div>
    </section>

    <!-- 产品模块 -->
    <section class="products-section">
      <div class="container">
        <h2 class="section-title">产品模块</h2>
        <p class="section-desc">覆盖企业财资管理全场景</p>
        <div class="products-grid">
          <router-link
            v-for="p in productModules"
            :key="p.id"
            :to="p.route"
            class="product-card card-hover"
          >
            <div class="product-icon">{{ p.icon }}</div>
            <h3>{{ p.name }}</h3>
            <p>{{ p.desc }}</p>
          </router-link>
        </div>
      </div>
    </section>

    <!-- 接入流程 -->
    <section class="flow-section">
      <div class="container">
        <h2 class="section-title">接入流程</h2>
        <p class="section-desc">六步快速接入，轻松开启数字金融之旅</p>
        <div class="flow-steps">
          <div v-for="(s, i) in onboardSteps" :key="s.step" class="flow-step">
            <div class="step-icon">{{ s.icon }}</div>
            <div class="step-num">Step {{ s.step }}</div>
            <h4>{{ s.title }}</h4>
            <p>{{ s.desc }}</p>
            <div v-if="i < onboardSteps.length - 1" class="step-arrow">→</div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="cta-section">
      <div class="container">
        <div class="cta-card">
          <h2>准备好了吗？</h2>
          <p>立即开始对接，享受高效便捷的财资API服务</p>
          <el-button type="primary" size="large" round @click="$router.push('/docs')">
            查看文档 →
          </el-button>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { banners, productModules, onboardSteps } from '../../mocks/index'
</script>

<style scoped>
/* Hero */
.hero {
  padding: 40px 0 0;
}
.banner-slide {
  height: 100%;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 80px;
  color: white;
  overflow: hidden;
}
.banner-content h1 {
  font-size: 36px;
  font-weight: 700;
  margin-bottom: 12px;
}
.banner-content p {
  font-size: 18px;
  opacity: 0.9;
  margin-bottom: 28px;
}
.banner-visual {
  font-size: 120px;
  opacity: 0.3;
}

/* Intro */
.intro-section {
  padding: 60px 0 20px;
}
.intro-card {
  text-align: center;
  padding: 40px;
  background: linear-gradient(135deg, #f0f4ff 0%, #e8f0fe 100%);
  border-radius: 16px;
}
.intro-card h2 {
  font-size: 24px;
  color: var(--primary);
  margin-bottom: 8px;
}
.intro-card p {
  color: var(--text-light);
  font-size: 16px;
}

/* Products */
.products-section {
  padding: 60px 0;
}
.products-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}
.product-card {
  background: var(--white);
  border-radius: 12px;
  padding: 28px 20px;
  text-align: center;
  border: 1px solid var(--border);
}
.product-icon {
  font-size: 40px;
  margin-bottom: 12px;
}
.product-card h3 {
  font-size: 16px;
  margin-bottom: 8px;
  color: var(--text);
}
.product-card p {
  font-size: 13px;
  color: var(--text-light);
  line-height: 1.5;
}

/* Flow */
.flow-section {
  padding: 60px 0;
  background: var(--white);
}
.flow-steps {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  gap: 8px;
  flex-wrap: wrap;
}
.flow-step {
  text-align: center;
  width: 160px;
  position: relative;
}
.step-icon {
  font-size: 40px;
  margin-bottom: 8px;
}
.step-num {
  font-size: 12px;
  color: var(--primary);
  font-weight: 600;
  margin-bottom: 4px;
}
.flow-step h4 {
  font-size: 15px;
  margin-bottom: 4px;
}
.flow-step p {
  font-size: 12px;
  color: var(--text-light);
}
.step-arrow {
  position: absolute;
  right: -20px;
  top: 30px;
  font-size: 20px;
  color: var(--primary-light);
  font-weight: bold;
}

/* CTA */
.cta-section {
  padding: 60px 0;
}
.cta-card {
  text-align: center;
  padding: 60px;
  background: linear-gradient(135deg, #1a3a8a 0%, #1a56db 100%);
  border-radius: 20px;
  color: white;
}
.cta-card h2 {
  font-size: 32px;
  margin-bottom: 12px;
}
.cta-card p {
  font-size: 16px;
  opacity: 0.9;
  margin-bottom: 28px;
}

@media (max-width: 900px) {
  .products-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .banner-slide {
    padding: 0 32px;
  }
  .step-arrow {
    display: none;
  }
}
</style>
