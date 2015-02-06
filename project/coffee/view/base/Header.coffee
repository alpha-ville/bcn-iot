AbstractView = require '../AbstractView'

class Header extends AbstractView

	template : 'site-header'

	constructor : ->

		@templateVars =
			desc    : @B().locale.get "header_desc"
			home    : 
				label    : 'Go to homepage'
				url      : @B().BASE_PATH + '/' + @B().nav.sections.HOME
			example : 
				label    : 'Go to example page'
				url      : @B().BASE_PATH + '/' + @B().nav.sections.EXAMPLE

		super()

		return null

module.exports = Header
