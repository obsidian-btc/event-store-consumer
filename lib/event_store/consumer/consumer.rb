module EventStore
  class Consumer
    dependency :dispatcher, Messaging::Dispatcher
    dependency :logger, Telemetry::Logger
    dependency :session, Client::HTTP
    dependency :subscription, Messaging::Subscription

    def self.build(stream_name, dispatcher_class)
      instance = new

      session = EventStore::Client::HTTP::Session.configure instance

      dispatcher = dispatcher_class.configure instance

      Messaging::Subscription.configure(
        instance,
        stream_name,
        dispatcher,
        :attr_name => :subscription,
        :session => session
      )

      Telemetry::Logger.configure instance

      instance
    end

    module ProcessHostIntegration
      def change_connection_scheduler(scheduler)
        session.connection.scheduler = scheduler
      end

      def start(&supplementary_action)
        loop do
          logger.trace "Starting subscription (Stream Name: #{subscription.stream_name.inspect})"

          subscription.start &supplementary_action

          logger.debug "Subscription stopped (Stream Name: #{subscription.stream_name.inspect})"
        end
      end
    end
  end
end
