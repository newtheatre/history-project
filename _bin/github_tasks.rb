require 'octokit'

TRAVIS_BUILD_NUMBER = ENV["TRAVIS_BUILD_NUMBER"]
TRAVIS_COMMIT = ENV["TRAVIS_COMMIT"]
TRAVIS_PULL_REQUEST = ENV["TRAVIS_PULL_REQUEST"]
TRAVIS_BRANCH = ENV["TRAVIS_BRANCH"]
GH_TOKEN = ENV["GH_TOKEN"]
GH_CLIENT_ID = ENV["GH_CLIENT_ID"]
GH_CLIENT_SECRET = ENV["GH_CLIENT_SECRET"]
GH_REPO = "newtheatre/history-project"

def update_393(g)
  # Fetch and decode people-headshots-list.txt
  new_body = File.read("_site/util/people-headshots-list.txt")
  # Fetch and update issue
  g.update_issue(GH_REPO, "393", :body => new_body)
end

def run()
  g = Octokit::Client.new(
    :client_id => GH_CLIENT_ID,
    :client_secret => GH_CLIENT_SECRET,
    :access_token => GH_TOKEN,
  )
  g.user.login
  # repo = Octokit.repo GH_REPO
  update_393(g)
end

if TRAVIS_PULL_REQUEST == "false" and TRAVIS_BRANCH == "master"
  puts "Running GitHub tasks..."
  run
else
  puts "Skipping GH tasks"
end
