import 'video.js/dist/video-js.min.css'
import videojs from "video.js"
import * as React from "react"
import { Helmet } from "react-helmet"
import { env } from "../constants"

import "@videojs/http-streaming"

interface Props {
    uuid: Transmission['uuid'],
    forwardRef?: React.RefObject<HTMLVideoElement>,
    play?: boolean
}

const Player: React.FC<Props> = ({ uuid, forwardRef, play = false }) => {
    const videoRef = React.useRef<HTMLMediaElement>(null) as React.RefObject<HTMLVideoElement>
    const mainRef: React.RefObject<HTMLVideoElement> = forwardRef ? forwardRef : videoRef
    React.useEffect(() => {
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
                player.play()
            })

            player.on('error', () => {
                // player.createModal('Retrying connection')
                if (player.error().code === 4) {
                    player.retryLock = setTimeout(() => {
                        player.src(srcConfig)
                        player.load()
                    }, 1000)
                }
            })
        }
    }, [uuid, mainRef, play])

    return (<>
        <Helmet>
            <style type="text/css">{`
          .vjs-default-skin.vjs-paused .vjs-big-play-button {
            display: none;
          }
          
          .video-js .vjs-big-play-button {
            display: none;
          }
        `}</style>
        </Helmet>
        <video className="video-js" controls ref={mainRef} width={640} height={360} />
    </>
    )
}

export default Player