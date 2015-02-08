AbstractModal = require './AbstractModal'

class OverlayDiagram extends AbstractModal

    name     : 'overlayDiagram'
    template : 'overlay-diagram'
    cb       : null

    constructor : (@cb) ->

        @templateVars = {@name}

        super()

        return null

    init : =>

        null

module.exports = OverlayDiagram
