import { defineStore } from 'pinia'
import { ref } from 'vue'
import { createClient } from '@supabase/supabase-js'

export const useUserSessionStore = defineStore('userSession', () => {
  const loggedIn = ref(false);
  const openLogWindow = ref(false);
  const openChangeWindow = ref(false)
  // Действия для управления состоянием
  const setLoggedIn = (value) => {
    loggedIn.value = value;
  };
  const setOpenLogWindow = (value) => {
    openLogWindow.value = value;
  };
  const setOpenChangeWindow = (value) => {
    openLogWindow.value = value;
  };
  return { loggedIn, setLoggedIn, openLogWindow, setOpenLogWindow, openChangeWindow, setOpenChangeWindow};
});
export const supabase = createClient(import.meta.env.VITE_SUPABASE_URL, import.meta.env.VITE_SUPABASE_KEY)

