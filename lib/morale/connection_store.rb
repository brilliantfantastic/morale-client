require 'morale/storage'
require 'morale/platform'

module Morale
  module ConnectionStore
    include Morale::Storage
    include Morale::Platform
    
    def base_url
      if @base_url.nil?
        @base_url = read_connection
        if @base_url.nil?
          @base_url = default_base_url
          self.write_connection
        end
      end
      @base_url
    end
    
    def base_url=(value)
      @base_url = value
      self.write_connection
    end
    
    def location
      ENV['CONNECTION_LOCATION'] || default_location
    end
    
    def location=(value)
      ENV['CONNECTION_LOCATION'] = value
    end
    
    def default_location
      "#{home_directory}/.morale/connection"
    end
    
    def delete_connection
      self.delete
      @base_url = nil
    end
    
    def read_connection
      connection = self.read
      connection.split("\n") if connection
    end
    
    def write_connection
      self.write self.base_url
    end
    
    private
    
    def default_base_url
      ENV['DEFAULT_BASE_URL'] || "teammorale.com"
    end
    
  end
end