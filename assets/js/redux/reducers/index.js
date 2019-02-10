import { combineReducers }  from 'redux'
import { routerReducer }    from 'react-router-redux'
import session              from './session'
import registration         from './registration'
import tree                 from './tree'
import currentTree          from './current_tree'
import currentLeaflet       from './current_leaflet'
import cap                  from './cap'
import messages             from './messages'
import channels             from './channels'
import local                from './local'
import error                from './error'
import directChannels       from './directChannels'
import user                 from './user'

const rootReducer = combineReducers({
  routing: routerReducer,
  session: session,
  registration: registration,
  cap: cap,
  tree: tree,
  currentTree: currentTree,
  currentLeaflet: currentLeaflet,
  messages: messages,
  channels: channels,
  directChannels: directChannels,
  user: user,
  local: local,
  error: error
})

export default rootReducer
