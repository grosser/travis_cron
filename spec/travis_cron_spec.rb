require "spec_helper"
require "rest_client"
require "base64"

describe TravisCron do
  describe "#run" do
    it "runs" do
      ENV['CONFIG_YML'] = Base64.encode64(File.read("config.example.yml")).gsub("\n","")
      ENV['RAILS_ENV'] = 'test'

      project = TravisCron.config["projects"][0]
      TravisCron.should_receive(:puts).with("#{project["url"]} - #{project["branch"]}: true")
      TravisCron.run(TravisCron.config)
    end
  end
end
