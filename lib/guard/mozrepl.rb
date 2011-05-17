require 'net/telnet'
require 'guard'
require 'guard/guard'

module Guard
  class Mozrepl < Guard

    def initialize(watchers=[], options={})
      super
      @options = options
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
      reload_current_tab!
    end

    private

    def reload_current_tab!
      mozrepl.cmd('content.location.reload();')
    end

    def mozrepl
      @mozrepl ||= Net::Telnet::new("Host" => @options[:host],
                                    "Port" => @options[:port])
    end

    def close!
      @mozrepl.close
    end

  end
end


