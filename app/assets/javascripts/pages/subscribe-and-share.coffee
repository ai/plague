$ = jQuery

$(window).load ->
  return unless $('.subscribe-and-share').length

  $.getScript('http://platform.twitter.com/widgets.js')
  $.getScript 'http://userapi.com/js/api/openapi.js?45', ->
    VK.init(apiId: 2707136, onlyWidgets: true)
    for place in ['top', 'bottom']
      VK.Widgets.Like("vk_#{place}_like", type: 'button', height: 22,
                      pageUrl: "http://#{location.host}/")
      VK.Widgets.Group("vk_#{place}_group",
                       { mode: 1, width: "200", height: "290" },
                       32860226)
