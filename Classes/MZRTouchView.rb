class MZRTouchView < UIImageView
  weak_attr_accessor :touch
  
  def defaultTintColor
    @color ||= UIColor.colorWithRed(52/255.0, green:152/255.0, blue:219/255.0, alpha:0.8)
  end

  def defaultImage
    @image ||= begin
      rect = CGRectMake(0, 0, 60.0, 60.0)
      UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
      contextRef = UIGraphicsGetCurrentContext()
      CGContextSetFillColorWithColor(contextRef, UIColor.blackColor.CGColor)
      CGContextFillEllipseInRect(contextRef, rect)
      image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
      image
    end
  end
  
  def initWithImage(image, color:color)
    self.initWithFrame(CGRectMake(0.0, 0.0, 60.0, 60.0))
    
    self.image = image || self.defaultImage
    self.image = self.image.imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
    self.tintColor = color || self.defaultTintColor
  end

  def initWithCoder(decoder)
    fatalError("initWithCoder: has not been implemented")
  end
end
