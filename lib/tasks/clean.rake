namespace :clean do
  desc "Clean out old uploads"
  task :uploads => :environment do
    Upload.clean
  end
end