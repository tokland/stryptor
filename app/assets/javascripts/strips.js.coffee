stop_event = (cb) -> 
  (ev) ->
    ev.preventDefault()
    cb(ev)

main = ->
  selectors = ("#transcript.editable " + s for s in [".text", ".edit", ".cancel"])
  $(document).on "click", selectors.join(','), stop_event (ev) ->
    $(".toggle-edit").toggle()
  
  $(document).on "click", "#flash .close", stop_event (ev) ->
    $("#flash").slideUp()

main()
