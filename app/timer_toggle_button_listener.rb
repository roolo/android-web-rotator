class TimerToggleButtonListener
  attr_accessor :activity

  def initialize activity
    @activity = activity
  end

  def onClick view
    @activity.toggle_timer view
  end
end
