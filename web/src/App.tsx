import * as React from "react"
import {
  ChakraProvider,
  Box,
  Button,
  Container,
  Grid,
  theme
} from "@chakra-ui/react"
import { FaCamera } from "react-icons/fa"
import { Socket, Channel } from "phoenix"
import env from "react-dotenv"
import { ColorModeSwitcher } from "./ColorModeSwitcher"

export const App = () => {
  const videoRef = React.useRef<HTMLMediaElement>(null)
  const channel = React.useRef<Channel>()
  const socket = React.useMemo(() => new Socket(`${env.WS_API_HOST}/socket`), [])
  socket.onError(() => console.log("there was an error with the connection!"))
  socket.onClose(() => console.log("the connection dropped"))

  const onDataAvailable = ({ data }: BlobEvent) => {
    const reader = new FileReader()
    reader.onloadend = () => {
      channel.current?.push("segment", { data: reader.result })
    }

    reader.readAsDataURL(data)
  }

  const onLoadedMetaData = (stream: MediaStream) => () => {
    const video = videoRef.current
    if (video) {
      video.play()
      const mediaRecorder = new MediaRecorder(stream, {
        mimeType: 'video/webm',
        videoBitsPerSecond: 3000000
      })

      mediaRecorder.ondataavailable = onDataAvailable
      mediaRecorder.start(1000)
    }
  }

  const onClick = async () => {
    const constraints = {
      audio: false,
      video: true
    }

    if (!socket.isConnected()) {
      socket.connect()
    }

    try {
      const stream = await navigator.mediaDevices.getUserMedia(constraints)
      const video = videoRef.current
      if (video) {
        video.srcObject = stream
        video.onloadedmetadata = onLoadedMetaData(stream)
      }
    } catch (error) {
      console.warn(error)
    }
  }

  React.useEffect(() => {
    if (!channel.current) {
      channel.current = socket.channel("transmit:video")
      channel.current.onError(() => console.error("there was an error!"))
      channel.current.onClose(() => console.warn("the channel has gone away gracefully"))
      channel.current
        .join()
        .receive("ok", (response) => console.info(response))
        .receive("error", (response) => console.error(response))
    }
    return socket.disconnect()
  }, [socket])


  return (
    <ChakraProvider theme={theme}>
      <Box textAlign="center" fontSize="xl">
        <Grid minH="100vh" p={3}>
          <ColorModeSwitcher justifySelf="flex-end" />
          <Container centerContent>
            {/* @ts-ignore */}
            <Box bg="black" as="video" ref={videoRef} width={640} height={360} />
            <Button onClick={onClick} rightIcon={<FaCamera />}>
              Start
            </Button>
          </Container>
        </Grid>
      </Box>
    </ChakraProvider>
  )
}

