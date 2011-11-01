$(document).ready ->
  $('body').addClass('old-browser') unless plague.support.history()

  unless plague.support.transform3d()
    unless $.cookie('hightlighted-no3d')
      no3dBanner = $('.no3d-notice .banner')
      after '1s', ->
        no3dBanner.addClass('hightlighted')
        after '600ms', ->
          no3dBanner.removeClass('hightlighted')
          $.cookie('hightlighted-no3d', 1, expires: 365)
