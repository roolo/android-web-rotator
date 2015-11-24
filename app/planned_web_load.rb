class PlannedWebLoad < Java::Util::TimerTask
  attr_accessor :activity

  attr_accessor :pages_position
  PAGES = [
    'http://www.rooland.cz/tag/dev.html',
    'http://www.rooland.cz/tag/komunikace.html',
    'http://www.rooland.cz/tag/zacatecnik.html'
  ]

  def initialize
    super

    @pages_position = 0
  end

  def run
    # This method will be called from another thread, and UI work must
    # happen in the main thread, so we dispatch it via a Handler object.
    @activity.handler.post -> do
      @activity.webview.loadUrl next_page
    end
  end

  private

  def next_page
    next_page_address = PAGES[@pages_position]

    if PAGES[@pages_position+1]
      @pages_position += 1
    else
      @pages_position = 0
    end

    next_page_address
  end
end
