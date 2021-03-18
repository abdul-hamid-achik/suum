import React from "react"
import { Box, FormControl, FormLabel, Input, Button } from "@chakra-ui/react"
import { useForm } from "react-hook-form"
import { useMutation, gql } from "@apollo/client"

const CREATE_TRANSMISSION = gql`
  mutation CreateTransmission($name: String!) {
    createTransmission(name: $name) {
      uuid,
      name,
      user_uuid
    }
  }
`

const Create = () => {
  const { register, handleSubmit, errors } = useForm()
  const [CreateTransmission] = useMutation<Pick<Transmission, "name" | "uuid">, Pick<Transmission, "name">>(CREATE_TRANSMISSION)
  const onSubmit = (payload: Pick<Transmission, "name">) => CreateTransmission({ variables: payload })

  return (
    <Box>
      <form onSubmit={handleSubmit(onSubmit)}>
        <FormControl>
          <FormLabel>
            Name
          </FormLabel>
          <Input name="name" register={register({ required: true })} />
          {errors.name && <span>This field is required</span>}
        </FormControl>

        <Button type="submit">
          Start
        </Button>
      </form>
    </Box>
  )
}

export default Create