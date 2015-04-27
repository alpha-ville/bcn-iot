AbstractView = require '../AbstractView'
NumUtil = require('../../utils/NumUtil.coffee');

class HomeTooltip extends AbstractView

    template : 'home-tooltip'

    # events :
    #     "click" : "clickBreadcrumb"

    labels: null
    labelEn: null
    labelCat: null

    angleForMotion: 0
    motionAmplitude: 10
    motionSpeed: .05

    constructor : (@list) ->
        # @templateVars =
        #     list : @list

        super()

        @labels = []

        @labelEn = @el.querySelector('.en')
        @labelCat = @el.querySelector('.cat')
        @labels.push( @labelEn )

        # for easy testing
        # window.addEventListener( 'keyup', @onKeyUp )

        @addListeners()

        null


    addListeners: ->
        Backbone.Events.on( 'Tooltip:setCategory', @setCategory )
        Backbone.Events.on( 'Tooltip:setInstruction', @setInstruction )

        null

    onKeyUp: ( evt ) =>
        # 't' key on the keyboard
        if evt.keyCode != 84 then return

        @transitionOut( 'PLOP' )

    buildSpans: ->
        for label in @labels
            roughHTML = label.innerHTML
            spanHTML = ''

            for letter in roughHTML
                spanHTML += '<span>' + letter + '</span>'

            label.innerHTML = spanHTML

        null

    show: =>
        # if @el.classList.contains('hide') then @el.classList.remove('hide')
        @el.classList.add('transitionIn')

        null

    hide: =>
        @el.classList.remove('transitionIn')
        # if !@el.classList.contains('hide') then @el.classList.add('hide')

        null


    transitionIn: ( en, cat ) =>
        @el.classList.add('active')

        null


    transitionOut: ( en, cat ) =>
        @el.classList.remove('active')

        null


    setText: ( en, cat ) ->
        @labelEn.innerHTML = en
        # @labelCat.innerHTML = cat

        null

    setDefaultText: ( groupName ) ->

        en = (@B().groups.where group : @B().groupName())[0].get('group_name_en')
        cat = (@B().groups.where group : @B().groupName())[0].get('group_name_cat')

        @defaultEn = en
        @defaultCat = cat

        @setText @defaultEn, @defaultCat

        null

    update: ->
        @angleForMotion += @motionSpeed

        offset = Math.sin(@angleForMotion) * @motionAmplitude

        y = ( window.innerHeight / 2 ) - offset - 320 # minus central button radius
        transform = "translate(-50%, #{y}px)"

        @el.style.transform = transform

        null


    setCategory: ( category ) =>
        @labelEn.innerHTML = category

        null


    setInstruction: ( step ) =>
        @labelCat.innerHTML = step

        null

module.exports = HomeTooltip
