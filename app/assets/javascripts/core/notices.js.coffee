$(document).ready ->
  $('body').addClass('old-browser') unless plague.support.history()

  unless plague.support.transform3d()
    plague.ext.once 'hightlighted-no3d', ->
      no3dBanner = $('.no3d-notice .banner')
      after '1s', ->
        no3dBanner.addClass('hightlighted')
        after '600ms', ->
          no3dBanner.removeClass('hightlighted')
