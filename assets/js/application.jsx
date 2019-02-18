import '@babel/polyfill'
import React               from 'react'
import ReactDOM            from 'react-dom'
import 'semantic-ui-css/semantic.min.css'
import { Provider }        from 'react-redux'
import { Router }          from 'react-router'

import configureStore      from './redux/initialState/configureStore'
import history             from './utils/history'
import Routes              from './routes'

const store = configureStore()

ReactDOM.render(
<Provider store={store}>
  <Router history={history}>
    <Routes/>
  </Router>
</Provider>,
  document.getElementById('main_container')
)
