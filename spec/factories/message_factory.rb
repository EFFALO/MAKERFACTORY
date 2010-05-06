Factory.sequence :mail_id do |n|
  "<#{n}o20091026183344.7C5C079AC2E@buttz.local>"
end

Factory.define :message do |m|
  m.subject Faker::Company.bs
  m.from Faker::Internet.email
  m.body Faker::Company.catch_phrase
  m.mail_date Date.today
  m.mail_id { Factory.next(:mail_id) }
end