module EventStore
  class Consumer
    class Build
      attr_reader :dispatcher_class
      attr_reader :receiver
      attr_reader :stream_name

      dependency :logger, Telemetry::Logger

      def initialize(receiver, stream_name, dispatcher_class)
        @receiver = receiver
        @stream_name = stream_name
        @dispatcher_class = dispatcher_class
      end

      def self.build(stream_name, dispatcher_class)
        receiver = Consumer.new

        instance = new receiver, stream_name, dispatcher_class

        Telemetry::Logger.configure instance

        instance
      end

      def self.call(stream_name, dispatcher_class)
        instance = build stream_name, dispatcher_class
        instance.()
      end

      def call
        logger.trace "Building consumer (Stream Name: #{stream_name.inspect}, Dispatcher Type: #{dispatcher_class.name})"

        dispatcher = dispatcher_class.configure receiver

        Telemetry::Logger.configure receiver

        session = EventStore::Client::HTTP::Session.configure receiver

        Settings.set receiver

        configure_subscription dispatcher, session

        Position::Write.configure receiver, stream_name, session: session

        logger.trace "Built consumer (Stream Name: #{stream_name.inspect}, Dispatcher Type: #{dispatcher_class.name})"

        receiver
      end

      def configure_subscription(dispatcher, session)
        position = Position::Read.(stream_name, session: session)

        Messaging::Subscription.configure(
          receiver,
          stream_name,
          dispatcher,
          attr_name: :subscription,
          session: session,
          starting_position: position
        )
      end
    end
  end
end
