require 'html-proofer'

task :htmlproof do
  HTMLProofer::check_directory("./_site/", {
    # :log_level => :debug,
    :cache => { :timeframe => '2w' },
    :check_html => true,
    :file_ignore => [/.*\/lib\/.*/],
    :parallel => { :in_processes => 3 },
    :typhoeus => { :timeout => 15 },
    :hydra => { :max_concurrency => 50 },
    :url_ignore => [/history.newtheatre.org.uk/, /photos.newtheatre.org.uk/,
      /photos.smugmug.com/],
  }).run
end

task :html_test do
  HTMLProofer::check_directory("./_site/", {
    # :log_level => :debug,
    :check_html => true,
    :checks_to_ignore => ["LinkCheck", "ImageCheck", "ScriptCheck"],
    :file_ignore => [/.*\/lib\/.*/],
    :parallel => { :in_processes => 4 },
    :url_ignore => [/history.newtheatre.org.uk/, /photos.newtheatre.org.uk/,
      /photos.smugmug.com/],
  }).run
end
