require_relative('models/customer.rb')
require_relative('models/film.rb')
require_relative('models/screening.rb')
require_relative('models/ticket.rb')

require('pry-byebug')

Ticket.delete_all()
Customer.delete_all()
Screening.delete_all()
Film.delete_all()

film1 = Film.new({'title' => 'Memento'})
film2 = Film.new({'title' => 'Inception',})

film1.save()
film2.save()

screening1 = Screening.new({'time' => '14:00', 'price' => 750, 'capacity' => 2, 'film_id' => film1.id})
screening2 = Screening.new({'time' => '16:00', 'price' => 750, 'capacity' => 2, 'film_id' => film2.id})
screening3 = Screening.new({'time' => '20:00', 'price' => 1250, 'capacity' => 2, 'film_id' => film2.id})
screening4 = Screening.new({'time' => '22:00', 'price' => 1250, 'capacity' => 2, 'film_id' => film2.id})

screening1.save()
screening2.save()
screening3.save()
screening4.save()

customer1 = Customer.new({'name' => 'Bert', 'funds' => 5000})
customer2 = Customer.new({'name' => 'Alex', 'funds' => 10000})
customer3 = Customer.new({'name' => 'Oli', 'funds' => 7500})

customer1.save()
customer2.save()
customer3.save()

ticket1 = customer1.buy_ticket(screening1.id)
ticket2 = customer1.buy_ticket(screening2.id)
ticket3 = customer1.buy_ticket(screening3.id)
ticket4 = customer1.buy_ticket(screening4.id)
ticket5 = customer2.buy_ticket(screening3.id)
ticket6 = customer3.buy_ticket(screening3.id)

binding.pry

nil
