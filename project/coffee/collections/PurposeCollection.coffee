PurposeModel    = require '../models/DataSourceModel'
AbstractCollection = require './AbstractCollection'

class PurposeCollection extends AbstractCollection

    model : PurposeModel
    url : "/data/purposes.json"

    B : =>
        return window.B

module.exports = PurposeCollection
