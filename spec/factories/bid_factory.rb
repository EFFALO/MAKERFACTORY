Factory.define :bid do |b|
  b.message 'I want to build it!'
  b.quantity 3000
  b.association :job, :factory => :job
  b.association :creator, :factory => :user
end