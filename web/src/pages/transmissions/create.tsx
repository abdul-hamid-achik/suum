import React from "react"
import {
  Box,
  FormControl,
  FormLabel,
  FormHelperText,
  useColorModeValue as mode,
  Input,
  Link,
  Button,
  Stack,
  HStack,
  Text,
  RadioGroup,
  Radio
} from "@chakra-ui/react"
import { useForm } from "react-hook-form"
import { useHistory } from "react-router-dom"
import { useMutation, gql } from "@apollo/client"
import { FaPlus } from "react-icons/fa"
import { TransmissionTypes } from '../../constants'

const CREATE_TRANSMISSION = gql`
  mutation CreateTransmission($name: String!, $type: String!) {
    createTransmission(name: $name, type: $type) {
      uuid
      name
      type
      user {
        uuid
      }
    }
  }
`

interface CreateTransmissionMutation {
  createTransmission: Pick<Transmission, "name" | "uuid" | "type" | "user">
}

const Create = () => {
  const { register, handleSubmit, errors } = useForm()
  const history = useHistory()
  const [CreateTransmission, createTransmissionMutation] = useMutation<CreateTransmissionMutation, Pick<Transmission, "name" | "type">>(CREATE_TRANSMISSION)
  const onSubmit = async (variables: Pick<Transmission, "name" | "type">) => {
    try {
      const { data } = await CreateTransmission({ variables })
      console.log(createTransmissionMutation)
      if (data?.createTransmission)
        history.push(data?.createTransmission.uuid)
    } catch (exception) {
      console.error(exception)
    }

  }

  return (
    <Box bg={mode('gray.50', 'inherit')} minH="100vh" py="12" px={{ sm: '6', lg: '8' }}>
      <Box maxW={{ sm: 'md' }} mx={{ sm: 'auto' }} w={{ sm: 'full' }}>
        <Text fontSize="2xl">
          Create a transmissions
        </Text>
        <Text fontSize="sm">
          After the transmission ends a set of tools will become available in the transmission edit page
        </Text>
        <form onSubmit={handleSubmit(onSubmit)}>
          <Stack spacing="6">
            <FormControl>
              <FormLabel>
                Name
              </FormLabel>
              <Input name="name" ref={register({ required: true })} />
              {errors.name && <span>This field is required</span>}
              <FormHelperText>
                Add a name to your transmission, it will be used in the url and make available for search
              </FormHelperText>
            </FormControl>

            <FormControl>
              <FormLabel>
                Type
              </FormLabel>
              <RadioGroup defaultValue={TransmissionTypes.LIVE}>
                <HStack spacing={4} direction="row">
                  <Radio name="type" ref={register({ required: true })} value={TransmissionTypes.LIVE}>
                    {TransmissionTypes.LIVE}
                  </Radio>
                  <Radio name="type" ref={register({ required: true })} value={TransmissionTypes.UPLOAD}>
                    {TransmissionTypes.UPLOAD}
                  </Radio>
                </HStack>
              </RadioGroup>
              <FormHelperText>
                A live transmission has to be executed either by using a program like <Link href="https://obsproject.com/">
                  OBS
                </Link> or via Webcam
              </FormHelperText>
            </FormControl>
            <Button type="submit" leftIcon={<FaPlus />}>
              Create
          </Button>
          </Stack>
        </form>
      </Box>
    </Box>
  )
}

export default Create