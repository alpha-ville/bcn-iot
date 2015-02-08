ObjectModel        = require '../models/ObjectModel'
AbstractCollection = require './AbstractCollection'

class ObjectsCollection extends AbstractCollection

    model : ObjectModel
    url : "/data/objects.json"

    B : =>
        return window.B

module.exports = ObjectsCollection
