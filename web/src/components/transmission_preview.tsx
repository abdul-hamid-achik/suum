import React from "react"
import { Box, Button, Image, Text, VStack } from "@chakra-ui/react"
import { FaEdit } from "react-icons/fa"
import { useHistory } from "react-router-dom"
import { Urls } from "../constants"

interface Props extends Transmission {
  currentUser?: User
}

function useDebounce(value: any, delay: number) {
  const [debouncedValue, setDebouncedValue] = React.useState(value)
  React.useEffect(
    () => {
      const handler = setTimeout(() => {
        setDebouncedValue(value)
      }, delay);

      return () => {
        clearTimeout(handler)
      };
    },
    [value, delay]
  )

  return debouncedValue
}

const TransmissionPreview: React.FC<Props> = ({ uuid, preview, user, name, currentUser }) => {
  const history = useHistory()
  const EDIT_TRANSMISSION_URL = Urls.EDIT_TRANSMISSION.replace(":uuid", uuid)
  const [isHovering, setHovering] = React.useState<boolean>(false)
  const debouncedBlurring = useDebounce(() => setHovering(false), 500)
  const onClick = () => history.push(EDIT_TRANSMISSION_URL)

  return (<Box h="250" onMouseOver={() => setHovering(true)} onMouseLeave={debouncedBlurring}>
    <Box display="flex" justifyContent="center" bg="black">
      <Image
        maxH="200"
        boxSize="200px"
        objectFit="cover"
        src={preview}
        alt={name} />
    </Box>
    {currentUser && currentUser.uuid === user.uuid && isHovering && <VStack onMouseLeave={debouncedBlurring} onMouseOver={() => setHovering(true)} >
      <Button onMouseOver={() => setHovering(true)} onClick={onClick} leftIcon={<FaEdit />}>
        Edit
      </Button>
    </VStack>
    }
    <Text fontSize="sm">
      {name}
    </Text>
  </Box>)
}
export default TransmissionPreview