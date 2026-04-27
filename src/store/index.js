import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useUserStore = defineStore('user', () => {
  const isLoggedIn = ref(false)
  const username = ref('')
  const showLoginDialog = ref(false)

  function login(name) {
    isLoggedIn.value = true
    username.value = name
    showLoginDialog.value = false
  }

  function logout() {
    isLoggedIn.value = false
    username.value = ''
  }

  function openLogin() {
    showLoginDialog.value = true
  }

  return { isLoggedIn, username, showLoginDialog, login, logout, openLogin }
})
