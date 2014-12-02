require 'json'

require File.expand_path '../test_helper.rb', __FILE__

class SimpleSumTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods


  #def app
  #  app = CrownRoyal.allocate
  #  app.send :initialize
  #  app
  #end

  def app
    CrownRoyal
  end

  def test_it_returns_ok
    data = { :user_name => "phil", :text => "roll 1d6" }
    post '/', data
    assert last_response.ok?
  end

  def test_it_returns_ok_with_plus
    data = { :user_name => "phil", :text => "roll 1d6+2" }
    post '/', data
    assert last_response.ok?
  end

end