<template>
  <div class="captcha-container">
    <div class="captcha-track" ref="trackRef">
      <div class="captcha-bg">
        <div class="captcha-hole" :style="{ left: holeX + 'px' }"></div>
      </div>
      <div
        class="captcha-slider"
        :class="{ 'captcha-success': passed }"
        :style="{ left: sliderX + 'px' }"
        @mousedown.prevent="startDrag"
        @touchstart.prevent="startDrag"
      >
        <span class="slider-icon">{{ passed ? '✓' : '⟩' }}</span>
      </div>
      <div class="captcha-text">{{ passed ? '验证通过' : '请拖动滑块完成验证' }}</div>
      <el-icon class="captcha-refresh" @click="reset"><refresh /></el-icon>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const emit = defineEmits(['success'])

const trackRef = ref()
const holeX = ref(0)
const sliderX = ref(0)
const passed = ref(false)
let dragging = false
let startX = 0

const HOLE_SIZE = 40
const TRACK_WIDTH = 360

function randomHole() {
  holeX.value = 100 + Math.random() * (TRACK_WIDTH - HOLE_SIZE - 150)
}

function startDrag(e) {
  if (passed.value) return
  dragging = true
  startX = (e.touches ? e.touches[0].clientX : e.clientX) - sliderX.value
  document.addEventListener('mousemove', onDrag)
  document.addEventListener('mouseup', endDrag)
  document.addEventListener('touchmove', onDrag)
  document.addEventListener('touchend', endDrag)
}

function onDrag(e) {
  if (!dragging) return
  const clientX = e.touches ? e.touches[0].clientX : e.clientX
  let x = clientX - startX
  x = Math.max(0, Math.min(x, TRACK_WIDTH - 44))
  sliderX.value = x
}

function endDrag() {
  dragging = false
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', endDrag)
  document.removeEventListener('touchmove', onDrag)
  document.removeEventListener('touchend', endDrag)

  // 校验：偏移在±5px范围内
  const diff = Math.abs(sliderX.value - holeX.value)
  if (diff < 8) {
    passed.value = true
    sliderX.value = holeX.value
    emit('success')
  } else {
    // 失败回弹
    const step = sliderX.value > 0 ? 1 : 0
    const interval = setInterval(() => {
      sliderX.value -= 5
      if (sliderX.value <= 0) {
        sliderX.value = 0
        clearInterval(interval)
      }
    }, 10)
  }
}

function reset() {
  passed.value = false
  sliderX.value = 0
  randomHole()
}

onMounted(() => {
  randomHole()
})

defineExpose({ reset })
</script>

<style scoped>
.captcha-container {
  width: 100%;
}
.captcha-track {
  position: relative;
  height: 44px;
  background: #f0f0f0;
  border-radius: 22px;
  overflow: hidden;
  user-select: none;
}
.captcha-bg {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: #e8e8e8;
}
.captcha-hole {
  position: absolute;
  top: 2px;
  width: 40px;
  height: 40px;
  background: #fff;
  border-radius: 4px;
  box-shadow: inset 0 0 6px rgba(0,0,0,0.15);
}
.captcha-slider {
  position: absolute;
  top: 2px;
  left: 0;
  width: 44px;
  height: 40px;
  background: var(--primary);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: grab;
  z-index: 2;
  transition: background 0.2s;
}
.captcha-slider.captcha-success {
  background: #67c23a;
  cursor: default;
}
.slider-icon {
  color: #fff;
  font-size: 18px;
  font-weight: bold;
}
.captcha-text {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #999;
  font-size: 13px;
  z-index: 1;
}
.captcha-refresh {
  position: absolute;
  right: 12px;
  top: 50%;
  transform: translateY(-50%);
  cursor: pointer;
  color: #999;
  z-index: 3;
  transition: color 0.2s;
}
.captcha-refresh:hover {
  color: var(--primary);
}
</style>
