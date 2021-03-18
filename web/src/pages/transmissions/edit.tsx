import React from "react"
import { Code, Text, Box } from "@chakra-ui/react"
import { useParams } from "react-router-dom"
import { useQuery, gql } from "@apollo/client"
import { env } from "../../constants"

const GET_TRANSMISSION = gql`
  query GetTransmission($uuid: ID!) {
    transmission(uuid: $uuid) {
      uuid
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
  return <Box maxW={{ sm: 'md' }} mx={{ sm: 'auto' }} mt="8" w={{ sm: 'full' }}>
    <Box
      py="8"
      px={{ base: '4', md: '10' }}
      shadow="base"
      rounded={{ sm: 'lg' }}
    >
      <Text fontSize="2xl">
        Transmission URL
      </Text>
      <Text fontSize="sm">
        For streaming using programs such as Open Broad Caster
      </Text>
      <Code children={`${env?.RTMP_HOST}/live/${data?.transmission.uuid}`} />
    </Box>
  </Box>
}

export default Edit