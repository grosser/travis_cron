require "yaml"
require "base64"

$LOAD_PATH << "lib"
require "travis_cron"

desc "run tests"
task :default do
  sh "rspec spec"
end

desc "report"
task :cron do
  report_errors_to_airbrake do
    TravisCron.run(TravisCron.config)
  end
end

namespace :heroku do
  task :configure do
    config = Base64.encode64(File.read("config.yml")).gsub("\n","")
    sh "heroku config:add CONFIG_YML=#{config}"
    sh "heroku config:add RAILS_ENV=production"
  end
end

def report_errors_to_airbrake
  if !["test", "development"].include?(TravisCron.env) and api_key = TravisCron.config[:report_errors_to]
    require "airbrake"
    Airbrake.configure { |config| config.api_key = api_key }
    begin
      yield
    rescue Exception => e
      puts "reporting error to airbrake"
      Airbrake.notify_or_ignore(e)
      raise e
    end
  else
    yield
  end
end
