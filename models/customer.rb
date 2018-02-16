require_relative('../db/sql_runner.rb')
require_relative('film.rb')

class Customer

  attr_accessor :name
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
  end

  def save()
    sql =
    "INSERT INTO customers
    (
      name
    )
    values
    (
      $1
    )
    RETURNING id;"
    result = SqlRunner.run(sql, [@name])
    @id = result[0]['id'].to_i
  end

  def update()
    sql =
    "UPDATE customers
    SET
    (
      name,
      funds
    ) =
    (
      $1, $2
    )
    WHERE id = $3;"
    SqlRunner.run(sql, [@name, @funds, @id])
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1;"
    SqlRunner.run(sql, [@id])
  end

  def films()
    sql =
      "SELECT films.*
      FROM films
      INNER JOIN tickets
      ON films.id = tickets.film_id
      WHERE customer_id = $1;"
    result = SqlRunner.run(sql, [@id])
    films = result.map {|film| Film.new(film)}
    return films
  end

  def Customer.all()
    sql = "SELECT * FROM customers"
    result = SqlRunner.run(sql)
    customers = result.map{|customer| Customer.new(customer)}
    return customers
  end

  def Customer.delete_all()
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql)
  end

end
