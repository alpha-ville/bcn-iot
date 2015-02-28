AbstractView = require '../AbstractView'
NumUtil = require('../../utils/NumUtil.coffee');

class HomeTooltip extends AbstractView

    template : 'home-tooltip'

    events :
        "click" : "clickBreadcrumb"

    labels: null
    labelEn: null
    labelCat: null

    angleForMotion: 0
    motionAmplitude: 10
    motionSpeed: .05

    constructor : (@list) ->
        # @templateVars =
        #     list : @list

        @nameMap = 
            'environment':
                'en': 'Environment'
                'cat': 'cartorn urbà i natural'
            'home':
                'en': 'home'
                'cat': 'La Llar'
            'body_mind':
                'en': 'Body & Mind'
                'cat': 'Cos i Ment'
            'culture':
                'en': 'Culture'
                'cat': 'Cultura'
            'diy':
                'en': 'DIY'
                'cat': 'Creació pròpia'
            'social':
                'en': 'Social'
                'cat': 'Vida Social'

        super()

        @labels = []

        @labelEn = @el.querySelector('.en')
        @labelCat = @el.querySelector('.cat')
        @labels.push( @labelEn )

        # for easy testing
        window.addEventListener( 'keyup', @onKeyUp )

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
        if @el.classList.contains('hide') then @el.classList.remove('hide')

        null

    hide: =>
        if !@el.classList.contains('hide') then @el.classList.add('hide')

        null


    transitionIn: ( en, cat ) ->
        @el.classList.add('active')

        @setText( en, cat )        

        null


    transitionOut: ( en, cat ) ->
        @el.classList.remove('active')

        @setText @defaultEn, @defaultCat
        

        null


    setText: ( en, cat ) ->
        @labelEn.innerHTML = en
        @labelCat.innerHTML = cat

        null

    setDefaultText: ( groupName ) ->
        en = @nameMap[groupName]['en']
        cat = @nameMap[groupName]['cat']

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

module.exports = HomeTooltip
