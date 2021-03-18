import React from "react"
import { Flex, SimpleGrid, Text } from "@chakra-ui/react"
import { gql, useQuery } from "@apollo/client"
import TransmissionPreview from "../components/transmission_preview"

const GET_TRANSMISSIONS = gql`
    query {
        transmissions {
            uuid
            name
            preview
        }
    }
`

interface TransmissionsQuery {
  transmissions: Transmission[]
}

const Main: React.FC = () => {
  const { data } = useQuery<TransmissionsQuery>(GET_TRANSMISSIONS)

  return (
    <Flex h="90vh" flexDirection="column" overflowY="auto">
      {data?.transmissions.length === 0 && <Text fontSize="4xl">No current transmissions</Text>}
      <SimpleGrid columns={3} minChildWidth="300px" spacing="20px">
        {data?.transmissions.map((transmission, key) =>
          <TransmissionPreview key={key} {...transmission} />)}
      </SimpleGrid>
    </Flex>
  )
}

export default Main