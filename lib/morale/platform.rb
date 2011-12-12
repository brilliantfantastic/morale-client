module Morale
  module Platform
    def home_directory
      running_on_windows? ? ENV['USERPROFILE'] : ENV['HOME']
    end
    
    def running_on_windows?
      RUBY_PLATFORM =~ /mswin32|mingw32/
    end
  end
end