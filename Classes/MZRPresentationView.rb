class MZRPresentationView < UIView
  attr_accessor :image, :color

  def touchViews
    @touchViews ||= []
  end

  def self.sharedInstance
    @sharedInstance ||= MZRPresentationView.alloc.init
  end

  def initWithFrame(frame)
    super.tap do
      self.clipsToBounds = false

      UIDevice.currentDevice.beginGeneratingDeviceOrientationNotifications()
      NSNotificationCenter.defaultCenter.addObserver(self, selector: "orientationDidChangeNotification:", name: UIDeviceOrientationDidChangeNotification, object: nil)
      NSNotificationCenter.defaultCenter.addObserver(self, selector: "applicationDidBecomeActiveNotification:", name: UIApplicationDidBecomeActiveNotification, object: nil)
    end
  end

  def finalize
    NSNotificationCenter.defaultCenter.removeObserver(self)
  end

  def initWithCoder(decoder)
    fatalError("initWithCoder: has not been implemented")
  end

  def applicationDidBecomeActiveNotification(notification)
    #UIApplication.sharedApplication.keyWindow.swizzle
  end

  def orientationDidChangeNotification(notification)
    self.subviews.each { |subview|
      subview.removeFromSuperview
    }
  end

  def self.start
    self.start(nil, image:nil)
  end

  def self.start(color, image:image)
    instance = self.sharedInstance
    instance.color = color
    instance.image = image
    if window = UIApplication.sharedApplication.keyWindow then
      window.subviews.each { |subview|
        if subview != nil then
          subview.removeFromSuperview
        end
      }
    end
  end

  def self.stop
    instance = self.sharedInstance
    instance.removeFromSuperview
  end

  def dequeueTouchView
    touchView = nil
    self.touchViews.each { |view|
      if view.superview == nil then
        touchView = view
        break
      end
    }

    if touchView == nil then
      touchView = MZRTouchView.alloc.initWithImage(self.image, color:self.color)
      self.touchViews << touchView
    end

    touchView.alpha = 1.0
    touchView
  end

  def findTouchView(touch)
    self.touchViews.each { |view|
      if view.touch == touch then
        return view
      end
    }
    nil
  end

  def handleEvent(event)
    if event.type != UIEventTypeTouches then
      return
    end

    keyWindow = UIApplication.sharedApplication.keyWindow

    event.allTouches.allObjects.each { |touch|

      phase = touch.phase
      case phase
      when UITouchPhaseBegan then
        view = self.dequeueTouchView
        view.touch = touch
        view.center = touch.locationInView(keyWindow)
        keyWindow.addSubview(view)
      when UITouchPhaseMoved then
        if view = findTouchView(touch) then
          view.center = touch.locationInView(keyWindow)
        end
      when UITouchPhaseStationary then
        break
      when UITouchPhaseEnded, UITouchPhaseCancelled then
        if view = findTouchView(touch) then
          UIView.animateWithDuration(0.2, delay:0.0, options:UIViewAnimationOptionAllowUserInteraction, animations:lambda {
            view.alpha = 0.0
          }, completion:lambda { |finished|
            view.removeFromSuperview
          })
        end
      end
    }
  end
end
