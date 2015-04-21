namespace :heroku do

  desc "Deploy to Heroku"
  task :deploy do
    branch = ENV['BRANCH'] || `git rev-parse --abbrev-ref HEAD`.chomp
    # staging collegeready-readertool
    exec "git push #{ENV['ENV']||branch} #{branch}:master -f" 
  end

  task :bootstrap_db do
    run_rake_task "db:migrate db:seed schoolzilla:import TRUNCATE=true"
  end

  task :bootstrap => [:deploy, :bootstrap_db]

  # task :import do
  #   exec "heroku run rake schoolzilla:import --app #{branch}-readertool"
  # end

  desc "Seed database"
  task :seed do
    run_rake_task "db:seed"
  end


  def branch
    ENV['BRANCH'] || `git rev-parse --abbrev-ref HEAD`.chomp
  end


  def run_rake_task task
    task = task.join(" ") if task.is_a?(Array)
    exec "heroku run rake #{task} --app #{branch}-readertool"
  end

end