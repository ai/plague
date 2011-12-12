$(document).ready ->
  $('@subscribe-link').attr(target: '_blank')

$(window).load ->
  $.getScript('http://platform.twitter.com/widgets.js')
  $.getScript 'http://userapi.com/js/api/openapi.js?45', ->
    VK.init(apiId: 2707136, onlyWidgets: true)
    VK.Widgets.Like('vk_top_like', type: 'button', height: 20,
                    pageUrl: "http://#{location.host}/")
