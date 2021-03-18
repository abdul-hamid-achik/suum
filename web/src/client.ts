import { ApolloClient, InMemoryCache, ApolloLink } from '@apollo/client'
import { setContext } from "@apollo/client/link/context"
import { hasSubscription } from '@jumpn/utils-graphql'
import * as AbsintheSocket from '@absinthe/socket'
import { createAbsintheSocketLink } from '@absinthe/socket-apollo-link'
import { createLink } from 'apollo-absinthe-upload-link'
import { Socket as PhoenixSocket } from 'phoenix'
import env from 'react-dotenv'

const HTTP_ENDPOINT = `${env.HTTP_API_HOST}/api`
const WS_ENDPOINT = `${env.HTTP_API_HOST}/socket`

const uploadLink: ApolloLink = createLink({
    uri: HTTP_ENDPOINT
})

const socketLink = createAbsintheSocketLink(
    AbsintheSocket.create(new PhoenixSocket(WS_ENDPOINT))
)

const authLink = setContext((_, { headers }) => {
    const token = sessionStorage.getItem('auth-token')
    return {
        headers: {
            ...headers,
            authorization: token ? `Bearer ${token}` : ''
        }
    }
})


const link = ApolloLink.split(
    operation => hasSubscription(operation.query),
    // @ts-ignore
    socketLink,
    authLink.concat(uploadLink)
)

const client = new ApolloClient({
    link: link,
    cache: new InMemoryCache()
})

export default client
