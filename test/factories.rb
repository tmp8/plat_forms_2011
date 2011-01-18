# Insert Factories
Factory.define :user do |f|
  f.email { Faker::Internet.email }
  f.password { "12345677" }
end

Factory.define :friendship do |f|
  f.association :user
  f.association :friend
end
