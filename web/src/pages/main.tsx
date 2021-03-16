import React from "react"
import { Text, Box, Image } from "@chakra-ui/react"
import { gql, useQuery } from "@apollo/client"

const TRANSMISSIONS_QUERY = gql`
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
    const { data } = useQuery<TransmissionsQuery>(TRANSMISSIONS_QUERY)

    return (<Box maxWidth="80vw">
        {data?.transmissions.map((transmission, key) => <Box width="360px" key={key}>
            <Text>
                {transmission.name}
            </Text>
            <Image src={transmission.preview} alt={transmission.name} />
        </Box>)}
    </Box>)
}

export default Main