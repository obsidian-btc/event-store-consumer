require_relative './bench_init'

context "Building a consumer" do
  dispatcher_class = EventStore::Consumer::Controls::Dispatcher::SomeDispatcher
  stream_name = EventStore::Consumer::Controls::StreamName.example

  consumer = EventStore::Consumer.build stream_name, dispatcher_class

  test "Configures a dispatcher" do
    assert consumer.dispatcher.is_a?(dispatcher_class)
  end

  test "Configures a subscription" do
    assert consumer.subscription.class == EventStore::Messaging::Subscription
  end
end
