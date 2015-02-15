DataSourceModel    = require '../models/DataSourceModel'
AbstractCollection = require './AbstractCollection'

class DataSourceCollection extends AbstractCollection

    model : DataSourceModel
    url : "/data/sources.json"

    B : =>
        return window.B

module.exports = DataSourceCollection
