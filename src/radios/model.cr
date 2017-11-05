require "json"

module Model
  struct Radio
    JSON.mapping(
      id: UInt32,
      name: String,
      url: String,
      category: String,
      genre: String,
      country: String,
      last_tested: Time,
      state: UInt8
    )

    def self.create_from(json : String)
      self.from_json(json)
    end

    def self.transform(table)
      table.to_hash.map do |row|
        {
          id: row["id"].as(UInt32),
          name: row["name"].as(String),
          url: row["url"].as(String),
          category: row["category"].as(String),
          genre: row["genre"].as(String),
          country: row["country"].as(String),
          last_tested: Time.parse(row["last_tested"], "%F"),
          state: row["state"].as(UInt8)
        }
      end
    end
  end
end
