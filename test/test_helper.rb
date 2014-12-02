# test_helper.rb
ENV['RACK_ENV'] = 'test'
require 'rubygems'
require 'minitest/autorun'
require 'rack/test'

require 'minitest/unit'
require 'mocha/mini_test'

require File.expand_path '../crownroyal.rb', __FILE__