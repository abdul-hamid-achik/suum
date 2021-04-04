import 'video.js/dist/video-js.min.css'
import videojs from "video.js"
import * as React from "react"
import { Helmet } from "react-helmet"
import { env } from "../constants"
import { useToast, AspectRatio } from "@chakra-ui/react"
import "@videojs/http-streaming"
import "videojs-vtt-thumbnails"

interface Props {
  uuid: Transmission['uuid'],
  forwardRef?: React.RefObject<HTMLVideoElement>,
  play?: boolean
}

type VideoSource = {
  src: string,
  type: string
}

const Player: React.FC<Props> = ({ uuid, forwardRef, play = false }) => {
  const [sources, setSources] = React.useState<VideoSource[]>([])
  const videoRef = React.useRef<HTMLMediaElement>(null) as React.RefObject<HTMLVideoElement>
  const mainRef: React.RefObject<HTMLVideoElement> = forwardRef ? forwardRef : videoRef
  const toast = useToast()

  React.useEffect(() => {
    try {
      const player = videojs(mainRef.current, {
        liveui: false,
        errorDisplay: false
      })

      if (player && env && play) {
        const srcConfig = {
          src: `${env?.HTTP_API_HOST}/transmissions/${uuid}/index.m3u8`,
          type: "application/x-mpegURL"
        }

        player.ready(() => {
          player.src(srcConfig)
          player.vttThumbnails({
            src: `${env?.HTTP_API_HOST}/transmissions/${uuid}/thumbnails.vtt`,
            showTimestamp: true
          })
          if (play) {
            player.play()
          }
        })

        player.on('error', () => {
          player.createModal('Retrying connection')
          if (player.error().code === 4) {
            player.retryLock = setTimeout(() => {
              player.src(srcConfig)
              player.load()
            }, 1000)
          }
        })

        setSources([srcConfig])
        return () => player.dispose()
      }

    } catch (error) {
      console.error(error)
      toast({
        title: "Error occurred.",
        description: "please hold on",
        status: "error",
        duration: 9000,
        isClosable: true,
      })
    }

    return () => { }
  }, [uuid, mainRef, play, toast])
  return (
    <AspectRatio maxW="600px" ratio={16 / 9}>
      <video className="video-js" ref={mainRef} controls autoPlay={play}>
        <Helmet>
          <style type="text/css">
            {`
              .vjs-default-skin.vjs-paused .vjs-big-play-button {
                display: none;
              }
              
              .video-js .vjs-big-play-button {
                display: none;
              }
            `}
          </style>
        </Helmet>
        {sources.map((source, key) => <source key={key} {...source} />)}
      </video>
    </AspectRatio>
  )
}

export default Player