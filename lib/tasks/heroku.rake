namespace :heroku do

  desc "Deploy to Heroku"
  task :deploy do
    branch = ENV['BRANCH'] || `git rev-parse --abbrev-ref HEAD`.chomp
    # staging collegeready-readertool
    exec "git push #{ENV['ENV']||'heroku'} #{branch}:master" 
  end

end