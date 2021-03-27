import React from "react"
import { FaPlus, FaBackward, FaSignInAlt } from 'react-icons/fa'
import { useHistory, useRouteMatch } from 'react-router-dom'
import {
  Stack,
  Button
} from "@chakra-ui/react"
import { Urls } from '../constants'
import { useQuery, gql } from '@apollo/client'
import ColorModeSwitcher from '../components/color_mode_switcher'

const GET_ME = gql`
  query {
    me {
      uuid
      email
    }
  }
`

interface MeQuery {
  me: User
}

const Navbar: React.FC = () => {
  const { data } = useQuery<MeQuery>(GET_ME)
  const history = useHistory()
  const isCreatingTransmission = useRouteMatch(Urls.CREATE_TRANSMISSION)
  const isSigningIn = useRouteMatch(Urls.SIGN_IN)
  const isSigningUp = useRouteMatch(Urls.SIGN_UP)

  const handleCreate = () => isCreatingTransmission ? history.goBack() : history.push(Urls.CREATE_TRANSMISSION)
  const handleSignIn = () => history.push(Urls.SIGN_IN)
  return (
    <Stack spacing={4} direction="row" justifyContent="flex-end">
      {!isSigningUp && !isSigningIn && data?.me && <Button colorScheme="red"
        leftIcon={isCreatingTransmission ? <FaBackward /> : <FaPlus />}
        onClick={handleCreate}>
        {isCreatingTransmission ? "Go Back" : "Start"}
      </Button>}
      <ColorModeSwitcher />
      {!isSigningUp && !isSigningIn && !data?.me && <Button colorScheme="blue"
        leftIcon={<FaSignInAlt />}
        onClick={handleSignIn}>
        Sign In
      </Button>}
    </Stack>
  )
}

export default Navbar