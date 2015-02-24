PurposeModel    = require '../models/PurposeModel'
AbstractCollection = require './AbstractCollection'

class PurposeCollection extends AbstractCollection

    model : PurposeModel
    url : "/data/purposes.json"

    B : =>
        return window.B

module.exports = PurposeCollection
