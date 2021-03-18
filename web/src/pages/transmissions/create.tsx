import React from "react"
import { Box, FormControl, FormLabel, Input, Button, Stack, RadioGroup, Radio } from "@chakra-ui/react"
import { useForm } from "react-hook-form"
import { useHistory } from "react-router-dom"
import { useMutation, gql } from "@apollo/client"
import { TransmissionTypes } from '../../constants'

const CREATE_TRANSMISSION = gql`
  mutation CreateTransmission($name: String!, $type: String!) {
    createTransmission(name: $name, type: $type) {
      uuid,
      name,
      user {
        uuid
      }
    }
  }
`

interface CreateTransmissionMutation {
  createTransmission: Pick<Transmission, "name" | "uuid" | "type">
}

const Create = () => {
  const { register, handleSubmit, errors } = useForm()
  const history = useHistory()
  const [CreateTransmission, createTransmissionMutation] = useMutation<CreateTransmissionMutation, Pick<Transmission, "name" | "type">>(CREATE_TRANSMISSION)
  const onSubmit = async (payload: Pick<Transmission, "name" | "type">) => {
    try {
      const { data } = await CreateTransmission({ variables: payload })
      console.log(createTransmissionMutation)
      if (data?.createTransmission)
        history.push(data?.createTransmission.uuid)
    } catch (exception) {
      console.error(exception)
    }

  }

  return (
    <Box w="480px" alignContent="center">
      <form onSubmit={handleSubmit(onSubmit)}>
        <FormControl>
          <FormLabel>
            Name
          </FormLabel>
          <Input name="name" ref={register({ required: true })} />
          {errors.name && <span>This field is required</span>}
        </FormControl>

        <FormControl>
          <FormLabel>
            Type
          </FormLabel>
          <RadioGroup defaultValue={TransmissionTypes.LIVE}>
            <Stack spacing={4} direction="row">
              <Radio name="type" ref={register({ required: true })} value={TransmissionTypes.LIVE}>
                {TransmissionTypes.LIVE}
              </Radio>
              <Radio name="type" ref={register({ required: true })} value={TransmissionTypes.UPLOAD}>
                {TransmissionTypes.UPLOAD}
              </Radio>
            </Stack>
          </RadioGroup>
        </FormControl>

        <Button type="submit">
          Create
        </Button>
      </form>
    </Box>
  )
}

export default Create