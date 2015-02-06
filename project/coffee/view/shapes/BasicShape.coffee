class BasicShape

    g         : null
    stage     : null
    ctx       : null
    size      : null

    constructor : (@w, @h = 0) ->
        @sprite = new PIXI.Sprite()
        @g = new PIXI.Graphics()
        @init()

        @sprite.addChild @g
        null

    init : =>
        console.log 'override this'

    move : (x, y = 0) =>
        @sprite.x = x
        @sprite.y = y
        null

    width  : => return @w
    height : => return @h
    radius : => return @w / 2



module.exports = BasicShape
