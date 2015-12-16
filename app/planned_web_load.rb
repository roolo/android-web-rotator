class PlannedWebLoad < Java::Util::TimerTask
  attr_accessor :activity

  attr_accessor :timer_progress_bar, :fraction
  PAGES = [
    'http://www.rooland.cz/tag/dev.html',
    'http://www.rooland.cz/tag/komunikace.html',
    'http://www.rooland.cz/tag/zacatecnik.html'
  ]

  def run
    # This method will be called from another thread, and UI work must
    # happen in the main thread, so we dispatch it via a Handler object.
    @activity.handler.post -> do
      @timer_progress_bar.incrementProgressBy @fraction

      if @timer_progress_bar.getProgress == @timer_progress_bar.getMax
        @timer_progress_bar.setProgress 0
        @activity.webview.loadUrl next_page
      end
    end
  end

  private

  def next_page
    next_page_address = PAGES[@activity.pages_position]

    if PAGES[@activity.pages_position+1]
      @activity.pages_position += 1
    else
      @activity.pages_position = 0
    end

    next_page_address
  end
end
