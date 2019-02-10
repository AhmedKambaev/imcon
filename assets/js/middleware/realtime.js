import { RT_EVENT } from '../redux/constants/ApiTypes'
import Actions                     from '../redux/actions/session'

export default store => next => action => {
  const rtEvent = action[RT_EVENT]
  if (typeof rtEvent === 'undefined') {
    return next(action)
  }

  let {channelId, event, payload} = rtEvent

  if (!channelId) {
    throw new Error('No channel!')
  }
  if (!event) {
    throw new Error('No event!')
  }
  if (!payload) {
    throw new Error('No payload!')
  }

  function actionWith(params) {
    const finalAction = Object.assign({}, action, params)
    delete finalAction[RT_EVENT]
    return finalAction
  }

  let foundChannel = Actions.findChannel(channelId)
  foundChannel.push(event, payload)
    .receive('ok', (msg) => {
      next(actionWith({type: action.type + '_SUCCESS'}))
    })

  return next(actionWith({}))
}
