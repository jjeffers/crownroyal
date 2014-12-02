require 'rubygems'
require 'sinatra/base'
require 'json'
require 'uri'
require 'net/http'
require 'dicebag'


class CrownRoyal < Sinatra::Application

  def roll(die_request)
    DiceBag::Roll.new(die_request).result()
  end

  def post_result(text)

    if ENV["RACK_ENV"] == "test"
      puts text
      return
    end

    webhook_url = ENV["SLACK_WEBHOOK_URL"]

    uri = URI(webhook_url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    request.body = { "text" => text }.to_json

    response = https.request(request)

    puts response.inspect

  end

  post '/' do

    puts request.POST.inspect

    username = request.POST["user_name"]
    text = request.POST["text"]

    puts "requester: #{username}"
    puts "text:      #{text}"

    die_request = text[5..-1].strip

    %r{^(?<number_of_dice>\d+)d(?<die_size>\d+)?\+?(?<plus>\d+)?$} =~ die_request

    if number_of_dice.nil? or die_size.nil?
      return 200
    end

    result = roll(die_request)
    total = result.total
    tally = result.sections[0].tally

    text = "#{username} rolled #{number_of_dice}d#{die_size}#{plus.nil? ? '' : "+" + plus} and got #{total} #{tally} #{plus.nil? ? '' : "(+" + plus + ")"}"

    post_result(text)

    return 200

  end

  run! if app_file == $0
end
