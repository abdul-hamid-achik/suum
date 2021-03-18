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
import Navbar from './components/navbar'
import client from './client'
import Pages from "./pages"
import { Urls } from './constants'

export const App: React.FC = () => (
  <ApolloProvider client={client}>
    <ChakraProvider theme={theme}>
      <Router>
        <Navbar />
        <Switch>
          <Route path={Urls.SIGN_IN} component={Pages.SignIn} />
          <Route path={Urls.SIGN_UP} component={Pages.SignUp} />
          <Route path={Urls.CREATE_TRANSMISSION} component={Pages.Transmissions.Create} />
          <Route path={Urls.EDIT_TRANSMISSION} component={Pages.Transmissions.Edit} />
          <Route exact path="/" component={Pages.Main} />
        </Switch>
      </Router>
    </ChakraProvider >
  </ApolloProvider>
)
