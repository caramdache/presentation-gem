class UIWindow
  alias_method 'originalSendEvent', 'sendEvent'

  def sendEvent(event)
    MZRPresentationView.sharedInstance.handleEvent(event)
    originalSendEvent(event)
  end
end
