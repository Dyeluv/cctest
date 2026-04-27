import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue')
  },
  {
    path: '/docs',
    name: 'Docs',
    component: () => import('../views/Docs.vue')
  },
  {
    path: '/download',
    name: 'Download',
    component: () => import('../views/Download.vue')
  },
  {
    path: '/admin/login',
    name: 'AdminLogin',
    component: () => import('../views/admin/AdminLogin.vue')
  },
  {
    path: '/admin',
    name: 'Admin',
    component: () => import('../views/admin/AdminLayout.vue'),
    meta: { requiresAdmin: true },
    children: [
      {
        path: 'attachments',
        name: 'Attachments',
        component: () => import('../views/admin/AttachmentManage.vue')
      },
      {
        path: 'users',
        name: 'Users',
        component: () => import('../views/admin/UserManage.vue')
      },
      {
        path: 'logs',
        name: 'Logs',
        component: () => import('../views/admin/LogManage.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior() {
    return { top: 0 }
  }
})

router.beforeEach((to, from, next) => {
  if (to.meta.requiresAdmin) {
    const isAdmin = localStorage.getItem('admin_token')
    if (!isAdmin) {
      next({ name: 'AdminLogin' })
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
