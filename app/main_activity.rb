class MainActivity < Android::App::Activity
  attr_reader :webview, :handler
  attr_accessor :pages_position, :timer_running

  def onCreate(savedInstanceState)
    super

    layoutId = resources.getIdentifier('main', 'layout', packageName)
    self.contentView = layoutId

    @handler = Android::Os::Handler.new

    webview_setup

    # 60 seconds * 5 minutes
    @web_load_interval = 60_000 * 5

    # Start with first page
    @pages_position = 0

    # @todo Try to find way to get progress from timer
    @timer_progress_bar = timer_progress_setup @web_load_interval
    timer_setup @web_load_interval, @timer_progress_bar

    browser_button = findViewById(
      resources.getIdentifier('buttonOpenInBrowser', 'id', packageName)
    )
    browser_button.onClickListener = BrowserButtonListener.new self
  end

  # @param [Android::view::View] view
  def toggle_timer view
    if @timer_running
      @timer.cancel
      @timer_running = false
    else
      timer_setup @web_load_interval, @timer_progress_bar
      @timer_running = true
    end
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
    time_one_percent = interval/100

    timer_toggle_button = findViewById(
      resources.getIdentifier('buttonToggleTimer', 'id', packageName)
    )
    timer_toggle_button.onClickListener = TimerToggleButtonListener.new self

    task = PlannedWebLoad.new
    task.activity = self
    task.timer_progress_bar = timer_progress_bar
    task.fraction = time_one_percent
    @timer.schedule task, 0, time_one_percent
    @timer_running = true
  end

  def webview_setup
    viewId = resources.getIdentifier('mainWebView', 'id', packageName)
    @webview = findViewById(viewId)

    settings = @webview.settings
    settings.savePassword = true
    settings.saveFormData = false
    settings.javaScriptEnabled = true
    settings.supportZoom = false
    settings.setUserAgentString('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36')

    @webview.webChromeClient = Android::Webkit::WebChromeClient.new

    @webview.loadUrl("http://www.rooland.cz")
  end

  # @param [Android::view::View] view
  #
  # @return [Nil]
  def current_page_in_browser view
    browserIntent = Android::Content::Intent.new Android::Content::Intent::ACTION_VIEW,
                                                 Android::Net::Uri.parse('http://www.google.com')
    view.getContext.startActivity browserIntent
  end
end
