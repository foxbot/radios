module Radios
  class Config
    property pgsql : String
    property secret : String
    property port : Int32

    def initialize
      @pgsql = ENV["pgsql"]
      @secret = ENV["jwtsecretkey"]
      @port = ENV["KEMAL_PORT"].to_i
    end
  end
end
