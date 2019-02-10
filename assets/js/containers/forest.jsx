import React, { Component } from 'react'
import { PropTypes }          from 'prop-types'
import { connect } from 'react-redux'

import Sidebar from '../components/sidebar/Sidebar'
import Overlay from '../components/overlay/Index'

import {fetchChannelsIfNeeded} from '../redux/actions/channels'
import {fetchDirectChannels} from '../redux/actions/directChannels'
import {fetchUser} from '../redux/actions/user'
import EventSocket from '../socket/event_socket'

import TreeActions     from '../redux/actions/tree'
import Cap             from '../components/cap'


class Forest extends Component {
  componentDidMount () {
    const { dispatch, user } = this.props

    dispatch(TreeActions.fetchTree())
    dispatch(fetchUser((response, store)=> {
      store.dispatch(fetchDirectChannels(response.entities.user))
      EventSocket.initEventChannel(dispatch, {user: response.entities.user})
    }))
    dispatch(fetchChannelsIfNeeded())
  }
  render() {
    const {currentUser, dispatch, tree, socket, currentTree, channels, children, local, errors, directChannels, user} = this.props

    return (
    <div id="authentication_container" className="application-container">
      <Cap  />
        <div className="main-container" >
          { this.props.children || 'Приветствую в нашем лесу!' }
        </div>
      <div className='main-container'>
        <Overlay {...{local, channels, dispatch, errors, user} }></Overlay>
        <div className="navigate-sidebar" style={style.container}>
          <Sidebar dispatch={dispatch} channels={channels} directChannels={directChannels} user={user}/>
        </div>
        <div className="main-container">

          { children || 'Добро пожаловать в чат!'  }
        </div>
      </div>
    </div>
    )
  }
}

const style = {
  container: {
    height: '100%'
  }
}

Forest.propTypes = {
  channels: PropTypes.object,
  children: PropTypes.node,
  local: PropTypes.object
}

function mapStateToProps(state) {
  return {
    currentUser: state.session.currentUser,
    socket: state.session.socket,
    channel: state.session.channel,
    tree: state.tree,
    currentTree: state.currentTree,
    channels: state.channels,
    directChannels: state.directChannels,
    local: state.local,
    error: state.error,
    user: state.user
  }
}

export default connect(
  mapStateToProps
)(Forest)