require "json"
require "db"

module Radios
  struct Radio
    NAMES = "id, name, url, category, genre, country, last_tested, state"
    SELECT_ALL = "SELECT #{NAMES}"

    ALL = <<-SQL
    #{SELECT_ALL}
    FROM RADIOS
    WHERE STATE = $1
    ORDER BY id
    OFFSET $2
    LIMIT $3;
    SQL

    SEARCH = <<-SQL
    #{SELECT_ALL}
    FROM RADIOS
    WHERE name ILIKE $1
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
    RETURNING #{NAMES};
    SQL

    UPDATE = <<-SQL
    UPDATE RADIOS
    SET name = $2, url = $3, category = $4, genre = $5,
      country = $6, last_tested = $7, state = $8
    WHERE id = $1
    RETURNING #{NAMES};
    SQL

    DELETE = <<-SQL
    DELETE FROM radios
    WHERE id = $1;
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

    def self.search(db, query, start, limit)
      Radio.from_rs(db.query(SEARCH, query, start, limit))
    end

    def self.one(db, id)
      Radio.from_rs(db.query(ONE, id))
    end

    def self.insert(db, radio)
      Radio.from_rs(db.query(INSERT, radio.name, radio.url, radio.category, radio.genre,
              radio.country, radio.last_tested, radio.state))
    end

    def self.update(db, id, radio)
      Radio.from_rs(db.query(UPDATE, id, radio.name, radio.url, radio.category, radio.genre,
                radio.country, radio.last_tested, radio.state))
    end

    def self.remove(db, id)
      db.exec(DELETE, id)
    end
  end
end
