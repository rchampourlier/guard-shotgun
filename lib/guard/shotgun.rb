require 'guard'
require 'guard/guard'
require 'spoon'
require 'socket'
require 'timeout'

module Guard
  class Shotgun < Guard

    attr_accessor :pid

    def initialize(watchers=[], options={})
      super
      @options = {
        :port       => 9393
      }.update(options)
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
    end

    # Call with Ctrl-C signal (when Guard quit)
    def stop
      UI.info "Shutting down Sinatra..."
      Process.kill("TERM", @pid)
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
      restart
    end

    # Call on file(s) modifications
    def run_on_change(paths = {})
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
      while true do
        sleep 0.2
        port_open?(@options[:host], @options[:port]) and return
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
