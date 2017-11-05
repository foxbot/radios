require "json"

module Query
  macro paginate
    start = env.params.query.fetch("start", 0)
    start = start.to_i? unless start.is_a?(Int32)
    halt env, 400, {"error": "start must be an integer"}.to_json unless start

    limit = env.params.query.fetch("limit", 100)
    limit = limit.to_i? unless limit.is_a?(Int32)
    halt env, 400, {"error": "limit must be an integer"}.to_json unless limit
  end

  macro state
    state = env.params.query.fetch("state", 0)
    state = state.to_i? unless state.is_a?(Int32)

    halt env, 400, {"error": "state must be an integer"}.to_json unless state
    halt env, 400, {"error": "state must be within [0, 2]"}.to_json unless 0 <= state <= 2
  end

  macro id
    id = env.params.url["radio"].to_i?
    halt env, 400, {"error": "id must be an integer"}.to_json unless id
  end
end
