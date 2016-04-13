require_relative './bench_init'

context "Updating the stream position" do
  stream_length = 3

  dispatcher_class = EventStore::Consumer::Controls::Dispatcher::SomeDispatcher
  stream_name = EventStore::Consumer::Controls::Writer.write count: stream_length

  consumer = EventStore::Consumer.build stream_name, dispatcher_class
  consumer.position_update_interval = stream_length - 1

  test "The position is updated periodically" do
    positions = {}

    consumer.start do |message, event_data|
      position = event_data.number

      positions[position] = EventStore::Consumer::Position::Read.(stream_name)

      break if position == (stream_length - 1)
    end

    assert positions[0] == 0
    assert positions[1] == 0
    assert positions[2] == 2
  end
end
