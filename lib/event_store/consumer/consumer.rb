module EventStore
  class Consumer
    dependency :dispatcher, Messaging::Dispatcher
    dependency :logger, Telemetry::Logger
    dependency :write_position, Position::Write
    dependency :session, Client::HTTP
    dependency :subscription, Messaging::Subscription

    setting :position_update_interval

    def self.build(stream_name, dispatcher_class)
      Build.(stream_name, dispatcher_class)
    end

    def start(&supplementary_action)
      observe_dispatcher
      start_subscription(&supplementary_action)
    end

    def observe_dispatcher
      dispatcher.dispatched do |_, event_data|
        position = event_data.number

        write_position.(position) if update_position? position
      end
    end

    def start_subscription(&supplementary_action)
      loop do
        logger.trace "Starting subscription (Stream Name: #{subscription.stream_name.inspect})"

        subscription.start &supplementary_action

        logger.debug "Subscription stopped (Stream Name: #{subscription.stream_name.inspect})"
      end
    end

    def update_position?(position)
      return false if position_update_interval.nil?

      cycle = position % position_update_interval
      cycle.zero?
    end

    module ProcessHostIntegration
      def change_connection_scheduler(scheduler)
        session.connection.scheduler = scheduler
      end
    end
  end
end
