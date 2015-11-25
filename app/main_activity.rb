class MainActivity < Android::App::Activity
  attr_reader :webview, :handler

  def onCreate(savedInstanceState)
    super

    layoutId = resources.getIdentifier('main', 'layout', packageName)
    self.contentView = layoutId

    @handler = Android::Os::Handler.new

    webview_setup

    # 10 seconds
    web_load_interval = 10000

    # @todo Try to find way to get progress from timer instead of having parallel timer for fractions
    timer_progress_setup web_load_interval
    timer_setup web_load_interval
  end

  private

  # @param [Integer] interval Milliseconds between web page loads
  def timer_progress_setup interval
    viewId = resources.getIdentifier('timerProgress', 'id', packageName)
    @timer_progress_bar = findViewById(viewId)

    fraction = interval/100
    @timer_progress_bar.setMax(interval)
    timer = Java::Util::Timer.new

    task = TimerProgressUpdater.new
    task.activity = self
    task.fraction = fraction
    task.timer_progress_bar = @timer_progress_bar
    timer.schedule task, 0, fraction

    @timer_progress_bar
  end


  # @param [Integer] interval Milliseconds between web page loads
  def timer_setup interval
    @timer = Java::Util::Timer.new

    task = PlannedWebLoad.new
    task.activity = self
    @timer.schedule task, 0, interval
  end

  def webview_setup
    viewId = resources.getIdentifier('mainWebView', 'id', packageName)
    @webview = findViewById(viewId)

    settings = @webview.settings
    settings.savePassword = true
    settings.saveFormData = false
    settings.javaScriptEnabled = true
    settings.supportZoom = false

    @webview.webChromeClient = Android::Webkit::WebChromeClient.new

    @webview.loadUrl("http://www.rooland.cz")
  end
end
