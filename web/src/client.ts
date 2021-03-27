import { ApolloClient, InMemoryCache, ApolloLink } from '@apollo/client'
import { setContext } from "@apollo/client/link/context"
import { hasSubscription } from '@jumpn/utils-graphql'
import * as AbsintheSocket from '@absinthe/socket'
import { createAbsintheSocketLink } from '@absinthe/socket-apollo-link'
import { createLink } from 'apollo-absinthe-upload-link'
import { Socket as PhoenixSocket } from 'phoenix'
import {env} from './constants'
import {getToken} from './token'

const HTTP_ENDPOINT = `${env?.HTTP_API_HOST || "http://localhost:4000"}/api`
const WS_ENDPOINT = `${env?.HTTP_API_HOST || "ws://localhost:4000"}/socket`

const uploadLink: ApolloLink = createLink({
    uri: HTTP_ENDPOINT
})

const socketLink = createAbsintheSocketLink(
    AbsintheSocket.create(new PhoenixSocket(WS_ENDPOINT))
)

const authLink = setContext((_, { headers }) => {
    const token = getToken()
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
