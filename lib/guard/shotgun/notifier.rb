module Guard
  class Shotgun
    class Notifier

      def self.guard_message(result)
        case result
        when 'up'
          "Sinatra up and running"
        when 'reloaded'
          "Sinatra reloaded"
        end
      end

      # failed | success
      def self.guard_image(result)
        icon = if result == 'ready'
          :success
        else
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