NumUtil = require '../../utils/NumUtil'

class BasicShape

    g       : null
    stage   : null
    ctx     : null
    size    : null
    palette : null
    color   : null
    vel     : null
    velRot  : null
    config  : null

    constructor : (@config, @w = _.random(10, 60) / window.devicePixelRatio) ->

        console.log @config

        @h = @w

        # config =
        #     category   : null
        #     id         : null
        #     name       : null
        #     icon       : null
        #     data_type  : null
        #     data_value : null
        #     video      : null
        #     image      : null

        @sprite = new PIXI.Sprite()

        @g = new PIXI.Graphics()
        @g.beginFill @color

        @init()

        @sprite.addChild @g
        # @sprite.rotation = NumUtil.toRadians _.random(360)

        @vel =
            x: .1 * (( Math.random() * 2 ) - 1)
            y: .1 * (( Math.random() * 2 ) - 1)

        @velRot = .01 * (( Math.random() * 2 ) - 1)

        null

    init : =>
        console.log 'override this'

    animate : =>
        null

    update: ->
        @sprite.x += @vel.x
        @sprite.y += @vel.y

        @sprite.rotation += @velRot

        null

    move : (x, y = 0) =>
        @sprite.x = x
        @sprite.y = y
        null

    width  : => return @w
    height : => return @h
    radius : => return @w / 2

module.exports = BasicShape
