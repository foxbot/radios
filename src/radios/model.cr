require "json"
require "db"

module Radios
  struct Radio
    SELECT_ALL = "SELECT id, name, url, category, genre, country, last_tested, state"

    ALL = <<-SQL
    #{SELECT_ALL}
    FROM RADIOS
    WHERE STATE = $1
    ORDER BY id
    OFFSET $2
    LIMIT $3;
    SQL

    ONE = <<-SQL
    #{SELECT_ALL}
    FROM RADIOS
    WHERE id = $1
    LIMIT 1;
    SQL

    INSERT = <<-SQL
    INSERT INTO radios
    (name, url, category, genre, country, last_tested, state)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    SQL

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
    DB.mapping(
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
      Radio.from_rs(db.query(ALL, state, start, limit))
    end

    def self.one(db, id)
      Radio.from_rs(db.query(ONE, id))
    end

    def self.insert(db, radio)
      db.exec(INSERT, radio.name, radio.url, radio.category, radio.genre,
                radio.country, radio.last_tested, radio.state)
    end


    def self.transform(table)
      pp table
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
