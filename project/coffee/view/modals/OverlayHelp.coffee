AbstractModal = require './AbstractModal'

class OverlayHelp extends AbstractModal

    name     : 'overlayHelp'
    template : 'overlay-help'
    cb       : null
    called   : false

    events:
        'click ul>li' : "toggleLang"
        'click .close-button' : "closeButton"
        # 'tap ul>li' : "toggleLang"

    constructor : (@cb) ->
        @templateVars =
            first_paragraph_en   : @B().credits.at(0).get 'first_paragraph_en'
            first_paragraph_cat  : @B().credits.at(0).get 'first_paragraph_cat'
            second_paragraph_en  : @B().credits.at(0).get 'second_paragraph_en'
            second_paragraph_cat : @B().credits.at(0).get 'second_paragraph_cat'
            circle_name_en       : @B().credits.at(0).get 'circle_name_en'
            circle_name_cat      : @B().credits.at(0).get 'circle_name_cat'
            square_name_en       : @B().credits.at(0).get 'square_name_en'
            square_name_cat      : @B().credits.at(0).get 'square_name_cat'
            triangle_name_en     : @B().credits.at(0).get 'triangle_name_en'
            triangle_name_cat    : @B().credits.at(0).get 'triangle_name_cat'
            third_paragraph_en   : @B().credits.at(0).get 'third_paragraph_en'
            third_paragraph_cat  : @B().credits.at(0).get 'third_paragraph_cat'
            people_en            : @B().credits.at(0).get 'people_en'
            people_cat           : @B().credits.at(0).get 'people_cat'
            fourth_paragraph_en  : @B().credits.at(0).get 'fourth_paragraph_en'
            fourth_paragraph_cat : @B().credits.at(0).get 'fourth_paragraph_cat'

        super()

        return null

    closeButton : =>
        ###
        hack touch
        ###
        return if @called
        @called = true

        dest = if @B().prevPage then @B().prevPage.join('/') else ""
        @B().router.navigateTo dest
        null

    toggleLang : (e) =>
        @$el.find('li').each (a, b) =>
            $(b).removeAttr('data-selected')

        if e
            $(e.currentTarget).attr 'data-selected', true
            @B().langSelected = $(e.currentTarget).attr('data-lang')
        else
            $(@$el.find('li[data-lang="' + @B().langSelected + '"]')).attr 'data-selected', true

        @$el.find('[data-lang]').not("li").each (a, b) =>
            $(b).css
                display : if $(b).attr('data-lang') is @B().langSelected then 'block' else 'none'

        null

    init : =>
        @toggleLang()
        @animate()
        null

    animate : =>
        margin = 30

        delay = .2

        bts = $(@$el.find('.lang-buttons')[0])
        TweenMax.to bts, .5, 'margin-top' : margin, opacity: 1, delay: delay

        cb = $(@$el.find('.close-button')[0])
        TweenMax.to cb, .5, 'margin-top' : 8, opacity: 1, delay: delay

        t = $(@$el.find('h1')[0])
        TweenMax.to t, .5, opacity: 1, 'margin-top': 60, delay: delay + .3

        cont = @$el.find('p')
        TweenMax.to cont, .5, opacity: 1, delay: delay + .7

        cont = @$el.find('hr')
        TweenMax.to cont, .5, opacity: 1, delay: delay + .5

        @$el.find('.container-shape-help .object-container').each (a, b) ->
            TweenMax.to b, 0, y : -20
            TweenMax.to b, .5, y : 0, opacity: 1, delay: (delay + (a * .1)) + .5

        null



module.exports = OverlayHelp
