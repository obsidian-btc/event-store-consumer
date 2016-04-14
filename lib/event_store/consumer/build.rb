module EventStore
  class Consumer
    class Build
      include EventStore::Messaging::StreamName

      attr_reader :dispatcher_class
      attr_reader :receiver
      attr_reader :category_name

      dependency :logger, Telemetry::Logger

      def initialize(receiver, category_name, dispatcher_class)
        @receiver = receiver
        @category_name = category_name
        @dispatcher_class = dispatcher_class
      end

      def self.build(category_name, dispatcher_class)
        receiver = Consumer.new category_name

        instance = new receiver, category_name, dispatcher_class

        Telemetry::Logger.configure instance

        instance
      end

      def self.call(category_name, dispatcher_class)
        instance = build category_name, dispatcher_class
        instance.()
      end

      def call
        logger.trace "Building consumer (Category Name: #{category_name.inspect}, Dispatcher Type: #{dispatcher_class.name})"

        dispatcher = dispatcher_class.configure receiver

        Telemetry::Logger.configure receiver

        session = EventStore::Client::HTTP::Session.configure receiver

        configure_subscription dispatcher, session

        update_interval = Settings.get :position_update_interval
        Position::Record.configure receiver, category_name, update_interval, session: session

        logger.trace "Built consumer (Category Name: #{category_name.inspect}, Dispatcher Type: #{dispatcher_class.name})"

        receiver
      end

      def configure_subscription(dispatcher, session)
        # FIXME - This should not be necessary
        formatted_category_name = Casing::Camel.(category_name, symbol_to_string: true)
        # /FIXME

        stream_name = self.category_stream_name formatted_category_name

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
