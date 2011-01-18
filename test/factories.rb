# encoding: utf-8

Factory.define :user do |f|
  f.username { Faker::Name.name }
  f.country "Germany"
  f.email { Faker::Internet.email }
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
end

Factory.define :conference_participation do |f|
  f.association :conference
  f.association :user
end
