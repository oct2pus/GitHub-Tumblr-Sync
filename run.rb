require 'tumblr_client'
require 'octokit'
require 'configatron'
require_relative 'config'

##Client API Logins
tumblr_client = Tumblr::Client.new({
	:consumer_key => configatron.tumblr_consumer_key,
	:consumer_secret => configatron.tumblr_consumer_secret,
	:oauth_token => configatron.tumblr_oauth_token,
	:oauth_token_secret => configatron.tumblr_oauth_token_secret
})

github_client = Octokit::Client.new({
	:access_token => configatron.github_token,
	:per_page => configatron.size_of_commit_log
})


#Other variables
old = github_client.commits(configatron.github_repo)
last_change_found = false
counter = 0


#Process Loop, end program with ^C
while true
	new = github_client.commits(configatron.github_repo)
	puts "Pulling commits from #{github_client.repository(configatron.github_repo).full_name}."
	if old[0].sha != new[0].sha
			while !last_change_found || counter == configatron.size_of_commit_log
				if new[counter].sha == old[0].sha
					last_change_found = true
				else
					puts "new commit found, updating blog."
					tumblr_client.text(configatron.tumblr_blog, title: "New commit to #{github_client.repository(configatron.github_repo).full_name}.", body: "Committer: #{new[counter].commit.committer.name}\nMessage: \"#{new[counter].commit.message}\"\nTime: #{new[counter].commit.committer.date}")
					sleep(configatron.time_between_posts)
				end	
				counter += 1
			end 
			last_change_found = false
			counter = 0
	end
	old = new
	sleep(configatron.time_between_pulls)
end
