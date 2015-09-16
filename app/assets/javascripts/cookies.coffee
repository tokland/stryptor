if Rails.env != "test"
  $(document).ready ->
    $.cookieCuttr
      cookieAnalytics: false
      cookieMessage: "We use cookies in this site"
