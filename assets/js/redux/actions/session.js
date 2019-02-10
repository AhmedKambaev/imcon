import { push }                           from 'react-router-redux'
import Constants                          from '../constants'
import { Socket }                         from 'phoenix'
import { httpGet, httpPost, httpDelete }  from '../../utils'

export function setCurrentUser(dispatch, user) {
  const socket = new Socket('/socket', {
    params: { token: localStorage.getItem('phoenixAuthToken') },
    logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data) },
  })

  socket.connect()
  Actions.connAvaiable()
  const channel = socket.channel(`user:${user.id}`)

  if (channel.state != 'joined') {
    channel.join().receive('ok', () => {
      dispatch({
        type: Constants.CURRENT_USER,
        currentUser: user,
        socket: socket,
        channel: channel,
      })
    })
  }

  channel.on('tree:add', (msg) => {
    dispatch({
        type: Constants.TREE_ADDED,
        tree: msg.tree,
      })
  })
}



const Actions = {
  
  signIn: (email, password) => {
    return dispatch => {
      const data = {
        session: {
          email: email,
          password: password,
        },
      }
      httpPost('/api/v1/session', data)
      .then((data) => {
        localStorage.setItem('phoenixAuthToken', data.jwt)
        setCurrentUser(dispatch, data.user)
        dispatch(push('/ic'))
      })
      .catch((error) => {
        error.response.json()
        .then((errorJSON) => {
          dispatch({
            type: Constants.SESSION_ERROR,
            error: errorJSON.error,
          })
        })
      })
    }
  },
  
  disconnect() {
    if (!this.socket) { return }
    this.socket.disconnect(()=> {
      this.socket.reconnectTimer.reset()
      this.socket = null
      console.log('Socket disconnected!')
    })
  },

  connAvaiable() {
    return this.socket && (this.socket.connectionState() === 'open' ||
                           this.socket.connectionState() === 'connecting')
  },

  socketAvaiable() {
    this.socket && this.socket.connectionState() === 'closing'
  },

  findChannel(id, callback, prefix = 'channel') {
    if (!this.socket) {
      console.error("No socket connection, please connect first")
      return false
    }
    let topicName = `${prefix}:${id}`
    let foundChannel = _.find(this.socket.channels, (ch)=> ch.topic === topicName)
    if (!foundChannel) {
      foundChannel = this.socket.channel(topicName, {})
    }
    if (foundChannel.state === 'closed') {
      foundChannel.join().receive('ok', data => {
        console.log(`Joined ${foundChannel.topic}`)
        if (_.isFunction(callback)) {
          callback(data)
        }
      })
    }
    return foundChannel
  },

  currentUser: () => {
    return dispatch => {
      const authToken = localStorage.getItem('phoenixAuthToken')

      httpGet('/api/v1/current_user')
      .then(function (data) {
        setCurrentUser(dispatch, data)
      })
      .catch(function (error) {
        console.log(error)
        dispatch(push('/sign_in'))
      })
    }
  },
  
  reDirect: () => {return dispatch => dispatch(push('/sign_in'))},

  signOut: () => {
    return dispatch => {
      
      httpDelete('/api/v1/session')
      .then((data) => {
        localStorage.removeItem('phoenixAuthToken')
        disconnect()
        dispatch({ type: Constants.USER_SIGNED_OUT, })

        dispatch(push('/sign_in'))

        dispatch({ type: Constants.TREE_FULL_RESET })
      })
      .catch(function (error) {
        console.log(error)
      })
    }
  },
}

export default Actions
