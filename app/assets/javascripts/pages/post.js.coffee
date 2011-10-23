#= require jquery.cookie

plague.on '.post-page', ($, $$) ->
  unless $.cookie('hightlighted-year')
    $$('@hightlight-year').show().animate(opacity: 0, 2500, 'easeInQuad')
    $.cookie('hightlighted-year', 1, expires: 365)
