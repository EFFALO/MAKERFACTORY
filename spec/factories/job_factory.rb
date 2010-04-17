Factory.define :job do |j|
  j.description "Get son a real job"
  j.title "Improve my family worth"
  j.fabrication_type "Job creation"
  j.quantity_needed 9000
  j.deliver_by Time.now + 1.week
  j.deliver_to "Savannah, GA"
end