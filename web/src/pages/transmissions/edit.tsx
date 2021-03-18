import React from "react"
import { Code } from "@chakra-ui/react"
import { useParams } from "react-router-dom"
import { useQuery, gql } from "@apollo/client"
import env from 'react-dotenv'

const GET_TRANSMISSION = gql`
  query GetTransmission($uuid: ID!) {
    transmission(uuid: $uuid) {
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
  return <div>
    <Code children={`${env.RTMP_HOST}/live/${data?.transmission.uuid}`} />
  </div>
}

export default Edit