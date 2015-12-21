class BrowserButtonListener
  attr_accessor :activity

  def initialize activity
    @activity = activity
  end

  def onClick view
    @activity.current_page_in_browser view
  end
end
