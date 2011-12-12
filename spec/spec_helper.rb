require "rubygems"
require "bundler/setup"

require "rspec"
require "webmock/rspec"

require "stringio"

require "morale/client"

RSpec.configure do |config|
  Morale::Client.base_url = "lvh.me:3000"
  
  def process(stdin_str = '')
    begin
      require 'stringio'
      $o_stdin, $o_stdout, $o_stderr = $stdin, $stdout, $stderr
      $stdin, $stdout, $stderr = StringIO.new(stdin_str), StringIO.new, StringIO.new
      yield
      {:stdout => $stdout.string, :stderr => $stderr.string}
    ensure
      $stdin, $stdout, $stderr = $o_stdin, $o_stdout, $o_stderr
    end
  end
end