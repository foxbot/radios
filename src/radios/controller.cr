module Radios

  before_all do |env|
    env.response.content_type = "application/json"
  end

  # List
  get "/radios" do |env|
    Query.paginate
  end

  # Create
  post "/radios" do |env|
  end

  # Search by Name
  get "/radios/search/:name" do |env|
    name = env.params.url["name"]
    Query.paginate
  end

  # Get by ID
  get "/radios/:radio" do |env|
    Query.id
  end

  # Modify by ID
  patch "/radios/:radio" do |env|
    Query.id
  end

  # Delete by ID
  delete "/radios/:radio" do |env|
    Query.id
  end

end
