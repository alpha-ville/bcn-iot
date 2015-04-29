class Letter

    el: null
    style: null

    angle: 0
    speed: 0
    rotationSpeed: 0
    pos: null
    originPos: null

    cx: 0
    cy: 0
    radius: 50

    shouldUpdate: null

    vx: 0
    vy: 0
    vr: 0

    spring: 0.03
    friction: 0.88

    rotation: 0

    constructor: ( _el, @originPosX ) ->
        @el = _el

        @style = @el.style

        @angle = Math.random() * 360
        @speed = Math.random() * .2

        @rotation = Math.random() * 360
        @rotationSpeed = Math.random() * .1

        @originPos =
         x: @originPosX
         y: 0

        @pos = @originPos

        @shouldUpdate = true

        @cx = window.innerWidth/2
        @cy = 0

        @el.classList.add( 'transitionIn' )

        null


    update: ( angle ) =>
        if @shouldUpdate
            @angle += @speed
            @rotation += @rotationSpeed

            @pos.x = Math.floor( @cx + @radius * Math.cos( @angle ) )
            @pos.y = Math.floor( @cy + @radius * Math.sin( @angle ) )
        else
            @stick()

        @updatePos()

        null


    stick: =>
        offsetX = ( window.innerWidth - 167 ) / 2 # 167 = IOTORAMA word width

        #pos x
        dx = ( offsetX + @originPosX) - @pos.x

        # if Math.abs dx < .0001 then return

        ax = dx * @spring;
        @vx += ax;
        @vx *= @friction;
        @pos.x += @vx;

        # pos y
        dy = 0 - @pos.y
        ay = dy * @spring;
        @vy += ay;
        @vy *= @friction;
        @pos.y += @vy;

        # rotation
        dr = 0 - @rotation
        ar = dr * @spring;
        @vr += ar;
        @vr *= @friction;
        @rotation += @vr;

        # too expensive
        # @tween = new TweenMax( @pos, 1, { x: @originPos.x, y: @originPos.y, ease: Elastic.easeOut, onUpdate: @updatePos } )

        null


    stop: =>
        setTimeout =>
            @shouldUpdate = false
        , Math.random() * 1300

        null


    updatePos: =>
        transform = "translate(#{@pos.x}px, #{@pos.y}px) rotate(#{@rotation}deg)"

        @style.webkitTransform = transform
        @style.MozTransform = transform
        @style.msTransform = transform
        @style.OTransform = transform
        @style.transform = transform


        null

module.exports = Letter
