import React from "react"
import { useQuery, gql } from "@apollo/client"
import { Socket, Channel } from "phoenix"
import {
    Box,
    Stack,
    Button,
    Heading,
    Container,
    Grid,
    Text
} from "@chakra-ui/react"
import env from "react-dotenv"
import client from "./client"

const GET_TRANSMISSIONS = gql`
  query {
    list_transmissions {
      uuid
      name
    }
  }
`
const Main: React.FC = () => {
    const { data } = useQuery(GET_TRANSMISSIONS, {
        client
    })
    const channel = React.useRef<Channel>()
    const stream = React.useRef<MediaStream>()
    const socket = React.useMemo(() => new Socket(`${env.WS_API_HOST}/socket`), [])

    socket.onError(() => console.log("there was an error with the connection!"))
    socket.onClose(() => console.log("the connection dropped"))

    return (<div>
        <Box textAlign="center" fontSize="xl">
            <Grid minH="80vh" p={3}>
                <Container centerContent>
                    <video className="video-js" controls ref={videoRef} width={640} height={360} />
                    <Button onClick={onClick} colorScheme={isPlaying ? "red" : "blue"} rightIcon={isPlaying ? <FaTimes /> : <FaCamera />}>
                        {isPlaying ? "Stop" : "Start"}
                    </Button>
                </Container>
            </Grid>
        </Box>
        <Box>
            <Heading>Previous Transmissions</Heading>
            <Stack spacing={4} direction="row" align="center">
                {data?.list_transmissions.map(
                    (transmission: Transmission, key: number) => <Box key={key}>
                        <Text>
                            {transmission.uuid}
                        </Text>
                        <Button rightIcon={<FaPlay />} onClick={onTransmissionPlay(transmission)} colorScheme="red">
                            Play
              </Button>
                    </Box>
                )}
            </Stack>
        </Box>
    </div>)
}

export default Main