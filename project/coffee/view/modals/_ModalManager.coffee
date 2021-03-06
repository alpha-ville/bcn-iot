AbstractView         = require '../AbstractView'
OverlayContent       = require './OverlayContent'
OverlayDataContent   = require './OverlayDataContent'
OverlayHelp          = require './OverlayHelp'
OverlaySoon          = require('./OverlaySoon');

class ModalManager extends AbstractView

    # when new modal classes are created, add here, with reference to class name
    modals :
        overlayContent : classRef : OverlayContent, view : null
        overlayDataContent : classRef : OverlayDataContent, view : null
        overlayHelp : classRef : OverlayHelp, view : null
        overlaySoon : classRef : OverlaySoon, view : null

    isOpen : =>

        ( if @modals[name].view then return true ) for name, modal of @modals

        false

    hideOpenModal : =>

        ( if @modals[name].view then openModal = @modals[name].view ) for name, modal of @modals

        openModal?.hide()

        null

    showModal : (name, cb=null) =>
        @hideOpenModal()

        return if @modals[name].view
        @modals[name].view = new @modals[name].classRef cb
        null

module.exports = ModalManager
