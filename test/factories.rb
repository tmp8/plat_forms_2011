# Insert Factories
Factory.define :user do |f|
  f.username { Faker::Name.name }
  f.country { "Germany" }
  f.email { Faker::Internet.email }
  f.password { "123456" }
  f.password_confirmation { "123456" }
end

Factory.define :friendship do |f|
  f.association :user
  f.association :friend
end
