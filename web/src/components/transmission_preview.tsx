import React from "react"
import { Box, Image, Text } from "@chakra-ui/react"

interface Props extends Transmission {

}

const TransmissionPreview: React.FC<Props> = ({ preview, name }) => <Box h="250">
  <Box display="flex" justifyContent="center" bg="black">
    <Image maxH="200" boxSize="200px"
      objectFit="cover" src={preview} alt={name} />
  </Box>
  <Text fontSize="sm">
    {name}
  </Text>
</Box>
export default TransmissionPreview