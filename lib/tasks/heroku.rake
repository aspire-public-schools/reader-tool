namespace :heroku do

  desc "Deploy to Heroku"
  task :deploy do
    # staging collegeready-readertool
    exec "git push #{ENV['ENV']||'heroku'} #{ENV['BRANCH'] || 'dfl'}:master" 
  end

end