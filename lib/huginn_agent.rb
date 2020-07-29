require 'huginn_agent/version'

class HuginnAgent
  class << self
    attr_accessor :branch, :remote

    def load_tasks(options = {})
      @branch = options[:branch] || 'master'
      @remote = options[:remote] || 'https://github.com/huginn/huginn.git'
      Rake.add_rakelib File.join(File.expand_path('../', __FILE__), 'tasks')
    end

    def load(*paths)
      paths.each do |path|
        load_paths << path
      end
    end

    def register(*paths)
      paths.each do |path|
        agent_paths << path
      end
    end

    def require!
      load_paths.each do |path|
        require path
      end

      additional_agents.each do |agent|
        Agent::TYPES << agent
      end
    end

    def additional_agents
      agent_paths.map do |path|
        require path
        "Agents::#{File.basename(path.to_s).camelize}"
      end
    end

    private

    def load_paths
      @load_paths ||= []
    end

    def agent_paths
      @agent_paths ||= []
    end
  end
end
