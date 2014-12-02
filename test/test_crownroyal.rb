require 'json'

require File.expand_path '../../test_helper.rb', __FILE__

class SimpleSumTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods


  def app
    app = CrownRoyal.allocate
    app.send :initialize
    app
  end

  def test_it_says_hello_world
    app.stub :post_result, true do
      data = { :user_name => "phil", :text => "roll 1d6" }
      post '/', data.to_json, { "CONTENT_TYPE" => "application/json" }
      assert last_response.ok?
    end
  end

end