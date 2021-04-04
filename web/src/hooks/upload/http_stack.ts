import { HttpStack } from "tus-js-client"
import {env} from "../../constants"
import Request from "./request"

class XHRHttpStack implements HttpStack {
  private BASE_URL: string = `${env?.HTTP_API_HOST}/upload`

  createRequest = (method: string, url: string) => new Request(method, this.getUrl(method, url))
  getName = () => 'XHRHttpStack'
  getUrl(method: string, url: string): string {
    if (url.includes("upload"))
      return url

      console.log(method)
    if (method === 'OPTIONS') {
      return this.BASE_URL
    }
    
    const uid = url.split('/').pop()
    return `${this.BASE_URL}/${uid}`
  }
}

export default XHRHttpStack