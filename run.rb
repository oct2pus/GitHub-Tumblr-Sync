require 'tumblr_client'
require 'octokit'
require 'configatron'
require_relative 'config'

Tumblr.configure do |config|
	config.consumer_key = Configatron.tumblr_consumer_key
	config.consumer_secret = Configatron.tumblr_consumer_secret
	config.oauth_token = Configatron.tumblr_oauth_token
	config.oauth_token_secret = Configatron.tumblr_oauth_token_secret
end

Octokit.configure do |config|
	config.login = Configatron.github_login
	config.password = Configatron.github_token
end

tumblr_client = Tumblr::Client.new
github_client = Octokit::Client.new
