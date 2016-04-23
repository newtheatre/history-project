require 'octokit'

TRAVIS_BUILD_NUMBER = ENV["TRAVIS_BUILD_NUMBER"]
TRAVIS_COMMIT = ENV["TRAVIS_COMMIT"]
TRAVIS_PULL_REQUEST = ENV["TRAVIS_PULL_REQUEST"]
TRAVIS_BRANCH = ENV["TRAVIS_BRANCH"]
GH_TOKEN = ENV["GH_TOKEN"]
GH_REPO = "newtheatre/history-project"

def update_393(g)
  # Fetch and decode people-headshots-list.txt
  new_body = File.read("_site/util/people-headshots-list.txt")

  # Fetch and update issue
  issue393 = g.update_issue(GH_REPO, "393", :body => new_body)
end

def run()
  g = Octokit::Client.new(:access_token => GH_TOKEN)
  u = g.user
  u.login

  repo = Octokit.repo GH_REPO

  update_393(g)
end

if true #TRAVIS_PULL_REQUEST == "false" and TRAVIS_BRANCH == "master"
  puts "Running GitHub tasks..."
  run
else
  print "Skipping GH tasks"
end
