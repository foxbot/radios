require "./constants"
require "./model"
require "./query"
require "db"
require "pg"
require "jwt"

module Radios
  def self.authorized?(env, min)
    token = env.request.headers.fetch("Authorization", "")
    return {false, {"error": "unspecified Authorization header"}.to_json} unless token

    payload, _ = JWT.decode(token, @@config.secret, "HS256")
    level = payload["level"]?
    return {false, {"error": "invalid token"}.to_json} unless level.is_a?(Number)

    return {level >= min, {"error": "not permitted"}.to_json}
  end

  before_all do |env|
    env.response.content_type = "application/json"
  end

  # List
  get "/radios" do |env|
    start, limit, state = 0,0,0
    Query.paginate
    Query.state

    db = PG.connect @@config.pgsql
    begin
      radios = Radio.all(db, state, start, limit)
    ensure
      db.close
    end

    radios.to_json
  end

  # Create
  before_post "/radios" do |env|
    auth, err = Radios.authorized?(env, AuthLevel::SUPPORT)
    halt env, 401, err unless auth
  end
  post "/radios" do |env|
    body = env.request.body
    halt env, 400, {"error": "missing body"}.to_json unless body
    data = Radio.create_from body

    db = PG.connect @@config.pgsql
    begin
      radio = Radio.insert(db, data)[0]
    ensure
      db.close
    end

    radio.to_json
  end

  # Search by Name
  get "/radios/search/:name" do |env|
    name = env.params.url["name"]
    start, limit = 0,0
    Query.paginate
    query = "#{name}%"

    db = PG.connect @@config.pgsql
    begin
      radios = Radio.search(db, query, start, limit)
    ensure
      db.close
    end
    radios.to_json
  end

  # Get by ID
  get "/radios/:radio" do |env|
    id = 0
    Query.id

    db = PG.connect @@config.pgsql
    begin
      radio = Radio.one(db, id)
      if radio.size < 1
        halt env, 404, {"error": "resource not found"}.to_json
      end
      radio = radio[0]
    ensure
      db.close
    end
    radio.to_json
  end

  # Modify by ID
  before_put "/radios/:radio" do |env|
    auth, err = Radios.authorized?(env, AuthLevel::SUPPORT)
    halt env, 401, err unless auth
  end
  put "/radios/:radio" do |env|
    id = 0
    Query.id

    body = env.request.body
    halt env, 400, {"error": "missing body"}.to_json unless body
    radio = Radio.create_from body

    db = PG.connect @@config.pgsql
    begin
      radio = Radio.update(db, id, radio)[0]
    ensure
      db.close
    end
    radio.to_json
  end

  # Delete by ID
  before_delete "/radios/:radio" do |env|
    auth, err = Radios.authorized?(env, AuthLevel::ADMIN)
    halt env, 401, err unless auth
  end
  delete "/radios/:radio" do |env|
    id = 0
    Query.id

    db = PG.connect @@config.pgsql
    begin
      Radio.remove(db, id)
    ensure
      db.close
    end

    {"ok": "resource deleted"}.to_json
  end
end
