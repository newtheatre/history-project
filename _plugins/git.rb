require 'git'

module Jekyll
  class GitActivityTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      result = ""
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
      "<ul>#{result}</ul>"
    end
  end
  class GitLastCommit < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      result = ""
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
      "#{result}"
    end
  end
end

Liquid::Template.register_tag('gitactivity', Jekyll::GitActivityTag)
Liquid::Template.register_tag('gitlastcommit', Jekyll::GitLastCommit)
