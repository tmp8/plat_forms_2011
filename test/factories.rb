# encoding: utf-8

Factory.define :user do |f|
  f.username { Faker::Name.first_name.downcase }
  f.full_name { Faker::Name.name }
  f.country "Germany"
  f.email { Faker::Internet.email }
  f.city { Faker::Address.city }
  f.password "123456"
  f.password_confirmation "123456"
end

Factory.define :admin, :parent => :user do |f|
  f.username "admin"
  f.password "admin"
  f.password_confirmation "admin"
end

Factory.define :friendship do |f|
  f.association :user
  f.association :friend
end

Factory.define :conference do |f|
  f.name  { Faker::Name.name }
  f.startdate { Date.today }
  f.enddate { Date.today + 1 }
  f.description { Faker::Lorem.sentence }
  f.location { Faker::Lorem.sentence }
  f.association :creator, :factory => :user
end

Factory.define :conference_participation do |f|
  f.association :conference
  f.association :user
end

Factory.define :category do |f|
  f.name { Faker::Name.name }
end

Factory.define :notification do |f|
  f.association :user
  f.receiver { Factory(:user) }
  f.subject { Factory(:conference) }
end

