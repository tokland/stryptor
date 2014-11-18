debug = (args...) -> 
  console.debug(args...)

stop_event = (callback) -> 
  (event, callback_args...) ->
    event.preventDefault()
    callback(event, callback_args...)

init_toggle = ->
  $(document).on "click", "[data-toggle]", stop_event (ev) ->
    selector = $(ev.target).attr("data-toggle")
    $(selector).toggle()
    
init_close = ->
  $(document).on "click", "[data-close]", stop_event (ev) ->
    selector = $(ev.target).attr("data-close")
    $(selector).slideUp()

submit_forms_on_control_enter = ->
  $(document).on "keydown", "form textarea", (ev) ->
    if (ev.keyCode == 10 || ev.keyCode == 13) && ev.ctrlKey
      ev.preventDefault()
      $(ev.target).parents("form").submit()
      
main = ->
  init_toggle()
  init_close()
  submit_forms_on_control_enter()
  $(document).tooltip()

$(main)
