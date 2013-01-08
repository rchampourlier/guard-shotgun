require 'guard'
require 'guard/guard'
require 'spoon'
require 'socket'
require 'timeout'

module Guard
  class Shotgun < Guard
    autoload :Notifier, File.expand_path('../shotgun/notifier', __FILE__)
    attr_accessor :pid

    STARTUP_TIMEOUT = 10 # seconds

    def initialize(watchers=[], options={})
      super
      @options = {
        :host => 'localhost',
        :port => 9292
      }.update(options)
      @reloaded = false
    end

    # =================
    # = Guard methods =
    # =================

    # Call once when guard starts
    def start
      UI.info "Starting up Sinatra..."
      if running?
        UI.error "Another instance of Sinatra is running."
        false
      else
        @pid = Spoon.spawnp('rackup')
        @pid
      end
      wait_for_port
      if running?
        Notifier.notify(@reloaded ? 'reloaded' : 'up')
        @reloaded = false
      else
        UI.info "Sinatra failed to start."
        Notifier.notify('failed')
      end
    end

    # Call with Ctrl-C signal (when Guard quit)
    def stop
      UI.info "Shutting down Sinatra..."
      Process.kill("INT", @pid)
      Process.wait(@pid)
      @pid = nil
      true
    end

    def stop_without_waiting
      UI.info "Shutting down Sinatra without waiting..."
      Process.kill("KILL", @pid)
      Process.wait(@pid)
      @pid = nil
      true
    end
    
    # Call with Ctrl-Z signal
    def reload
      @reloaded = true
      restart
    end

    # Call on file(s) modifications
    def run_on_change(paths = {})
      @reloaded = true
      restart_without_waiting
    end

    private

    def restart_without_waiting
      UI.info "Restarting Sinatra without waiting..."
      stop_without_waiting
      start
    end

    def restart
      UI.info "Restarting Sinatra..."
      stop
      start
    end

    def running?
      begin
        if @pid
          Process.getpgid @pid
          true
        else
          false
        end
      rescue Errno::ESRCH
        false
      end
    end

    def wait_for_port
      timeout_time = Time.now + STARTUP_TIMEOUT
      while Time.now < timeout_time do
        sleep 0.2
        break if port_open?(@options[:host], @options[:port])
      end
    end

    # thanks to: http://bit.ly/bVN5AQ
    def port_open?(addr, port)
      begin
        Timeout::timeout(1) do
          begin
            s = TCPSocket.new(addr, port)
            s.close
            return true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            return false
          end
        end
      rescue Timeout::Error
      end

      return false
    end
  end
end
