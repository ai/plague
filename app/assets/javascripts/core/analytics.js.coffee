#= require jquery.google-analytics

$(document).ready ->
  return if $('body').hasClass('development')
  $.trackPage('UA-26846970-1')
