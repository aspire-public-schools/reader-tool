
#you can populate it this way
# reader1 = Reader.create(email: "benjamin.crosby@aspirepublicschools.org", employee_number: 2043, first_name: "Benjamin", last_name: "Crosby")
# reader2 = Reader.create(email: "matt.seigel@aspirepublicschools.org", employee_number: 1491, first_name: "Matthew", last_name: "Seigel")
# reader3 = Reader.create(email: "kimberly.whitehead@aspirepublicschools.org", employee_number: 2862, first_name: "Kimberly", last_name: "Whitehead")
# reader4 = Reader.create(email: "james.gallagher@aspirepublichschools.org", employee_number: 1118, first_name: "James", last_name: "Gallagher")
# reader5 = Reader.create(email: "abbey.esposto@aspirepublicschools.org", employee_number: 5058, first_name: "Abbey", last_name: "Esposto")
# reader6 = Reader.create(email: "julie.tsai@aspirepublicschools.org", employee_number: 3605, first_name: "Julie", last_name: "Tsai")

#You can also populate this way

# %x(rake db:schema:load db:seed)



reader_list = [
  [ "benjamin.crosby@aspirepublicschools.org", 2043, "Benjamin", "Crosby"],
  [ "matt.seigel@aspirepublicschools.org", 1491, "Matthew", "Seigel"],
  [ "kimberly.whitehead@aspirepublicschools.org", 2862, "Kimberly", "Whitehead"],
  [ "james.gallagher@aspirepublichschools.org", 1118, "James", "Gallagher"],
  [ "abbey.esposto@aspirepublicschools.org", 5058, "Abbey", "Esposto"],
  [ "julie.tsai@aspirepublicschools.org", 3605, "Julie", "Tsai"]
]

reader_list.each do | email, employee_number, first_name, last_name |
  Reader.create( email: email, employee_number: employee_number, first_name: first_name, last_name: last_name)
end

domain_list = [
  [ 1, "Data-Driven Planning and Assessment"],
  [ 2, "Classroom Learning Environment"],
  [ 3, "Instruction"],
  [ 4, "Professional Responsibilites"]
]

domain_list.each do | number, description |
  Domain.create( number: number, description: description )
end


indicator_list = [
  [ "1.1A", "Selection of Learning Objectives", 1],
  [ "1.1B", "Measurability of learning objectives through summative assessments", 1],
  [ "1.2A", "Designing and sequencing of learning experiences", 1],
  [ "1.2B", "Creating cognitively engaging learning experiences for students", 1],
  [ "1.3A", "Lesson Design guided by Data", 1],
  [ "1.4A", "Knowledge of subject matter to identify pre-requisite knowledge & skills", 1],
  [ "1.4B", "Addresses common content misconceptions", 1],
  [ "1.5A", "Selection and progression of formative assessments", 1],

  [ "2.1A", "Wbatever is new", 2],
  [ "2.1B", "Second descrition", 2],

  [ "3.1A", "Third descrition", 3],
  [ "3.1B", "Third descrition", 3],
  [ "3.1C", "Third descrition", 3],

  [ "4.1A", "fourth descrition", 4],
  [ "4.1B", "fourth descrition", 4],
  [ "4.1C", "fourth descrition", 4]

]

indicator_list.each do |code, description, domain_id|
  Indicator.create( code: code, description: description, domain_id: domain_id )
end

evidence1 = EvidenceScore.create(indicator_score_id: 1, description: "Teacher walks around the room")
evidence2 = EvidenceScore.create(indicator_score_id: 2, description: "Wait-time")
evidence3 = EvidenceScore.create(indicator_score_id: 3, description: "Checks for understanding")
evidence4 = EvidenceScore.create(indicator_score_id: 4, description: "calls on students")
evidence5 = EvidenceScore.create(indicator_score_id: 5, description: "disciplines student")

