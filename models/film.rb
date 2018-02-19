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
    sql = "INSERT INTO films
      (
        title
      )
      VALUES
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
    sql = "SELECT c.*
      FROM customers AS c
      INNER JOIN tickets AS t
      ON c.id = t.customer_id
      INNER JOIN screenings AS s
      ON t.screening_id = s.id
      WHERE s.film_id = $1;"
    result = SqlRunner.run(sql, [@id])
    customers = result.map {|customer| Customer.new(customer)}
    return customers
  end

  def customer_count()
    sql = "SELECT COUNT(c.id)
      FROM customers AS c
      INNER JOIN tickets AS t
      ON c.id = t.customer_id
      INNER JOIN screenings AS s
      ON t.screening_id = s.id
      WHERE s.film_id = $1;"
    result = SqlRunner.run(sql, [@id])
    count = result[0]['count'].to_i
    return count
  end

  def busiest_screening()
    sql = "SELECT s.*, COUNT(t.id)
      FROM screenings AS s
      INNER JOIN tickets AS t
      ON s.id = t.screening_id
      WHERE s.film_id = $1
      GROUP BY s.id
      ORDER BY COUNT(t.id) DESC;"
    result = SqlRunner.run(sql, [@id])
    busiest = []
    for screening in result
      busiest << screening if screening['count'] == result[0]['count']
    end
    screenings = busiest.map {|screening| Screening.new(screening)}
    return screenings
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

  def Film.find(film_id)
    sql = "SELECT * FROM films WHERE id = $1"
    result = SqlRunner.run(sql, [film_id])
    return Film.new(result[0])
  end

end
