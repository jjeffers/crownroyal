require 'rubygems'
require 'sinatra'
require 'json'
require 'uri'
require 'net/http'
require 'dicebag'


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

  result = DiceBag::Roll.new(die_request).result()
  total = result.total
  tally = result.sections[0].tally

  webhook_url = "https://hooks.slack.com/services/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"

  uri = URI(webhook_url)
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  request = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
  request.body = { "text" => "#{username} rolled #{number_of_dice}d#{die_size} and got #{total} #{tally}" }.to_json

  response = https.request(request)

  puts response.inspect

  return 200

end
