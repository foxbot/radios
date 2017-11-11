require "kemal"

module Radios
  VERSION = "0.1.0"

  @@config = Config.new

  def self.run(config : Config)
    @@config = config
    Kemal.config.port = @@config.port
    Kemal.run
  end
end

require "./radios/*"
