require "kemal"

module Radios
  VERSION = "0.1.0"

  def self.run(@@config : Config)
    Kemal.run
  end
end

require "./radios/*"
