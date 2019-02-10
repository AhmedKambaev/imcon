import * as types from '../constants/ActionTypes'
import { API_CALL, POST, GET, PUT, DELETE } from '../constants/ApiTypes'
import Schemas from '../initialState/schema'

export function fetchUser(callback) {
  return {
    type: types.FETCH_USER,
    [API_CALL]: {
      path: '/session',
      method: GET,
      schema: Schemas.userArray,
      successCallback: callback
    }
  }
}

export function addUser(user) {
  return {
    type: types.ADD_USER,
    payload: {user}
  }
}

export function syncPresences(data) {
  return {
    type: types.SYNC_USER_PRESENCES,
    payload: data
  }
}
