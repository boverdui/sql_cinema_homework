require_relative('../db/sql_runner.rb')

class Ticket

  attr_accessor
  attr_reader :id, :film_id, :customer_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @customer_id = options['customer_id'].to_i
  end

  def save()
    sql =
    "INSERT INTO tickets
    (
      film_id,
      customer_id
    )
    values
    (
      $1, $2
    )
    RETURNING id;"
    result = SqlRunner.run(sql, [@film_id, @customer_id])
    @id = result[0]['id'].to_i
  end

  def update()
    sql =
    "UPDATE tickets
    SET
    (
      film_id,
      customer_id
    ) =
    (
      $1, $2
    )
    WHERE id = $3;"
    SqlRunner.run(sql, [@film_id, @customer_id, @id])
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1;"
    SqlRunner.run(sql, [@id])
  end

  def Ticket.all()
    sql = "SELECT * FROM tickets"
    result = SqlRunner.run(sql)
    tickets = result.map{|ticket| Ticket.new(ticket)}
    return tickets
  end

  def Ticket.delete_all()
    sql = "DELETE FROM tickets;"
    SqlRunner.run(sql)
  end

end