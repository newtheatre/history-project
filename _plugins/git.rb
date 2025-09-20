require 'git'

module Jekyll
  class GitActivityTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      result = ""
      begin
        g = Git.open(File.join(Dir.getwd, "."))

        index = 0
        g.log.each do |log|
          if(index < 30)
            result << "<li>"
            result << log.date.strftime("%d %b")
            result << " ­– <a href='https://github.com/newtheatre/history-project/commit/"
            result << log.sha
            result << "/' data-proofer-ignore>"
            result << log.message.lines[0]
            result << "</a> – "#
            result << log.author.name
            result << "</li>"
            index += 1
          end
        end
      rescue ArgumentError, Git::GitExecuteError
        # Handle case where we're not in a git repository (e.g., in Docker container)
        result = "<li>Git information unavailable in this environment</li>"
      end
      "<ul>#{result}</ul>"
    end
  end
  class GitLastCommit < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      result = ""
      begin
        g = Git.open(File.join(Dir.getwd, "."))

        index = 0
        g.log.each do |log|
          if(index < 1)
            result << log.date.strftime("%d %b")
            result << " - <a href='https://github.com/newtheatre/history-project/commit/"
            result << log.sha
            result << "/' data-proofer-ignore>"
            result << log.message
            result << "</a>"
            index += 1
          end
        end
      rescue ArgumentError, Git::GitExecuteError
        # Handle case where we're not in a git repository (e.g., in Docker container)
        result = "Git information unavailable in this environment"
      end
      "#{result}"
    end
  end
end

Liquid::Template.register_tag('gitactivity', Jekyll::GitActivityTag)
Liquid::Template.register_tag('gitlastcommit', Jekyll::GitLastCommit)

module NTHP
  class GitData
    def initialize
      begin
        g = Git.open(File.join(Dir.getwd, "."))
        @sha = g.object('HEAD').sha
        @sha_short = @sha[0,7]
      rescue ArgumentError, Git::GitExecuteError
        # Handle case where we're not in a git repository (e.g., in Docker container)
        @sha = "unknown"
        @sha_short = "unknown"
      end
    end

    def to_liquid
      {
        'sha' => @sha,
        'sha_short' => @sha_short,
      }
    end
  end
end
