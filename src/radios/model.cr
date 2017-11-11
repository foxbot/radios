require "json"

module Radios
  struct Radio
    SELECT_ALL = "SELECT id, name, url, category, genre, country, last_tested, state"

    JSON.mapping(
      id: {type: Int32, nilable: true},
      name: String,
      url: String,
      category: String,
      genre: String,
      country: String,
      last_tested: Time,
      state: Int32
    )

    def self.create_from(json)
      self.from_json(json)
    end

    def self.all(db, state, start, limit)
      self.transform(db.query(%{
        #{SELECT_ALL}
        FROM radios
        WHERE state = $1
        ORDER BY id
        OFFSET $2
        LIMIT $3;
                              },
                                state, start, limit))
    end

    def self.one(db, id)
      self.transform(db.query(%{
        #{SELECT_ALL}
        FROM radios
        WHERE id = $1
        LIMIT 1;
                              },
                                id))
    end

    def self.insert(db, radio)
      db.exec(%{
        INSERT INTO radios
        (name, url, category, genre, country, last_tested, state)
        VALUES ($1, $2, $3, $4, $5, $6, $7);
              },
                radio.name, radio.url, radio.category, radio.genre,
                radio.country, radio.last_tested, radio.state)
    end


    def self.transform(table)
      table.each do
        {
          id: table.read(Int32),
          name: table.read(String),
          url: table.read(String),
          category: table.read(String),
          genre: table.read(String),
          country: table.read(String),
          last_tested: table.read(Time),
          state: table.read(Int32)
        }
      end
    end
  end
end
