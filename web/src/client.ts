import { ApolloClient, createHttpLink, InMemoryCache, ApolloLink } from '@apollo/client'
import { setContext } from "@apollo/client/link/context"
import { hasSubscription } from '@jumpn/utils-graphql'
import * as AbsintheSocket from '@absinthe/socket'
import { createAbsintheSocketLink } from '@absinthe/socket-apollo-link'
import { createLink } from 'apollo-absinthe-upload-link'
import { Socket as PhoenixSocket } from 'phoenix'

const HTTP_ENDPOINT = '/api/graphql'
const WS_ENDPOINT = '/socket'

// @ts-ignore
// const httpLink = createHttpLink({
//     uri: HTTP_ENDPOINT
// })

const uploadLink: ApolloLink = createLink({
    uri: HTTP_ENDPOINT
})

const socketLink = createAbsintheSocketLink(
    AbsintheSocket.create(new PhoenixSocket(WS_ENDPOINT))
)

const authLink = setContext((_, { headers }) => {
    const token = localStorage.getItem('auth-token')
    return {
        headers: {
            ...headers,
            authorization: token ? `Bearer ${token}` : ''
        }
    }
})

// TODO: learn how to join these two if needed
// const link = 
//   ApolloLink.from([
//     socketLink, authLink, uploadLink, httpLink])

//     operation => hasSubscription(operation.query)

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
