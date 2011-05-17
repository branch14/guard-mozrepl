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
      puts "Reload tab via MozRepl for #{paths * ' '}" if @options[:verbose]
      reload_current_tab!
    end

    private

    def reload_current_tab!
      mozrepl.cmd('content.location.reload();')
    rescue
      warn "Error sending command to MozRepl. Attempting to reconnect..." if @options[:verbose]
      @mozrepl = nil
      # retry
      mozrepl.cmd('content.location.reload();')
    end

    def mozrepl
      return @mozrepl if @mozrepl
      puts "Guard connecting to MozRepl at #{@options[:host]}:#{@options[:port]}"
      @mozrepl = Net::Telnet::new("Host" => @options[:host],
                                  "Port" => @options[:port])
    rescue
      warn "Not able to connect to MozRepl. Install/start MozRepl, or simply ignore this message."
      @serious_issue = true
    end

    def close!
      @mozrepl.close
    end

  end
end


