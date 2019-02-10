import history from '../../utils/history'
import { decamelizeKeys } from 'humps'

import * as types from '../constants/ActionTypes'
import { API_CALL, POST, GET, PUT, DELETE } from '../constants/ApiTypes'
import Schemas from '../initialState/schema'
import {fetchChannels, initChannel, changeChannel} from './channels'

export function fetchDirectChannels(user) {
  let result = fetchChannels((dispatch)=> {
    console.log('INIT DIRECT CHANNELS DONE')
    dispatch(initDirectChannelsDone())
  })
  return {
    ...result,
    type: types.FETCH_DIRECT_CHANNELS,
    payload: {
      user
    },
    [API_CALL]: {
      ...result[API_CALL],
      path: '/direct_channels'
    }
  }
}

export function joinDirectChannel(userId, user) {
  return {
    type: types.JOIN_DIRECT_CHANNEL,
    [API_CALL]: {
      path: '/direct_channels/join',
      method: POST,
      data: decamelizeKeys({
        userId: userId
      }),
      successCallback: function(channel, store) {
        let channelName = user[channel.userId].username
        initChannel(channel, store.dispatch, ()=> {
          history.push(`/channels/@${channelName}`)
          store.dispatch(changeChannel(channelName))
        })
      }
    },
    payload: {
      user
    }
  }
}

export function addDirectChannel(channel, user, dispatch) {
  let channelName = user[channel.userId].username
  initChannel(channel, dispatch)
  return {
    type: types.ADD_DIRECT_CHANNEL,
    payload: {channel, user}
  }
}

export function openDirectChannel({channelId}) {
  return {
    type: types.OPEN_DIRECT_CHANNEL,
    payload: {channelId}
  }
}

export function initDirectChannelsDone() {
  return {
    type: types.INIT_DIRECT_CHANNELS_DONE
  }
}
