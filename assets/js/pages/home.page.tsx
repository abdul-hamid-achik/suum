import React, {useRef, useEffect, useState} from 'react'

type HomeProps {
	isPlayingVideo: boolean
}
async function playVideoFromCamera(videoElement, constraints) {
    try {
        const stream = await navigator.mediaDevices.getUserMedia(constraints)
        videoElement.srcObject = stream
    } catch(error) {
        console.error('Error opening video camera.', error)
    }
}

const Home = ({isPlayingVideo}: HomeProps) => {
	const videoRef = useRef()

	const startVideoCall = () => {
		const openMediaDevices = async (constraints) => {
		    return await navigator.mediaDevices.getUserMedia(constraints)
		}

		try {
			const constraints = {'video':true,'audio':true}
		    const stream = openMediaDevices(constraints)
		    playVideoFromCamera(videoRef.current, constraints)
		} catch(error) {
		    console.error('Error accessing media devices.', error)
		}
	}
	useEffect(() => {
			startVideoCall()
	}, [isPlayingVideo])

	return <div>
		<div id="video" className="tile is-black">
			<video ref={videoRef} autoPlay={true} playsInline controls={false} />
		</div>
	</div>
}

export default Home