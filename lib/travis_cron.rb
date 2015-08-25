require 'rest_client'
require 'json'

module TravisCron
  class << self
    # configure self from env or config.yml
    def config
      config = if encoded = ENV['CONFIG_YML']
        require 'base64'
        Base64.decode64(encoded)
      else
        File.read('config.yml')
      end
      YAML.load(config)[env].freeze
    end

    def env
      ENV['RAILS_ENV'] || 'development'
    end

    def run(config)
      #AirbrakeAPI.account = config.fetch(:subdomain)
      #AirbrakeAPI.auth_token = config.fetch(:auth_token)
      #AirbrakeAPI.secure = true

      config.fetch("projects").each do |project|
        project["token"] ||= config["token"] # support default token
        project["branch"] ||= "master"
        result = restart_build(project)
        puts "#{project["url"]} - #{project["branch"]}: #{result}"
      end
    end

    private

    def restart_build(project)
      auth = {:Authorization => %{token "#{project.fetch("token")}"}}

      scheme, _, host, path = project.fetch("url").split("/", 4)
      base = "#{scheme}//api.#{host.split(".").last(2).join(".")}"
      branch = project.fetch("branch")

      result = RestClient.get("#{base}/repos/#{path}/builds", auth)
      build = JSON.load(result).detect { |p| p["branch"] == branch }
      raise "No build found for branch #{branch}" unless build
      last_build_id = build["id"]

      result = RestClient.post("#{base}/builds/#{last_build_id}/restart", {}, auth)
      result = JSON.load(result)
      !result["flash"][0]["error"] && result['result']
    end
  end
end
