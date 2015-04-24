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
            installation_photos        : @B().credits.at(0).get('installation_photos')
            first_paragraph_en         : @B().credits.at(0).get 'first_paragraph_en'
            first_paragraph_cat        : @B().credits.at(0).get 'first_paragraph_cat'
            how_it_works_en            : @B().credits.at(0).get 'how_it_works_en'
            how_it_works_cat           : @B().credits.at(0).get 'how_it_works_cat'
            how_it_works_paragraph_en  : @B().credits.at(0).get 'how_it_works_paragraph_en'
            how_it_works_paragraph_cat : @B().credits.at(0).get 'how_it_works_paragraph_cat'
            credits_title_en           : @B().credits.at(0).get 'credits_title_en'
            credits_title_cat          : @B().credits.at(0).get 'credits_title_cat'
            credits_paragraph_en       : @B().credits.at(0).get 'credits_paragraph_en'
            credits_paragraph_cat      : @B().credits.at(0).get 'credits_paragraph_cat'
            project_by_en              : @B().credits.at(0).get 'project_by_en'
            project_by_cat             : @B().credits.at(0).get 'project_by_cat'
            project_commission_en      : @B().credits.at(0).get 'project_commission_en'
            project_commission_cat     : @B().credits.at(0).get 'project_commission_cat'
            concept_title_en           : @B().credits.at(0).get 'concept_title_en'
            concept_title_cat          : @B().credits.at(0).get 'concept_title_cat'
            concept_paragraph_en       : @B().credits.at(0).get 'concept_paragraph_en'
            concept_paragraph_cat      : @B().credits.at(0).get 'concept_paragraph_cat'
            design_title_en            : @B().credits.at(0).get 'design_title_en'
            design_title_cat           : @B().credits.at(0).get 'design_title_cat'
            design_paragraph_en        : @B().credits.at(0).get 'design_paragraph_en'
            design_paragraph_cat       : @B().credits.at(0).get 'design_paragraph_cat'
            tech_title_en              : @B().credits.at(0).get 'tech_title_en'
            tech_title_cat             : @B().credits.at(0).get 'tech_title_cat'
            tech_paragraph_en          : @B().credits.at(0).get 'tech_paragraph_en'
            tech_paragraph_cat         : @B().credits.at(0).get 'tech_paragraph_cat'
            installation_title_en      : @B().credits.at(0).get 'installation_title_en'
            installation_title_cat     : @B().credits.at(0).get 'installation_title_cat'
            installation_photos        : @B().credits.at(0).get 'installation_photos'
            installation_paragraph_en  : @B().credits.at(0).get 'installation_paragraph_en'
            installation_paragraph_cat : @B().credits.at(0).get 'installation_paragraph_cat'
            exhibition_title_en        : @B().credits.at(0).get 'exhibition_title_en'
            exhibition_title_cat       : @B().credits.at(0).get 'exhibition_title_cat'
            exhibition_paragraph_en    : @B().credits.at(0).get 'exhibition_paragraph_en'
            exhibition_paragraph_cat   : @B().credits.at(0).get 'exhibition_paragraph_cat'
            copyright_en               : @B().credits.at(0).get 'copyright_en'
            copyright_cat              : @B().credits.at(0).get 'copyright_cat'

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

        photo = $(@$el.find('.object-list-container')[0])
        setTimeout =>
            photo.slick
                  dots          : false
                  infinite      : true
                  speed         : 1000
                  arrows        : true
                  slidesToShow  : 1
        , 100

        @animate()
        null

    animate : =>
        margin = 30

        delay = .2

        bts = $(@$el.find('.lang-buttons')[0])
        TweenMax.to bts, .5, 'margin-top' : margin, opacity: 1, delay: delay

        cb = $(@$el.find('.close-button')[0])
        TweenMax.to cb, .5, 'margin-top' : 8, opacity: 1, delay: delay

        # t = $(@$el.find('h1')[0])
        # TweenMax.to t, .5, opacity: 1, 'margin-top': 60, delay: delay + .3

        cont = @$el.find('p')
        TweenMax.to cont, .5, opacity: 1, delay: delay + .7

        cont = @$el.find('hr')
        TweenMax.to cont, .5, opacity: 1, delay: delay + .5

        @$el.find('.container-shape-help .object-container').each (a, b) ->
            TweenMax.to b, 0, y : -20
            TweenMax.to b, .5, y : 0, opacity: 1, delay: (delay + (a * .1)) + .5

        null



module.exports = OverlayHelp
