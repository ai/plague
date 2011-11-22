#= require jquery.elastic

$(document).ready ->
  textareas = $('textarea')
  textareas.elastic()
  textareas.each -> $(@).val($(@).val() + "\n").focus().blur()
