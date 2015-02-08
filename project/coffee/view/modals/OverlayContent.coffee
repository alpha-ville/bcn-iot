AbstractModal = require './AbstractModal'

class OverlayContent extends AbstractModal

	name     : 'overlayContent'
	template : 'overlay-content'
	cb       : null

	constructor : (@cb) ->

		@templateVars = {@name}

		super()

		return null

	init : =>

		null

module.exports = OverlayContent
