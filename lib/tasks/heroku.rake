namespace :heroku do

  desc "Deploy to Heroku"
  task :deploy do
    branch = ENV['BRANCH'] || `git rev-parse --abbrev-ref HEAD`.chomp
    # staging collegeready-readertool
    exec "git push #{ENV['ENV']||branch} #{branch}:master -f" 
  end

  task :bootstrap => [:deploy] do
    exec "heroku run rake db:migrate db:seed schoolzilla:import TRUNCATE=true --app #{branch}-readertool"
  end

  task :import do
    exec "heroku run rake schoolzilla:import"
  end


  desc "Seed database"
  task :seed do
    `heroku run rake db:seed --app #{branch}-readertool`
  end


  def branch
    ENV['BRANCH'] || `git rev-parse --abbrev-ref HEAD`.chomp
  end

end