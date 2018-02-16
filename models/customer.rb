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
    sql =
    "INSERT INTO customers
    (
      name,
      funds
    )
    values
    (
      $1, $2
    )
    RETURNING id;"
    result = SqlRunner.run(sql, [@name, @funds])
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

  def buy_ticket(id_number)
    screening = Screening.find(id_number)
    if screening.ticket_available()
      @funds -= screening.price
      update()
      ticket = Ticket.new({'screening_id' => id_number, 'customer_id' => @id})
      ticket.save()
      return ticket
    end
  end

  def screenings()
    sql =
      "SELECT screenings.*
      FROM screenings
      INNER JOIN tickets
      ON screenings.id = tickets.screening_id
      WHERE customer_id = $1;"
    result = SqlRunner.run(sql, [@id])
    screenings = result.map {|screening| Screening.new(screening)}
    return screenings
  end

  def screening_count()
    sql =
      "SELECT COUNT(screenings.id)
      FROM screenings
      INNER JOIN tickets
      ON screenings.id = tickets.screening_id
      WHERE customer_id = $1;"
    result =  SqlRunner.run(sql, [@id])
    count = result[0]['count'].to_i
    return count
  end

  def films()
    sql =
      "SELECT films.*
      FROM films
      INNER JOIN screenings
      ON films.id = screenings.film_id
      INNER JOIN tickets
      ON screenings.id = tickets.screening_id
      WHERE tickets.customer_id = $1
      GROUP BY films.id;"
    result = SqlRunner.run(sql, [@id])
    films = result.map {|film| Film.new(film)}
    return films
  end

  def film_count()
    sql =
      "SELECT COUNT(DISTINCT films.id)
      FROM films
      INNER JOIN screenings
      ON films.id = screenings.film_id
      INNER JOIN tickets
      ON screenings.id = tickets.screening_id
      WHERE tickets.customer_id = $1;"
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

  def Customer.find(id_number)
    sql = "SELECT * FROM customers WHERE id = $1"
    result = SqlRunner.run(sql, [id_number])
    return Customer.new(result[0])
  end

end
