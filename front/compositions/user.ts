import { InjectionKey, Ref, inject } from '@nuxtjs/composition-api'

export const CurrentUser: InjectionKey<Ref<User | null>> = Symbol()

export const useCurrentUser = () => {
  const currentUser = inject(CurrentUser)
  if (currentUser === undefined) {
    throw new Error('currentUser is not provided')
  }

  return {
    currentUser
  }
}
