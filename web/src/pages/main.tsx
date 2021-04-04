import React from "react"
import { Flex, SimpleGrid, Text } from "@chakra-ui/react"
import { gql, useQuery } from "@apollo/client"
import TransmissionPreview from "../components/transmission_preview"

const GET_ME = gql`
  query {
    me {
      uuid
      email
    }
  }
`

const GET_TRANSMISSIONS = gql`
    query {
        transmissions {
            uuid
            name
            slug
            preview
            user {
              uuid
            }
        }
    }
`

interface TransmissionsQuery {
  transmissions: Transmission[]
}


interface MeQuery {
  me: User
}

const Main: React.FC = () => {
  const { data } = useQuery<TransmissionsQuery>(GET_TRANSMISSIONS)
  const Auth = useQuery<MeQuery>(GET_ME)

  return (
    <Flex h="90vh" flexDirection="column" overflowY="auto">
      {data?.transmissions.length === 0 && <Text fontSize="4xl">No current transmissions</Text>}
      <SimpleGrid columns={3} minChildWidth="300px" spacing="20px">
        {data?.transmissions.map((transmission, key) =>
          <TransmissionPreview key={key} {...transmission} currentUser={Auth.data?.me} />)}
        {data?.transmissions.length === 0 && <Text>No recent transmissions found</Text>}
      </SimpleGrid>
    </Flex>
  )
}

export default Main