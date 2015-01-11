debug = (args...) -> 
  console.debug(args...)

repaintCursor = ->
  if document.documentElement.style.hasOwnProperty('WebkitAppearance')
    saveCursor = document.body.style.cursor
    newCursor = if saveCursor then "" else "wait"
    setCursor(newCursor)
    setCursor(saveCursor)

setCursor = (cursor) ->
  wkch = document.createElement("div")
  wkch2 = document.createElement("div")
  wkch.style.overflow = "hidden"
  wkch.style.position = "absolute"
  wkch.style.left = "0px"
  wkch.style.top = "0px"
  wkch.style.width = "100%"
  wkch.style.height = "100%"
  wkch2.style.width = "200%"
  wkch2.style.height = "200%"
  wkch.appendChild(wkch2)
  document.body.appendChild(wkch)
  document.body.style.cursor = cursor
  wkch.scrollLeft = 1
  wkch.scrollLeft = 0
  document.body.removeChild(wkch)
  
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

submit_forms_on_control_enter = ->
  $(document).on "keydown", "form textarea", (ev) ->
    if (ev.keyCode in [10, 13]) && ev.ctrlKey
      ev.preventDefault()
      $(ev.target).parents("form").submit()

turbolink_load_cursor = ->
  $(document).on "page:fetch", -> 
    $(document.body).addClass("loading")
  $(document).on "page:load", -> 
    $(document.body).removeClass("loading")
    repaintCursor()

autocomplete = (suggestions) ->
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
  
set_token = ->
  $("#new_transcript").submit ->
    $("#transcript-token").val("1234")

window.init_strip = (options) ->
  $ ->
    autocomplete(options.suggestions)
    set_token()

main = ->
  $ ->
    init_toggle()
    init_close()
    submit_forms_on_control_enter()
    init_ratings()
  
main()
