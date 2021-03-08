import 'video.js/dist/video-js.min.css'
import * as React from "react"
import {
  ChakraProvider,
  Box,
  Stack,
  Button,
  Heading,
  Container,
  Grid,
  Text,
  theme
} from "@chakra-ui/react"
import { FaCamera, FaTimes, FaPlay } from "react-icons/fa"
import { Socket, Channel } from "phoenix"
import { useQuery, gql } from "@apollo/client"
import env from "react-dotenv"
import client from "./client"
import { ColorModeSwitcher } from "./ColorModeSwitcher"
import videojs from "video.js"
import "videojs-vtt-thumbnails"
import "videojs-contrib-hls"

const GET_TRANSMISSIONS = gql`
  query {
    list_transmissions {
      uuid
      name
    }
  }
`

export const App = () => {
  const { data } = useQuery(GET_TRANSMISSIONS, {
    client
  })
  const [transmission, setTransmission] = React.useState<Transmission | null>()

  const [isPlaying, setPlaying] = React.useState<boolean>(false)
  const videoRef = React.useRef<HTMLMediaElement>(null)
  const channel = React.useRef<Channel>()
  const stream = React.useRef<MediaStream>()
  const socket = React.useMemo(() => new Socket(`${env.WS_API_HOST}/socket`), [])

  socket.onError(() => console.log("there was an error with the connection!"))
  socket.onClose(() => console.log("the connection dropped"))

  const onTransmissionPlay = (transmission: Transmission) => () => {
    setTransmission(transmission)
  }

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
    if (isPlaying && stream.current) {
      stream.current.getTracks().forEach(track => track.stop())
      channel.current?.push("stop", {})
    } else {
      setTransmission(null)
      channel.current?.push("start", {})

      const constraints = {
        audio: false,
        video: true
      }

      if (!socket.isConnected()) {
        socket.connect()
      }

      try {
        stream.current = await navigator.mediaDevices.getUserMedia(constraints)
        const video = videoRef.current
        if (video) {
          video.srcObject = stream.current
          video.onloadedmetadata = onLoadedMetaData(stream.current)
        }
      } catch (error) {
        console.warn(error)
      }
    }

    setPlaying(!isPlaying)
  }

  React.useEffect(() => {
    if (!channel.current) {
      channel.current = socket.channel("transmit:video")
      channel.current.onError(() => console.error("there was an error!"))
      channel.current.onClose(() => {
        setPlaying(false)
        console.warn("the channel has gone away gracefully")
      })
      channel.current
        .join()
        .receive("ok", (response) => console.info(response))
        .receive("error", (response) => console.error(response))
    }
    return socket.disconnect()
  }, [socket])

  React.useEffect(() => {
    const player = videojs(videoRef.current, {
      liveui: false,
      liveTracker: {
        trackingThreshold: 0,
      }
    })
    if (transmission) {
      player.ready(() => {
        player.src({
          src: `${env.HTTP_API_HOST}/transmissions/${transmission.uuid}/index.m3u8`,
          type: "application/x-mpegURL"
        })
        // @ts-ignore
        player.vttThumbnails({
          src: `${env.HTTP_API_HOST}/transmissions/${transmission.uuid}/thumbnails.vtt`,
          showTimestamp: true
        })

        player.play()
      })
    } else {
      // player.dispose()
    }
  }, [transmission])

  return (
    <ChakraProvider theme={theme}>
      <Box textAlign="center" fontSize="xl">
        <Grid minH="80vh" p={3}>
          <ColorModeSwitcher justifySelf="flex-end" />
          <Container centerContent>
            {/* @ts-ignore */}
            <video className="video-js" controls ref={videoRef} width={640} height={360} />
            <Button onClick={onClick} colorScheme={isPlaying ? "red" : "blue"} rightIcon={isPlaying ? <FaTimes /> : <FaCamera />}>
              {isPlaying ? "Stop" : "Start"}
            </Button>
          </Container>
        </Grid>
      </Box>
      <Box>
        <Heading>Previous Transmissions</Heading>
        <Stack spacing={4} direction="row" align="center">
          {data?.list_transmissions.map(
            (transmission: Transmission, key: number) => <Box key={key}>
              <Text>
                {transmission.uuid}
              </Text>
              <Button rightIcon={<FaPlay />} onClick={onTransmissionPlay(transmission)} colorScheme="red">
                Play
              </Button>
            </Box>
          )}
        </Stack>
      </Box>
    </ChakraProvider >
  )
}

