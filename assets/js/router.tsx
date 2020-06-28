import React from 'react'
import Home from './pages/home.page.tsx'
import New from './pages/new.page.tsx'
import Call from './pages/call.page.tsx'

const routes = {
  '/': () => <Home />,
  '/new': () => <New />,
  '/scheduled-event/:eventId': ({ eventId }) => <Call id={eventId} />,
}

export default routes