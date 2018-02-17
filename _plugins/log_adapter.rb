# Monkey patch the LogAdapter to change alignment of log messages

module Jekyll
  class LogAdapter
    # Internal: Format the topic
    #
    # topic - the topic of the message, e.g. "Configuration file", "Deprecation", etc.
    # colon -
    #
    # Returns the formatted topic statement
    def formatted_topic(topic, colon = false)
      "#{topic}#{colon ? ": " : " "}".rjust(26)
    end
  end
end
