import { HttpRequest, HttpResponse } from "tus-js-client"
import Response from "./response"

export default class Request implements HttpRequest{
  private xhr: XMLHttpRequest
  private method: string
  private url: string
  private headers: any

  constructor(method: string, url: string) {
    this.xhr = new XMLHttpRequest()
    this.xhr.open(method, url, true)

    this.method = method
    this.url = url
    this.headers = {}
  }

  getMethod () {
    return this.method
  }

  getURL () {
    return this.url
  }

  setHeader (header: string, value: string) {
    this.xhr.setRequestHeader(header, value)
    this.headers[header] = value
  }

  getHeader(header: string) {
    return this.headers[header]
  }

  setProgressHandler(progressHandler: (progress: number) => void) {
    if (!('upload' in this.xhr)) {
      return
    }

    this.xhr.upload.onprogress = (e) => {
      if (!e.lengthComputable) {
        return
      }

      progressHandler(e.loaded)
    }
  }

  send(body: any) {
    return new Promise<HttpResponse>((resolve, reject) => {
      this.xhr.onload = () => {
        resolve(new Response(this.xhr))
      }

      this.xhr.onerror = (err) => {
        reject(err)
      }

      this.xhr.send(body)
    })
  }

  abort () {
    this.xhr.abort()
    return Promise.resolve()
  }

  getUnderlyingObject () {
    return this.xhr
  }
}
