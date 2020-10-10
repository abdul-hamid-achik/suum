import { Controller } from "stimulus"
import channel from '../socket'

export default class extends Controller {
	static targets = ["connect", "call", "disconnect", "local", "remote"]

	remoteStream = new MediaStream()

	connect() {
		console.log(this)
		this.setVideoStream(this.remoteTarget, this.remoteStream)

		this.disconnectTarget.disabled = true
		this.callTarget.disabled = true

		channel.on('peer-message', payload => {
			const message = JSON.parse(payload.body)
			switch (message.type) {
				case 'video-offer':
					console.log('offered: ', message.content)
					break
				case 'video-answer':
					console.log('answered: ', message.content)
					this.receiveRemote(message.content)
					break
				case 'ice-candidate':
					console.log('candidate: ', message.content)
					break
				case 'disconnect':
					this.stop()
					break
				case 'video-offer':
					console.log('offered: ', message.content)
					this.answerCall(message.content)
					break
				case 'ice-candidate':
					console.log('candidate: ', message.content)
					const candidate = new RTCIceCandidate(message.content)
					this.peerConnection.addIceCandidate(candidate).catch(reportError)
					break
				default:
					this.reportError('unhandled message type')(message.type)
			}
		})
	}

	async call() {
		const offer = await this.peerConnection.createOffer()
		this.peerConnection.setLocalDescription(offer)
		channel.push('peer-message', {
			body: JSON.stringify({
				'type': 'video-offer',
				'content': offer
			}),
		})
		this.pushPeerMessage('video-offer', offer)
	}

	async answerCall(offer) {
		this.receiveRemote(offer)
		const remoteDescription = new RTCSessionDescription(offer)
		this.peerConnection.setRemoteDescription(remoteDescription)
		const answer = await this.peerConnection.createAnswer()
		this.peerConnection
			.setLocalDescription(answer)
			.then(() =>
				pushPeerMessage('video-answer', this.peerConnection.localDescription)
			)
	}

	receiveRemote(offer) {
		const remoteDescription = new RTCSessionDescription(offer)
		this.peerConnection.setRemoteDescription(remoteDescription)
	}

	stop() {
		this.connectTarget.disabled = false
		this.disconnectTarget.disabled = true
		this.callTarget.disabled = true
		this.unsetVideoStream(this.localTarget)
		this.unsetVideoStream(this.remoteTarget)
		this.remoteStream = new MediaStream()
		this.setVideoStream(this.remoteTarget, this.remoteStream)
		this.peerConnection.close()
		this.peerConnection = null
		this.pushPeerMessage('disconnect', {})

	}

	async start() {
		this.connectTarget.disabled = true
		this.disconnectTarget.disabled = false
		this.callTarget.disabled = false
		const localStream = await navigator.mediaDevices.getUserMedia({
			audio: true,
			video: true,
		})

		console.log(this.localTarget)
		this.setVideoStream(this.localTarget, localStream)
		this.peerConnection = this.createPeerConnection(localStream)
	}

	setVideoStream(videoElement, stream) {
		videoElement.srcObject = stream
	}

	unsetVideoStream(videoElement) {
		if (videoElement.srcObject) {
			videoElement.srcObject.getTracks().forEach(track => track.stop())
		}
		videoElement.removeAttribute('src')
		videoElement.removeAttribute('srcObject')
	}

	createPeerConnection(stream) {
		const pc = new RTCPeerConnection({
			iceServers: [
				{
					urls: 'stun:stun.stunprotocol.org',
				},
			],
		})
		pc.ontrack = this.handleOnTrack
		pc.onicecandidate = this.handleOnIceCandidate
		stream.getTracks().forEach(track => pc.addTrack(track))
		return pc
	}

	pushPeerMessage(type, content) {
		channel.push('peer-message', {
			body: JSON.stringify({
				type,
				content
			}),
		})
	}

	handleOnTrack(event) {
		console.log(event)
		this.remoteTarget.addTrack(event.track)
	}

	handleIceCandidate(event) {
		console.log(event)
		if (!!event.candidate) {
			this.pushPeerMessage('ice-candidate', event.candidate)
		}
	}
}
