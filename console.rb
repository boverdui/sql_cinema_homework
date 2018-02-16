require_relative('models/film.rb')
require_relative('models/customer.rb')
require_relative('models/ticket.rb')

require('pry-byebug')

Ticket.delete_all()
Film.delete_all()
Customer.delete_all()

customer1 = Customer.new({'name' => 'Bert', 'funds' => 5000})
customer1.save()
customer2 = Customer.new({'name' => 'Alex', 'funds' => 10000})
customer2.save()

film1 = Film.new({'title' => 'Memento', 'price' => 750})
film1.save()
film2 = Film.new({'title' => 'Insomnia', 'price' => 750})
film2.save()
film3 = Film.new({'title' => 'Batman Begins', 'price' => 1000})
film3.save()
film4 = Film.new({'title' => 'The Prestige', 'price' => 750})
film4.save()
film5 = Film.new({'title' => 'The Dark Knight', 'price' => 1000})
film5.save()
film6 = Film.new({'title' => 'Inception', 'price' => 1000})
film6.save()
film7 = Film.new({'title' => 'The Dark Knight Rises', 'price' => 1000})
film7.save()
film8 = Film.new({'title' => 'Interstellar', 'price' => 1250})
film8.save()
film9 = Film.new({'title' => 'Dunkirk', 'price' => 1250})
film9.save()


ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket1.save()
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id})
ticket2.save()
ticket3 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film2.id})
ticket3.save()
ticket4 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film3.id})
ticket4.save()

binding.pry

nil
