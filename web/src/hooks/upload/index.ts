import React from "react"
import {env} from "../../constants"
import useAuthToken from '../auth_token'
import {HttpResponse, Upload, UploadOptions, HttpRequest} from 'tus-js-client'
import XHRHttpStack from './http_stack'

interface IUpload {
  isUploading: boolean
  progress: number
  error: Error | undefined
  upload: (file: File) => void
  id?: string
}

const useUpload = (uuid?: string): IUpload => {
  const [file, setFile] = React.useState<File>()
  const [id, setId] = React.useState<string>()
  const [progress, setProgress] = React.useState<number>(0)
  const [isUploading, setUploading] = React.useState<boolean>(false)
  const [error, setError] = React.useState<Error>()
  const {token} = useAuthToken()

  const upload = (_file: File) => setFile(_file)
  const onError = (error: Error) => {
    console.error('💥 🙀', error)
    setError(error)
    setUploading(false)
  }

  const onProgress = (bytesSent: number, bytesTotal: number) => {
    const percentage = (bytesSent / bytesTotal * 100)
    console.log(`So far we've uploaded ${percentage}% of this file.`)
    setUploading(true)
  }

  const onSuccess = () => {
    console.log("Wrap it up, we're done here. 👋")
    setProgress(100)
    setUploading(true)
  }

  const onAfterResponse = (request: HttpRequest, response: HttpResponse) => {
    const url = request.getURL()
    const location = response.getHeader("location")
    if (!id && location) {
      setId(location)
    }
    
    console.log(`Request for ${url} responded with ${location} - ${id}`)
  }

  React.useEffect(() => {
    if (file && uuid) {
      const options: UploadOptions =  {
        endpoint: `${env?.HTTP_API_HOST}/upload`,
        chunkSize: 20_971_520,
        headers: {
          "Authorization": `Bearer ${token}`,
          "Location": `${uuid}`
        },
        metadata: {
          name: file.name,
          type: file.type,
          transmission_uuid: uuid
        },
        httpStack: new XHRHttpStack(),
        onAfterResponse,
        onError,
        onProgress,
        onSuccess
      }

      const upload = new Upload(file, options)
      upload.start()
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [file, token, uuid])

  return {progress, isUploading, error, upload, id}
}


export default useUpload