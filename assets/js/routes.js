import React, { Fragment } from 'react'
import { Redirect, Route } from 'react-router-dom'

import MainLayout          from './containers/main'
import Forest              from './containers/forest'
import Registration        from './components/pages/registration'
import Session             from './components/pages/session'
import Channel             from './components/channel/Channel'

import PrivateRoute        from './components/auth'
import HomeView            from './components/home'
import TreeShowView        from './components/tree/show'
import LeafletShowView     from './components/leaflet/show'

export default function Routes(store) {

  return (
    <Fragment>
      <Route path="/sign_in" component={Session} />
      <Route path="/sign_up" component={Registration} />
      <Route exact path="/" render={() => <Redirect to="/sign_in"/>} />
      <MainLayout >
        <PrivateRoute path="/ic" component={Forest}/>
        <PrivateRoute exast path="/ic" component={HomeView}/>

        <PrivateRoute path="/ic/tree/:id" render={({match})=>
        <TreeShowView params={match.params}>
          <PrivateRoute path="leaflet/:id" component={LeafletShowView}/>
        </TreeShowView>} />
      </MainLayout>
      <PrivateRoute path="/channels/:id"component={Channel} />
    </Fragment>
  )
}
