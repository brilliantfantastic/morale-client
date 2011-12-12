require 'spec_helper'
require 'morale/connection_store'

describe Morale::ConnectionStore do
  
  class Dummy; end
  before (:each) do
    @dummy = Dummy.new
    @dummy.extend(Morale::ConnectionStore)
  end
  
  after (:each) do
    @dummy.delete_connection
  end
  
  describe "#location" do
    it "should return the correct location of the connection file" do
      @dummy.location.should == "#{ENV['HOME']}/.morale/connection"
    end
  end
  
  describe "#base_url" do
    it "should store the default base url if it is not set" do
      @dummy.base_url.should == "teammorale.com"
      File.read(@dummy.location).should =~ /teammorale.com/
    end
    
    it "should return the environment variable for the default base url" do
      @dummy.delete_connection
      ENV['DEFAULT_BASE_URL'] = "somewhere-else.com"
      @dummy.base_url.should == "somewhere-else.com"
    end
    
    it "should store the base url when it is set" do
      @dummy.base_url = "somewhere-else.com"
      File.read(@dummy.location).should =~ /somewhere-else.com/
    end
  end
  
  describe "#delete_connection" do
    it "should clear the base_url field" do
      ENV['DEFAULT_BASE_URL'] = nil
      @dummy.base_url = "Blah!"
      @dummy.delete_connection
      @dummy.base_url.should == "teammorale.com"
    end
    
    it "should delete the connection file" do
      FileUtils.mkdir_p(File.dirname(@dummy.location))
      f = File.open(@dummy.location, 'w')
      f.puts "Blah!"
      
      @dummy.delete_connection
      File.exists?(@dummy.location).should be_false
    end
  end
  
  describe "#write_connection" do
    it "should write data to the location of the connection file" do
      @dummy.base_url = "Blah!"
      @dummy.write_connection
      File.read(@dummy.location).should =~ /Blah!/
    end
  end
end