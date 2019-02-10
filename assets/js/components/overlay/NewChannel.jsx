import React from 'react'
import { Modal } from 'react-bootstrap'

import { closeNewChannelModal } from '../../redux/actions/local'
import { createChannel } from '../../redux/actions/channels'
import ErrorMessage from '../shared/ErrorMessage'

class NewChannel extends React.Component {
  close() {
    const {dispatch} = this.props
    dispatch(closeNewChannelModal())
  }

  confirm() {
    const {dispatch} = this.props
    let name = this.refs.newChannelName.value
    dispatch(createChannel(name))
  }

  render() {
    const {local, error} = this.props
    return (
      <Modal show={local.openNewChannelModal} onHide={::this.close}>
        <Modal.Header closeButton>
          <Modal.Title>New Channel</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <ErrorMessage error={error}></ErrorMessage>
          <input type="text" className="form-control" placeholder="New Channel Name"
                 ref="newChannelName"></input>
        </Modal.Body>
        <Modal.Footer>
          <button className='btn btn-success' onClick={::this.confirm}>Create</button>
        </Modal.Footer>
      </Modal>
    )
  }
}

export default NewChannel
