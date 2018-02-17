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
film2 = Film.new({'title' => 'Inception'})

film1.save()
film2.save()

screening1 = Screening.new({'time' => '14:00', 'price' => 750, 'capacity' => 3, 'film_id' => film1.id})
screening2 = Screening.new({'time' => '16:00', 'price' => 750, 'capacity' => 3, 'film_id' => film2.id})
screening3 = Screening.new({'time' => '20:00', 'price' => 1250, 'capacity' => 3, 'film_id' => film2.id})
screening4 = Screening.new({'time' => '22:00', 'price' => 1250, 'capacity' => 3, 'film_id' => film2.id})

screening1.save()
screening2.save()
screening3.save()
screening4.save()

customer1 = Customer.new({'name' => 'Bert', 'funds' => 10000})
customer2 = Customer.new({'name' => 'Alex', 'funds' => 7500})
customer3 = Customer.new({'name' => 'Oli', 'funds' => 5000})
customer4 = Customer.new({'name' => 'Screening full', 'funds' => 2500})
customer5 = Customer.new({'name' => 'No funds', 'funds' => 0})

customer1.save()
customer2.save()
customer3.save()
customer4.save()
customer5.save()

ticket1 = customer1.buy_ticket(screening1.id)
ticket2 = customer1.buy_ticket(screening2.id)
ticket3 = customer1.buy_ticket(screening3.id)
ticket4 = customer1.buy_ticket(screening4.id)
ticket5 = customer1.buy_ticket(screening4.id)
ticket6 = customer2.buy_ticket(screening3.id)
ticket7 = customer3.buy_ticket(screening3.id)
ticket8 = customer4.buy_ticket(screening3.id)
ticket9 = customer5.buy_ticket(screening1.id)

binding.pry

nil
