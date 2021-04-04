import React from "react"
import {getToken, setToken} from "../token"

interface Hook {
  token: string | undefined
  get: () => string | null
  set: (token: string) => void
}

const useAuthToken = (): Hook => {
  const [authToken, setAuthToken] = React.useState<string>()
  
  React.useEffect(() => {
    const token = getToken()
    if (token)
      setAuthToken(token)
  }, [])
  
  return {token: authToken, get: getToken, set: setToken}
}

export default useAuthToken