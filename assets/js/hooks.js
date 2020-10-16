let localStream
let users = {}

async function initStream(hook) {
  try {
    const video = document.getElementById("local-video")
    // Gets our local media from the browser and stores it as a const, stream.
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true, video: true, width: "1280" })
    await video.play()
    const mediaRecorder = new MediaRecorder(stream, {
      mimeType: 'video/webm',
      videoBitsPerSecond: 3000000
    })
    mediaRecorder.ondataavailable = (e) => {
      var reader = new FileReader()
      reader.onloadend = function() {
        hook.pushEvent("video_data", { data: reader.result })
      }
      reader.readAsDataURL(e.data)
    }
    mediaRecorder.start(1000)
    // Stores our stream in the global constant, localStream.
    localStream = stream
    // Sets our local video element to stream from the user's webcam (stream).
    video.srcObject = stream
  } catch (e) {
    console.log(e)
  }
}

function addUserConnection(userUuid) {
  if (users[userUuid] === undefined) {
    users[userUuid] = {
      peerConnection: null
    }
  }

  return users
}

function removeUserConnection(userUuid) {
  delete users[userUuid]

  return users
}

function createPeerConnection(lv, fromUser, offer) {
  let newPeerConnection = new RTCPeerConnection({
    iceServers: [
      { urls: "stun:prod.suum.app:3478" },
      { urls: "stun:stun.1.google.com:19302" },
      { urls: "stun:stun1.1.google.com:19302" },
      { urls: "stun:stun2.1.google.com:19302" },
      { urls: "stun:stun3.1.google.com:19302" },
      { urls: "stun:stun4.1.google.com:19302" },
      { urls: "stun:stun.l.google.com:19302" },
      { urls: "stun:stun1.l.google.com:19302" },
      { urls: "stun:stun2.l.google.com:19302" },
      { urls: "stun:stun3.l.google.com:19302" },
      { urls: "stun:stun4.l.google.com:19302" },
    ]
  })

  users[fromUser].peerConnection = newPeerConnection

  localStream.getTracks().forEach(track => newPeerConnection.addTrack(track, localStream))

  if (offer !== undefined) {
    newPeerConnection.setRemoteDescription({ type: "offer", sdp: offer })
    newPeerConnection.createAnswer()
      .then((answer) => {
        newPeerConnection.setLocalDescription(answer)
        console.log("Sending this ANSWER to the requester:", answer)
        lv.pushEvent("new_answer", { toUser: fromUser, description: answer })
      })
      .catch((err) => console.log(err))
  }

  newPeerConnection.onicecandidate = async ({ candidate }) => {
    lv.pushEvent("new_ice_candidate", { toUser: fromUser, candidate })
  }

  if (offer === undefined) {
    newPeerConnection.onnegotiationneeded = async () => {
      try {
        newPeerConnection.createOffer()
          .then((offer) => {
            newPeerConnection.setLocalDescription(offer)
            console.log("Sending this OFFER to the requester:", offer)
            lv.pushEvent("new_sdp_offer", { toUser: fromUser, description: offer })
          })
          .catch((err) => console.log(err))
      }
      catch (error) {
        console.log(error)
      }
    }
  }

  newPeerConnection.ontrack = async (event) => {
    console.log("Track received:", event)
    document.getElementById(`video-remote-${fromUser}`).srcObject = event.streams[0]
  }

  return newPeerConnection;
}

const Hooks = {
  JoinCall: {
    mounted() {
      initStream(this)
    }
  },

  InitUser: {
    mounted() {
      addUserConnection(this.el.dataset.userUuid)
    },

    destroyed() {
      removeUserConnection(this.el.dataset.userUuid)
    }
  },

  HandleOfferRequest: {
    mounted() {
      console.log("new offer request from", this.el.dataset.fromUserUuid)
      let fromUser = this.el.dataset.fromUserUuid
      createPeerConnection(this, fromUser)
    }
  },

  HandleIceCandidateOffer: {
    mounted() {
      let data = this.el.dataset
      let fromUser = data.fromUserUuid
      let iceCandidate = JSON.parse(data.iceCandidate)
      let peerConnection = users[fromUser].peerConnection

      console.log("new ice candidate from", fromUser, iceCandidate)

      peerConnection.addIceCandidate(iceCandidate)
    }
  },

  HandleSdpOffer: {
    mounted() {
      let data = this.el.dataset
      let fromUser = data.fromUserUuid
      let sdp = data.sdp

      if (sdp != "") {
        console.log("new sdp OFFER from", data.fromUserUuid, data.sdp)

        createPeerConnection(this, fromUser, sdp)
      }
    }
  },

  HandleAnswer: {
    mounted() {
      let data = this.el.dataset
      let fromUser = data.fromUserUuid
      let sdp = data.sdp
      let peerConnection = users[fromUser].peerConnection

      if (sdp != "") {
        console.log("new sdp ANSWER from", fromUser, sdp)
        peerConnection.setRemoteDescription({ type: "answer", sdp: sdp })
      }
    }
  }
}

export default Hooks