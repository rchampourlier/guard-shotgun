module Guard
  class Shotgun
    class Notifier

      def self.guard_message(result)
        case result
        when 'up'
          "Sinatra up and running"
        when 'reloaded'
          "Sinatra reloaded"
        when 'failed'
          'Sinatra failed to start'
        end
      end

      # failed | success
      def self.guard_image(result)
        case result
        when 'reloaded', 'up'
          :success
        when 'failed'
          :failed
        end
      end

      def self.notify(result)
        message = guard_message(result)
        image   = guard_image(result)

        ::Guard::Notifier.notify(message, :title => 'guard-shotgun', :image => image)
      end
    end
  end
end
