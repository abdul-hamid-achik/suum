import {HttpResponse} from 'tus-js-client'

export default class Response implements HttpResponse{
  private xhr: XMLHttpRequest

  constructor (xhr: XMLHttpRequest) {
    this.xhr = xhr
  }

  getStatus () {
    return this.xhr.status
  }

  getHeader(header: string) {
    return this.xhr.getResponseHeader(header) as unknown as string
  }

  getBody () {
    return this.xhr.responseText
  }

  getUnderlyingObject () {
    return this.xhr
  }
}