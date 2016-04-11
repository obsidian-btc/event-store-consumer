require_relative './bench_init'

context "Process host integration" do
  dispatcher_class = EventStore::Consumer::Controls::Dispatcher::SomeDispatcher
  stream_name = EventStore::Consumer::Controls::Writer.write

  consumer = EventStore::Consumer.build stream_name, dispatcher_class

  ProcessHost.integrate consumer

  context "Changing connection scheduler" do
    scheduler = EventStore::Consumer::Controls::ProcessHostIntegration::Scheduler.example

    consumer.change_connection_scheduler scheduler

    test "Scheduler of connection to event store is set" do
      assert consumer.session.connection.scheduler == scheduler
    end
  end

  context "Starting the consumer" do
    test "Starts the subscription" do
      dispatched = false

      consumer.start do
        dispatched = true
        break
      end

      assert dispatched
    end
  end
end
