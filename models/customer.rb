require_relative('../db/sql_runner.rb')
require_relative('film.rb')
require_relative('screening.rb')
require_relative('ticket.rb')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds']
  end

  def save()
    sql = "INSERT INTO customers
      (
        name,
        funds
      )
      VALUES
      (
        $1, $2
      )
      RETURNING id;"
    result = SqlRunner.run(sql, [@name, @funds])
    @id = result[0]['id'].to_i
  end

  def update()
    sql = "UPDATE customers
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

  def buy_ticket(screening_id)
    screening = Screening.find(screening_id)
    if screening.ticket_available()
      if screening.price <= @funds
        @funds -= screening.price
        update()
        ticket = Ticket.new({'screening_id' => screening_id, 'customer_id' => @id})
        ticket.save()
        return ticket
      end
    end
  end

  def bookings()
    sql = "SELECT s.*
      FROM screenings AS s
      INNER JOIN tickets AS t
      ON s.id = t.screening_id
      WHERE t.customer_id = $1;"
    result = SqlRunner.run(sql, [@id])
    screenings = result.map {|screening| Screening.new(screening)}
    return screenings
  end

  def booking_count()
    sql = "SELECT COUNT(s.*)
      FROM screenings AS s
      INNER JOIN tickets AS t
      ON s.id = t.screening_id
      WHERE t.customer_id = $1;"
    result =  SqlRunner.run(sql, [@id])
    count = result[0]['count'].to_i
    return count
  end

  def films()
    sql = "SELECT DISTINCT f.*
      FROM films AS f
      INNER JOIN screenings AS s
      ON f.id = s.film_id
      INNER JOIN tickets AS t
      ON s.id = t.screening_id
      WHERE t.customer_id = $1;"
    result = SqlRunner.run(sql, [@id])
    films = result.map {|film| Film.new(film)}
    return films
  end

  def film_count()
    sql = "SELECT COUNT(DISTINCT f.*)
      FROM films AS f
      INNER JOIN screenings AS s
      ON f.id = s.film_id
      INNER JOIN tickets AS t
      ON s.id = t.screening_id
      WHERE t.customer_id = $1;"
    result =  SqlRunner.run(sql, [@id])
    count = result[0]['count'].to_i
    return count
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

  def Customer.find(customer_id)
    sql = "SELECT * FROM customers WHERE id = $1"
    result = SqlRunner.run(sql, [customer_id])
    return Customer.new(result[0])
  end

end
