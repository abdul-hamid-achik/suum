import * as React from "react"
import {
  ChakraProvider,
  theme
} from "@chakra-ui/react"
import {
  BrowserRouter as Router,
  Switch,
  Route
} from "react-router-dom"
import { ApolloProvider } from '@apollo/client'
import { ColorModeSwitcher } from "./ColorModeSwitcher"
import client from './client'
import Pages from "./pages"

export const App: React.FC = () => {
  return (
    <ApolloProvider client={client}>

      <ChakraProvider theme={theme}>
        <ColorModeSwitcher justifySelf="flex-end" />
        <Router>
          <Switch>
            <Route path="/signin" component={Pages.SignIn} />
            <Route path="/signup" component={Pages.SignUp} />
            <Route exact path="/" component={Pages.Main} />
          </Switch>
        </Router>
      </ChakraProvider >
    </ApolloProvider>
  )
}