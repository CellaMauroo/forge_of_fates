namespace :demo do
  desc "Prepare the database and load portfolio characters"
  task prepare: :environment do
    Rake::Task["db:prepare"].invoke
    Rake::Task["db:seed"].invoke
    load Rails.root.join("db/demo_seeds.rb")
  end
end

