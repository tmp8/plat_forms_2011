# origin: RM
data = JSON.parse(IO.read(File.dirname(__FILE__) + '/data.txt'))
users, foo, conferences, categories, conference_contact = data

p users