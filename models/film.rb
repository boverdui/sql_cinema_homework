require_relative('../db/sql_runner.rb')
require_relative('customer.rb')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql =
    "INSERT INTO films
    (
      title,
      price
    )
    values
    (
      $1, $2
    )
    RETURNING id;"
    result = SqlRunner.run(sql, [@title, @price])
    @id = result[0]['id'].to_i
  end

  def update()
    sql =
    "UPDATE films
    SET
    (
      title,
      price
    ) =
    (
      $1, $2
    )
    WHERE id = $3;"
    SqlRunner.run(sql, [@title, @price, @id])
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1;"
    SqlRunner.run(sql, [@id])
  end

  def customers()
    sql =
      "SELECT customers.*
      FROM customers
      INNER JOIN tickets
      ON customers.id = tickets.customer_id
      WHERE tickets.film_id = $1;"
    result = SqlRunner.run(sql, [@id])
    customers = result.map {|customer| Customer.new(customer)}
    return customers
  end

  def customer_count()
    sql =
      "SELECT COUNT(customers.*)
      FROM customers
      INNER JOIN tickets
      ON customers.id = tickets.customer_id
      WHERE tickets.film_id = $1;"
    result = SqlRunner.run(sql, [@id])
    count = result[0]['count'].to_i
    return count
  end

  def Film.all()
    sql = "SELECT * FROM films;"
    result = SqlRunner.run(sql)
    films = result.map{|film| Film.new(film)}
    return films
  end

  def Film.delete_all()
    sql = "DELETE FROM films;"
    SqlRunner.run(sql)
  end

  def Film.find(id_number)
    sql = "SELECT * FROM films WHERE id = $1"
    result = SqlRunner.run(sql, [id_number])
    return Film.new(result[0])
  end

end
