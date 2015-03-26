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

# domain_list = [
#   [ 1, "Data-Driven Planning and Assessment"],
#   [ 2, "Classroom Learning Environment"],
#   [ 3, "Instruction"],
#   [ 4, "Professional Responsibilites"]
# ]

# domain_list.each do | number, description |
#   Domain.create( number: number, description: description )
# end


# indicator_list = [
#   [ "1.1A", "Selection of Learning Objectives", 1],
#   [ "1.1B", "Measurability of learning objectives through summative assessments", 1],
#   [ "1.2A", "Designing and sequencing of learning experiences", 1],
#   [ "1.2B", "Creating cognitively engaging learning experiences for students", 1],
#   [ "1.3A", "Lesson Design guided by Data", 1],
#   [ "1.4A", "Knowledge of subject matter to identify pre-requisite knowledge & skills", 1],
#   [ "1.4B", "Addresses common content misconceptions", 1],
#   [ "1.5A", "Selection and progression of formative assessments", 1],

#   [ "2.1A", "Wbatever is new", 2],
#   [ "2.1B", "Second description", 2],

#   [ "3.1A", "Third description", 3],
#   [ "3.1B", "Third description", 3],
#   [ "3.1C", "Third description", 3],

#   [ "4.1A", "fourth description", 4],
#   [ "4.1B", "fourth description", 4],
#   [ "4.1C", "fourth description", 4]

# ]

# indicator_list.each do |code, description, domain_id|
#   Indicator.create( code: code, description: description, domain_id: domain_id )
# end

# evidence1 = EvidenceScore.create(indicator_score_id: 1, description: "Teacher walks around the room")
# evidence2 = EvidenceScore.create(indicator_score_id: 2, description: "Wait-time")
# evidence3 = EvidenceScore.create(indicator_score_id: 3, description: "Checks for understanding")
# evidence4 = EvidenceScore.create(indicator_score_id: 4, description: "calls on students")
# evidence5 = EvidenceScore.create(indicator_score_id: 5, description: "disciplines student")

