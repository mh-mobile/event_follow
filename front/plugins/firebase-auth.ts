import {
  defineNuxtPlugin,
  onGlobalSetup,
  onUnmounted,
  ref,
  provide
} from '@nuxtjs/composition-api'

import firebase from 'firebase/app'
import 'firebase/auth'
import { CurrentUser } from '~/compositions/user'

export default defineNuxtPlugin(async (context, inject) => {
  const currentUser = ref<User | null>(null)
  inject('currentUser', currentUser)

  const unsubscribe: any = await new Promise((resolve) => {
    const unsubscribe = firebase.auth().onAuthStateChanged((user) => {
      if (!user) {
        currentUser.value = null
      } else {
        currentUser.value = {
          displayName: user.displayName!
        }
      }
      resolve(unsubscribe)
    })
  })

  onGlobalSetup(() => {
    provide(CurrentUser, currentUser)
    onUnmounted(unsubscribe)
  })
})
