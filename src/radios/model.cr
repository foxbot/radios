require "json"

module Radios
  struct Radio
    SELECT_ALL = "SELECT id, name, url, category, genre, country, last_tested, state"

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

    def self.all(db, state, start, limit)
      self.transform(db.query(%{
        #{SELECT_ALL}
        FROM radios
        WHERE state = $1
        ORDERBY id
        OFFSET $2
        LIMIT $3;
      }, state, start, limit))
    end

    def self.one(db, id)
      self.transform(db.query(%{
        #{SELECT_ALL}
        FROM radios
        WHERE id = $1
        LIMIT 1;
      }, id))
    end

    def self.transform(table)
      table.each do
        {
          id: table.read(UInt32),
          name: table.read(String),
          url: table.read(String),
          category: table.read(String),
          genre: table.read(String),
          country: table.read(String),
          last_tested: table.read(Time),
          state: table.read(UInt8)
        }
      end
    end
  end
end
