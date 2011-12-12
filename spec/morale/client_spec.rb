require "spec_helper"
require "json"
require "morale/client"

describe Morale::Client do
  describe "#authorize" do
    it "authorizes a user with a valid email address and password" do
      api_key = "blah"
      stub_request(:post, "http://blah.lvh.me:3000/api/v1/in").to_return(:body => { "api_key" => "#{api_key}" }.to_json)
      Morale::Client.authorize(nil, nil, 'blah').api_key.should == api_key
    end
  end
  
  describe "#accounts" do
    it "displays all the accounts for a specific user based on their email" do
      stub_request(:get, "http://lvh.me:3000/api/v1/accounts?email=someone@example.com").to_return(:body => 
        [{"account" => {"group_name" => "Shimmy Sham","site_address"=>"shimmy_sham","created_at" => "2011-07-31T21:28:53Z","updated_at" => "2011-07-31T21:28:53Z","plan_id" => 1,"id" => 2}},
         {"account" => {"group_name" => "Pumpkin Tarts","site_address"=>"pumpkin_tarts","created_at" => "2011-07-31T21:40:24Z","updated_at" => "2011-07-31T21:40:24Z","plan_id" => 1,"id" => 1}}].to_json)
         
      accounts = Morale::Client.accounts('someone@example.com')
      accounts.count.should == 2
    end
    
    it "displays all the accounts for a specific user based on their api_key" do
      stub_request(:get, "http://blah:@blah.lvh.me:3000/api/v1/accounts?api_key=").to_return(:body => 
        [{"account" => {"group_name" => "Shimmy Sham","site_address"=>"shimmy_sham","created_at" => "2011-07-31T21:28:53Z","updated_at" => "2011-07-31T21:28:53Z","plan_id" => 1,"id" => 2}},
         {"account" => {"group_name" => "Pumpkin Tarts","site_address"=>"pumpkin_tarts","created_at" => "2011-07-31T21:40:24Z","updated_at" => "2011-07-31T21:40:24Z","plan_id" => 1,"id" => 1}}].to_json)
      
      client = Morale::Client.new('blah')   
      client.accounts.count.should == 2
      client.accounts[0]["account"]["group_name"].should == "Shimmy Sham"
    end
  end
  
  describe "#projects" do
    it "displays all the projects for a specific account" do
      stub_request(:get, "http://blah:@blah.lvh.me:3000/api/v1/projects").to_return(:body => 
        [{"project" => {"name" => "Skunk Works","created_at" => "2011-07-31T21:40:24Z","updated_at" => "2011-07-31T21:40:24Z","account_id" => 1,"id" => 1}},
         {"project" => {"name" => "Poop Shoot","created_at" => "2011-07-31T21:28:53Z","updated_at" => "2011-07-31T21:28:53Z","account_id" => 1,"id" => 2}}].to_json)
      client = Morale::Client.new('blah')
      client.projects.count.should == 2
      client.projects[0]["project"]["name"].should == "Skunk Works"
      client.projects[1]["project"]["id"].should == 2
    end
    
    it "should raise unauthorized if a 401 is received" do
      stub_request(:get, "http://blah:@blah.lvh.me:3000/api/v1/projects").to_return(:status => 401)
      client = Morale::Client.new('blah')
      lambda { client.projects.count }.should raise_error(Morale::Client::Unauthorized)
    end
  end
  
  describe "#ticket" do
    it "should return a JSON ticket that was created" do
      stub_request(:post, "http://blah:123456@blah.lvh.me:3000/api/v1/projects/1/tickets").
        with(:body => "command=This%20is%20a%20test%20that%20should%20create%20a%20new%20task%20as%3A%20Lester").
        to_return(:body => { 
          "created_at" => "2011-09-27T02:56:03Z",
          "assigned_to" => { "user" => { "first_name" => "Lester", "last_name" => "Tester", "email" => "test@test.com" } },
          "title" => "This is a test that should create a new task",
          "project_id" => "1",
          "priority" => "null",
          "archived" => "false",
          "id" => "1",
          "created_by" => { "user" => { "first_name" => "Lester", "last_name" => "Tester", "email" => "test@test.com" } },
          "due_date" => "null",
          "identifier" => "1" }.to_json
      )
      client = Morale::Client.new('blah', '123456')
      response = client.ticket(1, "This is a test that should create a new task as: Lester")
      response['title'].should == "This is a test that should create a new task"
      response['assigned_to']['user']['first_name'].should == "Lester"
      response['project_id'].should == "1"
    end
    
    it "should raise unauthorized if a 401 is received" do
      stub_request(:post, "http://blah:123456@blah.lvh.me:3000/api/v1/projects/1/tickets").
        with(:body => "command=This%20is%20a%20test%20that%20should%20create%20a%20new%20task%20as%3A%20Lester").
        to_return(:status => 401)
      client = Morale::Client.new('blah', '123456')
      lambda { client.ticket('1', "This is a test that should create a new task as: Lester") }.should raise_error(Morale::Client::Unauthorized)
    end
    
    it "should raise notfound if a 404 is received" do
      stub_request(:post, "http://blah:123456@blah.lvh.me:3000/api/v1/projects/1/tickets").
        with(:body => "command=This%20is%20a%20test%20that%20should%20create%20a%20new%20task%20as%3A%20Lester").
        to_return(:status => 404)
      client = Morale::Client.new('blah', '123456')
      lambda { client.ticket('1', "This is a test that should create a new task as: Lester") }.should raise_error(Morale::Client::NotFound)
    end
  end
  
  describe "#tickets" do
    it "should return all active tickets when no options are specified" do
      stub_request(:get, "http://blah:123456@blah.lvh.me:3000/api/v1/projects/1/tickets").to_return(:body => 
        [{"ticket" => {"title" => "This is test #1","created_at" => "2011-07-31T21:40:24Z","updated_at" => "2011-07-31T21:40:24Z","project_id" => 1,"id" => 1,"identifier" => "1","type" => "Task","due_date" => "2011-10-15 16:00:00.000000","priority" => nil,"archived" => "f"}},
         {"ticket" => {"title" => "This is test #2","created_at" => "2011-07-31T21:28:53Z","updated_at" => "2011-07-31T21:28:53Z","project_id" => 1,"id" => 2, "identifier" => "2","type" => "Bug","due_date" => nil,"priority" => "2","archived" => "f"}}].to_json)
      client = Morale::Client.new('blah', '123456')
      response = client.tickets({:project_id => 1})
      response.count.should == 2
      response[0]["ticket"]["title"].should == "This is test #1"
      response[1]["ticket"]["title"].should == "This is test #2"
    end
    
    it "should raise unauthorized if a 401 is received" do
      stub_request(:get, "http://blah:123456@blah.lvh.me:3000/api/v1/projects/1/tickets").
        to_return(:status => 401)
      client = Morale::Client.new('blah', '123456')
      lambda { client.tickets({:project_id => 1}) }.should raise_error(Morale::Client::Unauthorized)
    end
    
    it "should raise notfound if a 404 is received" do
      stub_request(:get, "http://blah:123456@blah.lvh.me:3000/api/v1/projects/1/tickets").
        to_return(:status => 404)
      client = Morale::Client.new('blah', '123456')
      lambda { client.tickets({ :project_id => 1 }) }.should raise_error(Morale::Client::NotFound)
    end
  end
end