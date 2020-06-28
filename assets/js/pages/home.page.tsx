import React, {useRef, useEffect, useState} from 'react'
import {useSelector, useDispatch} from 'react-redux'
async function playVideoFromCamera(videoElement, constraints) {
    try {
        const stream = await navigator.mediaDevices.getUserMedia(constraints)
        videoElement.srcObject = stream
    } catch(error) {
        console.error('Error opening video camera.', error)
    }
}

const Home = () => {
	const videoRef = useRef()
	const dispatch = useDispatch()
	const [getStream, setStream] = useState(null);
	/* TODO: These don't tell if the video or audio are playing these tell if the buttons are enabled */
	const isPlayingVideo = useSelector(state => state.playingVideo)
	const isPlayingAudio = useSelector(state => state.playingAudio)

	const startVideoCall = () => {
		if (getStream) return;

		const openMediaDevices = async (constraints) => {
		    return await navigator.mediaDevices.getUserMedia(constraints)
		}

		try {
			const constraints = {'video':true,'audio':true}
		    setStream(openMediaDevices(constraints));
		    playVideoFromCamera(videoRef.current, constraints)
		} catch(error) {
		    console.error('Error accessing media devices.', error)
		}
	}

	let toggleTrack = (enabled, trackKind) => {
		getStream && getStream.then(stream => {
			const track = stream.getTracks().find(track => track.kind === trackKind)
			track.enabled = enabled
		})
	}

	useEffect(startVideoCall, [getStream])
	useEffect(() => {
		toggleTrack(isPlayingVideo,'video');
		// videoRef.current.srcObject = null
		toggleTrack(isPlayingAudio,'audio');
	}, [isPlayingVideo, isPlayingAudio, getStream])

	return <div>
		<div id="video" className="tile is-black">
			<video ref={videoRef} autoPlay={true} playsInline controls={false} />
		</div>
	</div>
}

export default Home