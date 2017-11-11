module Radios
  class Config
    property pgsql : String

    def initialize
      @pgsql = ENV["pgsql"]
    end
  end
end
