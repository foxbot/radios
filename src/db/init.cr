require "pg"

pg_path = ENV["pgsql"]

puts "connecting on #{pg_path}"
conn = PG.connect pg_path

puts "creating table"
conn.exec(%{
  CREATE TABLE radios (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    url         TEXT NOT NULL,
    category    TEXT NOT NULL,
    genre       TEXT NOT NULL,
    country     TEXT NOT NULL,
    last_tested TIMESTAMP NOT NULL,
    state       INT
  );
})

puts "done"
conn.close
