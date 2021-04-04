import {Environment, env} from "./constants"


const TOKEN_KEY = 'suum-auth-token'
const getStorage = (ENV: string | undefined): Storage => ENV === Environment.PRODUCTION ? window.sessionStorage : window.localStorage

export const getToken = () => {
  const storage = getStorage(env?.ENVIRONMENT)
  return storage.getItem(TOKEN_KEY)
}

export const setToken = (token: string) => {
  const storage = getStorage(env?.ENVIRONMENT)
  storage.setItem(TOKEN_KEY, token)
}
