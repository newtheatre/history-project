# Monkey patch the LogAdapter to change alignment of log messages

module Jekyll
  class LogAdapter
    def formatted_topic(topic)
      "#{topic} ".rjust(26)
    end
  end
end
