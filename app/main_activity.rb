class MainActivity < Android::App::Activity
  attr_reader :webview, :handler

  def onCreate(savedInstanceState)
    super

    layoutId = resources.getIdentifier('main', 'layout', packageName)
    self.contentView = layoutId

    @handler = Android::Os::Handler.new

    webview_setup

    # 60 seconds * 5 minutes
    web_load_interval = 60_000 * 5

    # @todo Try to find way to get progress from timer
    timer_progress_bar = timer_progress_setup web_load_interval
    timer_setup web_load_interval, timer_progress_bar
  end

  private

  # @param [Integer] interval Milliseconds between web page loads
  def timer_progress_setup interval
    viewId = resources.getIdentifier('timerProgress', 'id', packageName)
    timer_progress_bar = findViewById(viewId)

    timer_progress_bar.setMax(interval)
    timer_progress_bar
  end


  # @param [Integer] interval Milliseconds between web page loads
  # @param [ProgressBar] timer_progress_bar
  def timer_setup interval, timer_progress_bar
    @timer = Java::Util::Timer.new
    time_one_percent = interval/1000

    task = PlannedWebLoad.new
    task.activity = self
    task.timer_progress_bar = timer_progress_bar
    task.fraction = time_one_percent
    @timer.schedule task, 0, time_one_percent
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
