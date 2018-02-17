require_relative('../db/sql_runner.rb')
require_relative('customer.rb')

class Screening

  attr_accessor :time, :price, :capacity
  attr_reader :id, :film_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @time = options['time']
    @price = options['price'].to_i
    @capacity = options['capacity'].to_i
    @film_id = options['film_id'].to_i
  end

  def save()
    sql = "INSERT INTO screenings
      (
        time,
        price,
        capacity,
        film_id
      )
      VALUES
      (
        $1, $2, $3, $4
      )
      RETURNING id;"
    result = SqlRunner.run(sql, [@time, @price, @capacity, @film_id])
    @id = result[0]['id'].to_i
  end

  def update()
    sql = "UPDATE screenings
      SET
      (
        time,
        price,
        capacity,
        film_id
      ) =
      (
        $1, $2, $3, $4
      )
      WHERE id = $5;"
    SqlRunner.run(sql, [@time, @price, @capacity, @film_id, @id])
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1;"
    SqlRunner.run(sql, [@id])
  end

  def customers()
    sql =
      "SELECT customers.*
      FROM customers
      INNER JOIN tickets
      ON customers.id = tickets.customer_id
      WHERE tickets.screening_id = $1;"
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
      WHERE tickets.screening_id = $1;"
    result = SqlRunner.run(sql, [@id])
    count = result[0]['count'].to_i
    return count
  end

  def ticket_available()
    return customer_count < @capacity
  end

  def Screening.all()
    sql = "SELECT * FROM screenings;"
    result = SqlRunner.run(sql)
    screenings = result.map{|screening| Screening.new(screening)}
    return screenings
  end

  def Screening.delete_all()
    sql = "DELETE FROM screenings;"
    SqlRunner.run(sql)
  end

  def Screening.find(screening_id)
    sql = "SELECT * FROM screenings WHERE id = $1"
    result = SqlRunner.run(sql, [screening_id])
    return Screening.new(result[0])
  end

end
