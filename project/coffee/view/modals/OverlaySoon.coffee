AbstractModal = require './AbstractModal'

class OverlaySoon extends AbstractModal

    name     : 'overlaySoon'
    template : 'overlay-soon'
    cb       : null

    slides: null

    currentIdx: 0
    currentSlide: null

    events:
        'click #btn-explore' : 'startExperience'


    constructor : (@cb) ->
        super()

        @slides = @el.querySelectorAll('.slide')

        @currentSlide = @slides[0]

        return null

    startExperience : =>
        @B().router.navigateTo @B().groupName()
        null

    init : =>
        # @animate()
        null

    animate : =>
        # setInterval( @goToNextSlide, 8000 )

        null

    # goToNextSlide: =>
    #     @currentSlide.classList.remove('active')

    #     @currentIdx++
    #     if @currentIdx > 3 then @currentIdx = 0

    #     @currentSlide = @slides[ @currentIdx ]

    #     @currentSlide.classList.add('active')

        null





module.exports = OverlaySoon
