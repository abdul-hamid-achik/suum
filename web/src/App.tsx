import * as React from "react"
import {
  ChakraProvider,
  theme
} from "@chakra-ui/react"
import {
  BrowserRouter as Router,
  Redirect,
  Switch,
  Route
} from "react-router-dom"
import { ApolloProvider } from '@apollo/client'
import Navbar from './components/navbar'
import client from './client'
import Pages from "./pages"
import { Urls } from './constants'
import { getToken } from './token'

// @ts-ignore
function PrivateRoute({ component: Component, ...rest }) {
  const isAuthenticated = getToken()
  return (
    <Route
      {...rest}
      render={props =>
        isAuthenticated ? (
          <Component {...props} />
        ) : (
          <Redirect
            to={{
              pathname: Urls.SIGN_IN,
              state: { from: props.location }
            }}
          />
        )
      }
    />
  );
}

export const App: React.FC = () => (
  <ApolloProvider client={client}>
    <ChakraProvider theme={theme}>
      <Router>
        <Navbar />
        <Switch>
          <Route path={Urls.SIGN_IN} component={Pages.SignIn} />
          <Route path={Urls.SIGN_UP} component={Pages.SignUp} />
          <PrivateRoute path={Urls.CREATE_TRANSMISSION} component={Pages.Transmissions.Create} />
          <PrivateRoute path={Urls.EDIT_TRANSMISSION} component={Pages.Transmissions.Edit} />
          <Route path={Urls.VIEW_TRANSMISSION} component={Pages.Transmissions.View} />
          <Route exact path="/" component={Pages.Main} />
        </Switch>
      </Router>
    </ChakraProvider >
  </ApolloProvider>
)
