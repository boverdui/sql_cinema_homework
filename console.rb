require_relative('models/film.rb')
require_relative('models/customer.rb')
require_relative('models/ticket.rb')

require('pry-byebug')

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

customer1 = Customer.new({'name' => 'Bert', 'funds' => 5000})
customer2 = Customer.new({'name' => 'Alex', 'funds' => 10000})

customer1.save()
customer2.save()

film1 = Film.new({'title' => 'Memento', 'price' => 750})
film2 = Film.new({'title' => 'The Prestige', 'price' => 750})
film3 = Film.new({'title' => 'Inception', 'price' => 1000})
film4 = Film.new({'title' => 'Dunkirk', 'price' => 1250})

film1.save()
film2.save()
film3.save()
film4.save()

ticket1 = customer1.buy_ticket(film1.id)
ticket2 = customer1.buy_ticket(film2.id)
ticket3 = customer1.buy_ticket(film3.id)
ticket4 = customer2.buy_ticket(film1.id)

binding.pry

nil
