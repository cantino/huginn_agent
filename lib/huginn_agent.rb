require 'huginn_agent/version'

class HuginnAgent
  class << self
    def load_tasks
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
      agent_paths.each do |path|
        require path
        Agent::TYPES << "Agents::#{File.basename(path.to_s).camelize}"
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
