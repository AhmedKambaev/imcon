import '@babel/polyfill'
import React, { Component, Fragment } from 'react'
import ReactDOM                       from 'react-dom'
import { Redirect, Route, Switch }    from 'react-router-dom'
import { Provider }        from 'react-redux'
import { ConnectedRouter } from 'connected-react-router'
import { Router }          from  'react-router'

import MainLayout          from './containers/main'
import Forest              from './containers/forest'
import Registration        from './components/pages/registration'
import Session             from './components/pages/session'
import Channel             from './components/channel/Channel'

import HomeView            from './components/home'
import TreeShowView        from './components/tree/show'
import LeafletShowView     from './components/leaflet/show'

import configureStore      from './redux/initialState/configureStore'
import history             from './utils/history'


const store = configureStore()

store.subscribe(() => {
  const state = store.getState()

  console.log(state)
})

const { session } = store.getState()
const { currentUser } = session

const isAuthenticated = currentUser != null

const PrivateRoute = ({ component: Comp, ...rest }) => (
      <Route {...rest} render={props => (
        isAuthenticated
        ? (<Comp {...props} />)
        : (<Redirect to={{pathname: "/sign_in", state: {from: props.location}
      }}/>
    )
  )}/>
)

ReactDOM.render(
<Provider store={store}>
  <Router history={history}>
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
  </Router>
</Provider>,
  document.getElementById('main_container')
)