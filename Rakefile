require 'uglifier'
require 'html-proofer'

def nthp()
  puts "     _   _ ______ _  _ ____   "
  puts "    / | / /_  __/ / / / __ \\ "
  puts "   /  |/ / / / / /_/ / /_/ /  "
  puts "  / /|  / / / / __  / ____/   "
  puts " /_/ |_/ /_/ /_/ /_/_/        "
  puts ""
end

def jsminify(fn)
  puts "Minify #{fn}..."
  source = File.read(fn)
  options = {
    :output => {
      :comments => :none,
    },
  }
  uglified, source_map = Uglifier.new(options).compile_with_map(source)
  File.open(fn, 'w') do |f|
    f.write(uglified)
  end
  File.open("#{fn}.map", 'w') do |f|
    f.write(source_map)
  end
end

def logline(line)
  ds = (72 - line.length - 2) / 2
  d = "+" * ds
  puts "#{d} #{line} #{d}"
end

task :build do
  nthp()
  logline "NTHP BUILD"
  sh "bundle exec jekyll build --profile"

  logline "JS UGLIFY "
  jsminify("_site/js/app.js")
  jsminify("_site/js/lib.js")
  jsminify("_site/js/utility.js")

  logline "SEARCH INDEX"
  sh "coffee ./_coffee/search_index_generator.coffee"
end

task :debug do
  logline "NTHP DEBUG"
  sh "bundle exec jekyll build --trace --incremental --profile"

  logline "SEARCH INDEX"
  sh "coffee ./_coffee/search_index_generator.coffee"
end

task :test do
  logline "HTML TEST"
  HTMLProofer::check_directory("./_site", {
    :file_ignore => [/.*\/lib\/.*/],
    :parallel => { :in_processes => 4 },
    :cache => { :timeframe => '2w' },
    :disable_external => true,
    # :log_level => :debug,
  }).run
  logline "JSON LINT"
  sh "jsonlint -q ./_site/feeds/search.json"
end
