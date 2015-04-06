AbstractViewPage  = require '../AbstractViewPage'
InteractiveCanvas = require './InteractiveCanvas/InteractiveCanvas'

class HomeView extends AbstractViewPage

	template : 'page-home'

	constructor : ->

		# @templateVars =
		# 	desc : @B().locale.get "home_desc"

		@interactive = new InteractiveCanvas

		super()

		@
			.addChild(@interactive)

		return null

module.exports = HomeView
