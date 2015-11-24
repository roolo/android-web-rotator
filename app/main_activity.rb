class MainActivity < Android::App::Activity
  attr_reader :webview, :handler

  def onCreate(savedInstanceState)
    super
    @handler = Android::Os::Handler.new

    webview_setup
    timer_setup
  end

  private

  def timer_setup
    @timer = Java::Util::Timer.new
    @counter = 0

    task = PlannedWebLoad.new
    task.activity = self
    @timer.schedule task, 0, 10000
  end

  def webview_setup
    @webview = Android::Webkit::WebView.new(self)
    settings = @webview.settings
    settings.savePassword = true
    settings.saveFormData = false
    settings.javaScriptEnabled = true
    settings.supportZoom = false

    @webview.webChromeClient = Android::Webkit::WebChromeClient.new

    @webview.loadUrl("http://www.rooland.cz")

    self.contentView = @webview
  end
end
