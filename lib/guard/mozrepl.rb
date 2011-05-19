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
      reload_current_tab(paths) if reload_tab
    end

    private

    def reload_css(path)
      log "Reload css via MozRepl for #{path}"
      invoke "reload.css(#{path});"
    end

    def reload_js(path)
      log "Reload js via MozRepl for #{path}"
      invoke "reload.js(#{path});"
    end

    def reload_current_tab(paths)
      log "Reload tab via MozRepl for #{paths * ' '}"
      invoke 'content.location.reload();'
    end

    def invoke(cmd)
      log mozrepl.cmd cmd
    rescue
      log "Error sending command to MozRepl. Attempting to reconnect..."
      @mozrepl = nil
      # retry
      log mozrepl.cmd cmd
    end

    def mozrepl
      return @mozrepl if @mozrepl
      puts "Guard connecting to MozRepl at #{@options[:host]}:#{@options[:port]}"
      @mozrepl = Net::Telnet::new("Host" => @options[:host],
                                  "Port" => @options[:port])
      log @mozrepl.cmd(reload_code)
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

    def log(msg)
      puts msg if @options[:verbose]
    end

  end
end


