class UIWindow
  def swizzlingMessage
    "Method Swizzlings: sendEvent: and description"
  end

  def swizzle
    range = self.description.rangeOfString(self.swizzlingMessage, options:NSStringCompareOptions.LiteralSearch, range:nil, locale:nil)
    if range and range.startIndex != nil then
      return
    end
    
    sendEvent = class_getInstanceMethod(object_getClass(self), "sendEvent:")
    swizzledSendEvent = class_getInstanceMethod(object_getClass(self), "swizzledSendEvent:")
    method_exchangeImplementations(sendEvent, swizzledSendEvent)

    description = class_getInstanceMethod(object_getClass(self), "description")
    swizzledDescription = class_getInstanceMethod(object_getClass(self), "swizzledDescription")
    method_exchangeImplementations(description, swizzledDescription)
  end

  def swizzledSendEvent(event)
    MZRPresentationView.sharedInstance.handleEvent(event)
    self.swizzledSendEvent(event)
  end

  def swizzledDescription
    self.swizzledDescription + "; " + self.swizzlingMessage
  end
end
