module Morale
  module Storage
    
    attr_accessor :location
    
    def delete
      FileUtils.rm_f(location)
    end
    
    def read
      File.exists?(location) and File.read(location)
    end
    
    def write(data)
      FileUtils.mkdir_p(File.dirname(location))
      f = File.open(location, 'w')
      f.puts data
      f.close
      set_permissions
    end
    
    private
    
    def set_permissions
      FileUtils.chmod 0700, File.dirname(location)
      FileUtils.chmod 0600, location
    end
  end
end