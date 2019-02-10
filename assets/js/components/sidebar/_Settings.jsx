import React, { Component } from 'react'
import { PropTypes }          from 'prop-types'
import { Button, Divider, Dropdown, Container, Grid, Icon, Image, Item, Label, Menu, Segment, Step, Table, } from 'semantic-ui-react'

import Actions      from '../../redux/actions/session'

class Settings extends Component {
  _signOut(e) {
    e.preventDefault()

    const {dispatch} = this.props
    dispatch(Actions.signOut())
  }

  render() {
    const {dispatch} = this.props
    let title = Actions.currentUser('username')
    return (
      <Dropdown>
      <Dropdown.Menu>
      <Dropdown.Item onClick={::this._signOut}>Sign Out</Dropdown.Item>
      </Dropdown.Menu>
      </Dropdown>
    )
  }
}

Settings.propTypes = {
  dispatch: PropTypes.func
}

export default Settings
