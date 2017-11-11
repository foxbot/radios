require "./query"
require "./model"
require "db"
require "pg"

module Radios
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
  post "/radios" do |env|
    body = env.request.body
    halt env, 400, {"error": "missing body"}.to_json unless body
    data = Radio.create_from body

    db = PG.connect @@config.pgsql
    begin
      Radio.insert(db, data)
    ensure
      db.close
    end

    data.to_json
  end

  # Search by Name
  get "/radios/search/:name" do |env|
    name = env.params.url["name"]
    start, limit = 0,0
    Query.paginate
  end

  # Get by ID
  get "/radios/:radio" do |env|
    id = 0
    Query.id

    db = PG.connect @@config.pgsql
    begin
      radio = Radio.one(db, id)
      if radio.size < 1
        halt env, 400, {"error": "resource not found"}.to_json
      end
      radio = radio[0]
    ensure
      db.close
    end
    radio.to_json
  end

  # Modify by ID
  patch "/radios/:radio" do |env|
    id = 0
    Query.id
  end

  # Delete by ID
  delete "/radios/:radio" do |env|
    id = 0
    Query.id
  end
end
