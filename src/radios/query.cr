require "json"

module Query
  macro paginate
    %start = env.params.query["start"]?
      %limit = env.params.query["limit"]?

      if %start
        start = %start.to_i?
        halt env, 400, {"error": "start must be an integer"}.to_json unless start
    else
      start = 0
    end

    if %limit
      limit = %limit.to_i?
      halt env, 400, {"error": "limit must be an integer"}.to_json unless limit
    else
      limit = 100
    end
  end

  macro id
    id = env.params.url["radio"].to_i?
    halt env, 400, {"error": "id must be an integer"}.to_json unless id
  end
end
