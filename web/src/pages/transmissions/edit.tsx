import React from "react"
import { Code, Text, Box, Button, Select, VStack, HStack, StackDivider } from "@chakra-ui/react"
import { useParams } from "react-router-dom"
import { FaCamera, FaMicrophone, FaPlay, FaStop } from "react-icons/fa"
import { useQuery, gql } from "@apollo/client"
import { env } from "../../constants"

const GET_TRANSMISSION = gql`
  query GetTransmission($uuid: ID!) {
    transmission(uuid: $uuid) {
      uuid
      type
      name
      preview
      sprite
    }
  }
`
type TransmissionUUID = Pick<Transmission, "uuid">

interface TransmissionQuery {
  transmission: Transmission
}

const Edit = () => {
  const { uuid } = useParams<TransmissionUUID>()
  const { data } = useQuery<TransmissionQuery, TransmissionUUID>(GET_TRANSMISSION, { variables: { uuid } })
  const [devices, setDevices] = React.useState<MediaDeviceInfo[] | InputDeviceInfo[]>()
  const [audioDevices, setAudioDevices] = React.useState<InputDeviceInfo[]>([])
  const [videoDevices, setVideoDevices] = React.useState<MediaDeviceInfo[]>([])

  const loadDevices = async () => {
    try {
      setDevices(await navigator.mediaDevices.enumerateDevices())
    } catch (error) {
      console.error(error)
    }
  }

  const getDefaultDevice = (devices: MediaDeviceInfo[]): MediaDeviceInfo | undefined => {
    // @ts-ignore
    const [device] = devices.filter(({ deviceId }): MediaDeviceInfo => deviceId === 'default')
    if (device) {
      return device
    }
  }

  React.useEffect(() => {
    loadDevices()
  }, [])

  React.useEffect(() => {
    if (devices && devices.length > 0) {
      setAudioDevices(devices.filter(({ kind }: MediaDeviceInfo) => kind === "audioinput") as unknown as InputDeviceInfo[])
      setVideoDevices(devices.filter(({ kind }: MediaDeviceInfo) => kind === "videoinput"))
    }
  }, [devices])

  const defaultAudioDevice = getDefaultDevice(audioDevices)
  const defaultVideoDevice = getDefaultDevice(videoDevices)

  return <Box maxW={{ sm: 'md' }} mx={{ sm: 'auto' }} mt="8" w={{ sm: 'full' }}>
    <Box
      py="8"
      px={{ base: '4', md: '10' }}
      shadow="base"
      rounded={{ sm: 'lg' }}
    >
      {data?.transmission.type === 'live' ? <VStack
        divider={<StackDivider borderColor="gray.200" />}
        spacing={4}
        align="stretch">
        <Box>
          <Text fontSize="2xl">
            Transmission URL
          </Text>
          <Text fontSize="sm">
            For streaming using programs such as Open Broad Caster
          </Text>
          <Code children={`${env?.RTMP_HOST}/live/${data?.transmission.uuid}`} />
        </Box>
        <Box>
          <Text fontSize="2xl" mb="4">
            Media Devices
          </Text>
          <Text fontSize="sm" mb="4">
            Select an audio and video devices to start streaming
          </Text>
          <HStack spacing={8}
            divider={<StackDivider borderColor="gray.200" />}>
            <Select defaultValue={defaultAudioDevice?.deviceId} placeholder={`Available ${audioDevices.length}`} icon={<FaCamera />}>
              {audioDevices?.map((device, key) => <option key={key} value={device.deviceId}>{device.label}</option>)}
            </Select>
            <Select defaultValue={defaultVideoDevice?.deviceId} placeholder={`Available ${videoDevices.length}`} icon={<FaMicrophone />}>
              {videoDevices?.map((device, key) => <option key={key} value={device.deviceId}>{device.label}</option>)}
            </Select>
          </HStack>
          <HStack spacing={4} mt="4">
            <Button leftIcon={<FaPlay />}>
              Start
            </Button>
            <Button leftIcon={<FaStop />} disabled={true}>
              Stop
            </Button>
          </HStack>
        </Box>
      </VStack> : <>
      </>}
    </Box>
  </Box >
}

export default Edit