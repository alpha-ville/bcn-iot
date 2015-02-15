CategoryModel        = require '../models/CategoryModel'
AbstractCollection = require './AbstractCollection'

class CategoriesCollection extends AbstractCollection

    model : CategoryModel
    url : "/data/categories.json"

    B : =>
        return window.B

module.exports = CategoriesCollection
