AbstractModel = require './AbstractModel'

class ObjectModel extends AbstractModel

    defaults :
        id               : null
        category         : null
        name_en          : null
        name_cat         : null
        icon_id          : null
        video            : null
        video_titles_en  : null
        video_titles_cat : null
        image            : null
        image_titles_en  : null
        image_titles_cat : null

module.exports = ObjectModel
