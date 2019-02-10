import { Presence } from 'phoenix'
import { camelizeKeys } from 'humps'

import { syncPresences, addUser } from '../redux/actions/user'
import Actions from '../redux/actions/session'
import { addDirectChannel, openDirectChannel } from '../redux/actions/directChannels'
import { addChannel } from '../redux/actions/channels'

const EventSocket = {
  initEventChannel(dispatch, options) {
    let channel = Actions.findChannel('general', null, 'event')
    EventSocket.initGlobalCallbacks(channel, dispatch)
    let userChannel = Actions.findChannel(`general:${Actions.currentUser('userId')}`, null, 'event')
    EventSocket.initUserCallbacks(userChannel, dispatch, options)
  },

  initGlobalCallbacks(channel, dispatch) {
    let presences = {}
    channel.on("presence_state", state => {
      Presence.syncState(presences, state)
      dispatch(syncPresences(presences))
    })
    channel.on("presence_diff", diff => {
      Presence.syncDiff(presences, diff)
      dispatch(syncPresences(presences))
    })
    channel.on("user_created", payload => {
      dispatch(addUser(payload))
    })
    channel.on("channel_created", payload => {
      dispatch(addChannel(payload, dispatch))
    })
  },

  initUserCallbacks(channel, dispatch, options) {
    channel.on("dm_created", payload => {
      dispatch(addDirectChannel(camelizeKeys(payload), options.user, dispatch))
    })
    channel.on("dm_open", payload => {
      dispatch(openDirectChannel(camelizeKeys(payload), options.user))
    })
  },

  handleEvent(event, data) {

  }
}

export default EventSocket
