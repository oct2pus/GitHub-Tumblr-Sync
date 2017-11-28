require 'tumblr_client'
require 'octokit'
require 'configatron'
require_relative 'config'

tumblr_client = Tumblr::Client.new({
	:consumer_key => configatron.tumblr_consumer_key,
	:consumer_secret => configatron.tumblr_consumer_secret,
	:oauth_token => configatron.tumblr_oauth_token,
	:oauth_token_secret => configatron.tumblr_oauth_token_secret
})

github_client = Octokit::Client.new({
	:access_token => configatron.github_token
})

puts "#{tumblr_client.text("jadebot-discord", title: "hewwo", body: "wrote this in ruby working on a way to sync tumblr and github commits lmao")}"
