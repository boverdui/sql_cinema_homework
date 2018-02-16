require_relative('../db/sql_runner.rb')
require_relative('customer.rb')
require_relative('screening.rb')

class Film

  attr_accessor :title
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
  end

  def save()
    sql =
    "INSERT INTO films
    (
      title
    )
    values
    (
      $1
    )
    RETURNING id;"
    result = SqlRunner.run(sql, [@title])
    @id = result[0]['id'].to_i
  end

  def update()
    sql = "UPDATE films SET title = $1 WHERE id = $2;"
    SqlRunner.run(sql, [@title, @id])
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1;"
    SqlRunner.run(sql, [@id])
  end

  def customers()
    sql =
      "SELECT DISTINCT customers.name
      FROM customers
      INNER JOIN tickets
      ON customers.id = tickets.customer_id
      INNER JOIN screenings
      ON screenings.id = tickets.screening_id
      WHERE screenings.film_id = $1;"
    result = SqlRunner.run(sql, [@id])
    customers = result.map {|customer| Customer.new(customer)}
    return customers
  end

  def customer_count()
    sql =
      "SELECT COUNT(DISTINCT customers.name)
      FROM customers
      INNER JOIN tickets
      ON customers.id = tickets.customer_id
      INNER JOIN screenings
      ON screenings.id = tickets.screening_id
      WHERE screenings.film_id = $1;"
    result = SqlRunner.run(sql, [@id])
    count = result[0]['count'].to_i
    return count
  end

  def busiest_screening()
    sql =
      "SELECT screenings.*
      FROM screenings
      INNER JOIN tickets
      ON screenings.id = tickets.screening_id
      WHERE screenings.film_id = $1
      GROUP BY screenings.id
      ORDER BY COUNT(tickets.id) DESC;"
    result = SqlRunner.run(sql, [@id])
    return Screening.new(result[0])
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
