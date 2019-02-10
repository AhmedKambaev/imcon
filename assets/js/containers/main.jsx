import React from 'react'

class MainLayout extends React.Component {
  constructor() {
    super()
  }
  render() {
    return (
      <React.Fragment>
        {this.props.children}
      </React.Fragment>
    )
  }
}

export default MainLayout