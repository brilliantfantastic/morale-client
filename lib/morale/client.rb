require 'httparty'
require 'json'
require 'morale/connection_store'

module Morale
  class Client
    class Unauthorized  < RuntimeError; end
    class NotFound < RuntimeError; end
    
    include HTTParty
    extend Morale::ConnectionStore
    
    format :json
    
    API_VERSION = 'v1'
    
    attr_accessor :api_key
    attr_reader   :subdomain
    
    def self.authorize(user, password, subdomain)
      client = new(subdomain)
      client.unauthorize
      client.api_key = client.class.post('/in', :body => { :email => user, :password => password })["api_key"]
      return client
    end
    
    def self.accounts(user)
      client = new
      client.unauthorize
      response = client.class.get("/accounts", :query => { :email => user })
      raise Unauthorized if response.code == 401
      raise NotFound if response.code == 404
      response
    end
    
    def accounts
      authorize
      response = self.class.get("/accounts", :query => { :api_key => @api_key })
      raise Unauthorized if response.code == 401
      raise NotFound if response.code == 404
      response
    end
    
    def initialize(subdomain="", api_key="")
      @api_key = api_key
      @subdomain = subdomain
      self.class.default_options[:base_uri] = HTTParty.normalize_base_uri("#{subdomain}#{"." unless subdomain.nil? || subdomain.empty?}#{self.class.base_url}/api/#{API_VERSION}")
    end
    
    def projects
      authorize
      response = self.class.get('/projects')
      raise Unauthorized if response.code == 401
      raise NotFound if response.code == 404
      response
    end
    
    def tickets(options={})
      authorize
      response = self.class.get("/projects/#{options[:project_id]}/tickets")
      raise Unauthorized if response.code == 401
      raise NotFound if response.code == 404
      response
    end
    
    def ticket(project_id, command)
      authorize
      response = self.class.post("/projects/#{project_id}/tickets", :body => { :command => command })
      raise Unauthorized if response.code == 401
      raise NotFound if response.code == 404
      response
    end
    
    def authorize
      self.class.basic_auth @subdomain, @api_key
    end
    
    def unauthorize
      self.class.basic_auth nil, nil
    end
  end
end