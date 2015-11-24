# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/android'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Web Rotator'

  app.files_dependencies 'app/main_activity.rb' => 'app/planned_web_load.rb'
  app.files_dependencies 'app/main_activity.rb' => 'app/rotator_chrome_client.rb'
end
