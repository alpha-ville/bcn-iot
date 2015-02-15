NumUtil = require('../../../../utils/NumUtil');

class BasicShape

    id          : null

    _scene      : null

    g           : null
    stage       : null
    ctx         : null
    size        : null
    mass        : 0
    palette     : null
    color       : null
    config      : null

    #behavior
    vel         : null
    velRot      : null
    toX         : 0
    toY         : 0
    distanceToTargetMax : 0
    speedScale : 0

    behavior : 'target'


    constructor : (@config, size, scene) ->
        @id = String.fromCharCode(65 + Math.floor(Math.random() * 26)) + Date.now()

        # console.log size, scene

        @_scene = scene

        @w = size
        @h = size
        @mass = size
        @acc = Math.random()
        # config =
            # category : null
            # object_id : null
            # object_name: null
            # icon: null
            # data_type: null
            # value_type: null
            # video: null
            # image: null
            # copy_en: null
            # copy_cat: null

        @sprite = new PIXI.Sprite()
        @sprite.alpha = .7

        @g = new PIXI.Graphics()
        @g.beginFill @color

        @init()

        @sprite.addChild @g
        # @sprite.rotation = NumUtil.toRadians _.random(360)

        @vel =
            x: .5 * (( Math.random() * 2 ) - 1)
            y: .5 * (( Math.random() * 2 ) - 1)

        @setBehaviorProps()

        null


    init : =>
        # console.log 'override this'


    animate : =>
        null


    update: ->
        # -----------------
        # Basic behavior, apply constant force
        # -----------------
        if @behavior == 'basic'
            @applyForce @vel

        # -----------------
        # vibrate behavior
        # -----------------
        else if @behavior == 'vibrate'
            randVelX = (( Math.random() * ( @vel.x * 2 ) ) - @vel.x )
            randVelY = (( Math.random() * ( @vel.y * 2 ) ) - @vel.y )
            @sprite.x += randVelX
            @sprite.y += randVelY

        # -----------------
        # go to location behavior
        # -----------------
        else if @behavior == 'target'
            distanceToTarget = NumUtil.distanceBetweenPoints( {x: @toX, y: @toY}, {x: @sprite.x, y: @sprite.y} )

            if distanceToTarget < @distanceToTargetMax
                @setBehaviorProps()

            @sprite.position.x += @speedScale * ( @toX - @sprite.position.x) * .005
            @sprite.position.y += @speedScale * ( @toY - @sprite.position.y) * .005


        @sprite.rotation += @velRot

        null

    setBehaviorProps: ->
        @distanceToTargetMax = 10 + Math.floor Math.random() * 50
        @speedScale = Math.random() * 2
        if @speedScale < .3 then @speedScale += Math.random() * .7
        @toX = (Math.floor Math.random() * window.innerWidth) #/ window.devicePixelRatio;
        @toY = (Math.floor Math.random() * window.innerHeight) #/ window.devicePixelRatio;

        @velRot = .01 * (( Math.random() * 2 ) - 1)

        null

    applyForce: ( vec ) ->
        @sprite.position.x += vec.x
        @sprite.position.y += vec.y

        null


    # getAttractionForce: ->

    #     force =
    #         x: @toX - @sprite.position.x
    #         x: @toY - @sprite.position.y

    #     distance = force.mag();
    #     force.normalize();
    #       float strength = (G * mass * m.mass) / (distance * distance);
    #       force.mult(strength);

    #     Return the force so that it can be applied!
    #       return force;

    move : (x, y = 0) =>
        @sprite.position.x = x * window.devicePixelRatio
        @sprite.position.y = y * window.devicePixelRatio
        null

    width  : => return @w
    height : => return @h
    radius : => return @w / 2

module.exports = BasicShape
