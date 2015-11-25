class TimerProgressUpdater < Java::Util::TimerTask
  attr_accessor :activity
  attr_accessor :fraction, :timer_progress_bar

  def run
    # This method will be called from another thread, and UI work must
    # happen in the main thread, so we dispatch it via a Handler object.
    @activity.handler.post -> do
      @timer_progress_bar.incrementProgressBy @fraction
      # @todo This should be without condition in PlannedWebLoad when next page is loaded
      @timer_progress_bar.setProgress 0 if @timer_progress_bar.getProgress == @timer_progress_bar.getMax
    end
  end
end
