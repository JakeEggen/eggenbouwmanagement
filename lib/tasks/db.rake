# The app no longer has a database. These no-op tasks keep any hosting
# build/pre-deploy/start command that still calls them from failing.
namespace :db do
  %w[prepare migrate create setup].each do |name|
    desc "No-op: the app has no database"
    task name do
      puts "db:#{name} skipped: the app has no database"
    end
  end
end
