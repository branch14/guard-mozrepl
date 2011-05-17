require 'net/telnet'
require 'guard'
require 'guard/guard'

module Guard
  class Mozrepl < Guard

    def initialize(watchers=[], options={})
      super
      @options = {
        :host => options[:host] || 'localhost',
        :port => options[:port] || 4242,
        :verbose => options[:verbose] || false
      }
      mozrepl
    end

    # Called once when Guard starts
    # Please override initialize method to init stuff
    def start
      true
    end

    # Called on Ctrl-C signal (when Guard quits)
    def stop
      close!
    end

    # Called on Ctrl-Z signal
    # This method should be mainly used for "reload" (really!) actions
    # like reloading passenger/spork/bundler/...
    def reload
      true
    end

    # Called on Ctrl-/ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      true
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      return true if @serious_issue
      reload_tab = false
      paths.each do |path|
        case path
        when /\.css$/ then reload_css(path)
        when /\.js$/ then reload_js(path)
        else reload_tab = true
        end
      end
      if reload_tab
        reload_current_tab(paths)
      end
    end

    private

    def reload_css(path)
      puts "Reload css via MozRepl for #{path}" if @options[:verbose]
      # TODO this is a hack
      path = path.gsub('public/', '')
      invoke "reload.css(#{path})"
    end

    def reload_js(path)
      puts "Reload js via MozRepl for #{path}" if @options[:verbose]
      # TODO this is a hack
      path = path.gsub('public/', '')
      invoke "reload.js(#{path})"
    end

    def reload_current_tab(paths)
      puts "Reload tab via MozRepl for #{paths * ' '}" if @options[:verbose]
      invoke 'content.location.reload();'
    end

    def invoke(cmd)
      mozrepl.cmd cmd
    rescue
      warn "Error sending command to MozRepl. Attempting to reconnect..." if @options[:verbose]
      @mozrepl = nil
      # retry
      mozrepl.cmd cmd
    end

    def mozrepl
      return @mozrepl if @mozrepl
      puts "Guard connecting to MozRepl at #{@options[:host]}:#{@options[:port]}"
      @mozrepl = Net::Telnet::new("Host" => @options[:host],
                                  "Port" => @options[:port])
      @mozrepl.cmd(reload_code)
    rescue
      warn "Not able to connect to MozRepl. Install/start MozRepl, or simply ignore this message."
      @serious_issue = true
    end

    def close!
      @mozrepl.close if @mozrepl
    end

    def reload_code
      File.read(File.expand_path(File.join(%w(.. reload.js)), __FILE__))
    end

  end
end


