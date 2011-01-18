# Insert Factories
Factory.define :user do |f|
  f.email { Faker::Internet.email }
  f.password { "12345677" }
end

Factory.define :friendship do |f|
  f.association :user
  f.association :friend
end

Factory.define :conference do |f|
  f.name :name
end

Factory.define :conference_participation do |f|
  f.association :conference
  f.association :user
end
