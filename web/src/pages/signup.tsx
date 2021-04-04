import React from "react"
import {
  Box,
  Button,
  Heading,
  FormLabel,
  FormControl,
  Stack,
  Text,
  useColorModeValue as mode,
  Input
} from '@chakra-ui/react'
import { useApolloClient, useMutation, gql } from '@apollo/client'
import {
  useHistory
} from 'react-router-dom'
import { useForm } from "react-hook-form"
import { setToken } from "../token"


const SIGN_IN_MUTATION = gql`
  mutation Login($email: String!, $password: String!) {
    SignUp(email: $email, password: $password) {
      user {
        uuid
        email
      }
      token 
    }
  }
`
interface SignUpMutation {
  signup: {
    user: User,
    token: AuthToken
  }
}

interface SignUpMutationVariables {
  email: User['email']
  password: User['password']
}

const SignUp: React.FC = () => {
  const { register, handleSubmit, errors } = useForm()
  const [signInMutation, { data }] = useMutation<SignUpMutation, SignUpMutationVariables>(SIGN_IN_MUTATION)
  const history = useHistory()
  const client = useApolloClient()

  const onSubmit = ({ email, password }: User) => {
    try {
      signInMutation({ variables: { email, password } })
    } catch (error) {
      console.error(error)
    }
  }

  React.useEffect(() => {
    if (data && data.signup) {
      setToken(data.signup.token)
      client.resetStore()
      history.push("/")
    }
  }, [data, client, history])


  return <div>
    <Box bg={mode('gray.50', 'inherit')} minH="100vh" py="12" px={{ sm: '6', lg: '8' }}>
      <Box maxW={{ sm: 'md' }} mx={{ sm: 'auto' }} w={{ sm: 'full' }}>
        <Heading mt="6" textAlign="center" size="xl" fontWeight="extrabold">
          Sign in to your account
        </Heading>
        <Text mt="4" align="center" maxW="md" fontWeight="medium">
          <span>Already have an account?</span>
          <Box
            as="a"
            marginStart="1"
            href="/signin"
            color={mode('blue.600', 'blue.200')}
            _hover={{ color: 'blue.600' }}
            display={{ base: 'block', sm: 'revert' }}
          // as={RouterLink}
          >
            Sign in to yours
          </Box>
        </Text>
      </Box>
      <Box maxW={{ sm: 'md' }} mx={{ sm: 'auto' }} mt="8" w={{ sm: 'full' }}>
        <Box
          bg={mode('white', 'gray.700')}
          py="8"
          px={{ base: '4', md: '10' }}
          shadow="base"
          rounded={{ sm: 'lg' }}
        >
          <form onSubmit={handleSubmit(onSubmit)}>
            <Stack spacing="6">
              <FormControl id="email">
                <FormLabel>Email address</FormLabel>
                <Input name="email" type="email" ref={register({ required: true })} />
                {errors.email && <span>This field is required</span>}
              </FormControl>
              <FormControl id="password">
                <FormLabel>Password</FormLabel>
                <Input name="password" type="password" ref={register({ required: true })} />
                {errors.password && <span>This field is required</span>}
              </FormControl>
              <FormControl id="confirm_password">
                <FormLabel>Confirm Password</FormLabel>
                <Input name="confirm_password" type="password" ref={register({ required: true })} />
                {errors.confirm_password && <span>This field is required</span>}
              </FormControl>
              <Button type="submit" colorScheme="blue" size="lg" fontSize="md">
                Submit
              </Button>
            </Stack>
          </form>
        </Box>
      </Box>
    </Box>
  </div>
}

export default SignUp