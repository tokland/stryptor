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
    $(selector).closest("form").
      find("input[name]:visible,textarea[name]:visible").first().focus()
    
init_close = ->
  $(document).on "click", "[data-close]", stop_event (ev) ->
    selector = $(ev.target).attr("data-close")
    $(selector).slideUp()

init_submit_forms_on_control_enter = ->
  $(document).on "keydown", "form textarea", (ev) ->
    if (ev.keyCode in [10, 13]) && ev.ctrlKey
      ev.preventDefault()
      $(ev.target).parents("form").submit()

init_autocomplete = (suggestions) ->
  $("#transcript_text").tabcomplete(suggestions, {
	  after: ""
	  arrowKeys: false
	  hint: "placeholder"
	  caseSensitive: true
	  minLength: 1
	  wrapInput: true
  })

set_user_rating = (box) ->
  rating_string = box.attr("data-current-rating")
  if rating_string
    box.find(".rating").each ->
      link = $(this)
      rating = parseInt(rating_string)
      if link.attr("data-rating") <= rating
        link.addClass("voted")
      else
        link.removeClass("voted")

init_ratings = ->
  $(".rating.can-vote").click stop_event (ev) ->
    el = $(ev.target)
    box = el.closest(".rating-box")
    box.find(".spinner").show()
    $.ajax 
      type: "POST"
      url: el.attr("href")
      complete: (res) ->
        box.find(".spinner").hide()
        set_user_rating(box)
      success: (res) ->
        if res.status
          info = res.info
          box = el.closest(".rating-box")
          box.find(".rating-total").text(info.average)
          box.find(".rating-count").text(info.count)
          box.find(".visible-on-ratings").show()
          box.attr("data-current-rating", res.value)
    
  $(".rating").hover (ev) ->
    el = $(this)
    box = el.closest(".rating-box")
    rating = parseInt(el.attr("data-rating"))
    box.find(".rating").removeClass("voted")
    box.find(".rating").each ->
      link = $(this)
      if link.attr("data-rating") <= rating
        link.addClass("selected")
      else
        link.removeClass("selected")

  $(".ratings").mouseleave (ev) ->
    box = $(ev.target).closest(".rating-box")
    box.find(".rating").removeClass("selected")
    set_user_rating(box)
  
set_token = (value) ->
  $("#new_transcript").submit ->
    $("#transcript-token").val(value)

window.init_strip = (options) ->
  $ ->
    init_autocomplete(options.suggestions)
    set_token(options.token)

main = ->
  $ ->
    init_toggle()
    init_close()
    init_submit_forms_on_control_enter()
    init_ratings()
  
main()
