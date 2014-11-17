stop_event = (cb) -> 
  (ev) ->
    ev.preventDefault()
    cb(ev)

show_hide = (show_sel, hide_sel) ->
  $(show_sel).show()
  $(hide_sel).hide()

main = ->
  transcript_box = $("#transcript.editable")
  transcript_box.find(".edit").click stop_event (ev) ->
    show_hide("#transcript-form", "#transcript-text")

  transcript_box.find(".cancel").click stop_event (ev) ->
    show_hide("#transcript-text", "#transcript-form")
    
  transcript_box.find("#transcript-text").click stop_event (ev) ->
    show_hide("#transcript-form", "#transcript-text")
  
  $(document).on "click", "#flash .close", stop_event (ev) ->
    $("#flash").slideUp()
    
$(main)
