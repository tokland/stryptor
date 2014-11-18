stop_event = (callback) -> 
  (event, callback_args...) ->
    event.preventDefault()
    callback(event, callback_args...)

init_edition_box = ->
  selectors = [".edit", ".cancel"]
  complete_selector = ("#transcript.editable " + s for s in selectors).join(',')
  $(document).on "click", complete_selector, stop_event (ev) ->
    $(".toggle-edit").toggle()

init_flash = ->
  $(document).on "click", "#flash .close", stop_event (ev) ->
    $("#flash").slideUp()

main = ->
  init_edition_box()
  init_flash()

$(main)
