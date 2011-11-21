plague.support =

  history: ->
    !!(window.history and history.pushState)

  localStore: ->
    try
      !!localStorage.getItem
    catch error
      false

  _transform3d: ->
    return false unless window.matchMedia?
    result = matchMedia("all and (transform-3d)")
    return true if result.matches
    matchMedia("all and (#{plague.ext.cssPrefix()}transform-3d)").matches

  transform3d: ->
    @transform3dCache ||= @_transform3d()

  css3animation: ->
    s = document.createElement('div').style
    s.animationName != undefined or
      s["#{plague.ext.domPrefix()}AnimationName"] != undefined
