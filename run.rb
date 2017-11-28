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
#while true
#	puts "#{tumblr_client.text("jadebot-discord", title: "hewwo", body: "wrote this in ruby working on a way to sync tumblr and github commits lmao")}"
#	sleep(20)
#	
#end

#github_client.commits("oct2pus/jadebot").each do |this|
#	puts this.commit.message
#end
#puts github_client.commits("oct2pus/jadebot").size

old = github_client.commits("oct2pus/dummyrepo")
last_change_found = false
counter = 0
while true
	new = github_client.commits("oct2pus/dummyrepo")
	puts "Pulling commits from #{github_client.repository("oct2pus/dummyrepo").full_name}."
	if old[0].sha != new[0].sha
			while !last_change_found || counter == 30
				if new[counter].sha == old[0].sha
					last_change_found = true
				else
					puts "new commit found, updating blog."
					tumblr_client.text("git-sync-testing", title: nil, body: "#{new[counter].commit.message}")
					sleep(configatron.time_between_posts)
				end	
				counter += 1
			end 
			last_change_found = false
			counter = 0
	end
	old = github_client.commits("oct2pus/dummyrepo")
	sleep(configatron.time_between_pulls)
end
