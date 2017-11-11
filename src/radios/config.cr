module Radios
  class Config
    property pgsql : String
    property secret : String

    def initialize
      @pgsql = ENV["pgsql"]
      @secret = ENV["jwtsecretkey"]
    end
  end
end
