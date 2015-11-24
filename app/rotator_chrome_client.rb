class RotatorChromeClient < Android::Webkit::WebChromeClient
  def onJsAlert(view, url, message, result)
    puts message
    result.confirm
    true
  end
end
