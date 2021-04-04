import React from "react"
import {
  Box, Text,
  useColorModeValue as mode,
} from "@chakra-ui/react"
import { useParams } from "react-router-dom"
import { useQuery, gql } from "@apollo/client"
import Player from "../../components/player"

const GET_TRANSMISSION_QUERY = gql`
  query Transmission($slug: String!) {
    transmission(slug: $slug) {
      uuid
      name
    }
  }
`


interface TransmissionQuery {
  transmission: Transmission
}


const View: React.FC = () => {
  const { slug } = useParams<Pick<Transmission, "slug">>()
  const { data } = useQuery<TransmissionQuery, Pick<Transmission, "slug">>(GET_TRANSMISSION_QUERY, {
    variables: { slug }
  })

  return (
    <Box bg={mode('gray.50', 'inherit')} minH="100vh" py="12" px={{ sm: '6', lg: '8' }}>
      <Box maxW={{ sm: 'md' }} mx={{ sm: 'auto' }} w={{ sm: 'full' }}>
        <Text>{data?.transmission.name}</Text>
        {data && <Player uuid={data.transmission.uuid} play />}
      </Box>
    </Box>
  )
}

export default View