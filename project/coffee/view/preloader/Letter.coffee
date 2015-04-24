class Letter

    el: null

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
        #pos x
        dx = ( 80 + @originPosX) - @pos.x
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

        # console.log dx


        # @tween = new TweenMax( @pos, 1, { x: @originPos.x, y: @originPos.y, ease: Elastic.easeOut, onUpdate: @updatePos } )

        null


    stop: =>
        setTimeout =>
            @shouldUpdate = false
        , Math.random() * 2000

        null


    updatePos: =>
        # console.log  @rotation
        transform = "translate(#{@pos.x}px, #{@pos.y}px) rotate(#{@rotation}deg)"
        @el.style.transform = transform

        null

module.exports = Letter
