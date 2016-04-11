require_relative './bench_init'

context "Updating the stream position" do
  stream_length = 4

  dispatcher_class = EventStore::Consumer::Controls::Dispatcher::SomeDispatcher
  stream_name = EventStore::Consumer::Controls::Writer.write :count => stream_length

  consumer = EventStore::Consumer.build stream_name, dispatcher_class
  consumer.position_update_interval = 3

  test "The position is updated periodically" do
    control_recorded_positions = {
      0 => 0, # At position 0, the recorded position is 0
      1 => 0, # At position 1, the recorded position is still 0
      2 => 0, # At position 2, the recorded position is still 0
      3 => 3  # At position 3, the recorded position has been updated to 3
    }

    recorded_positions = {}

    consumer.start do |message, event_data|
      position = event_data.number

      recorded_positions[position] = EventStore::Consumer::Position::Read.(stream_name)

      break if position == (stream_length - 1)
    end

    assert recorded_positions == control_recorded_positions
  end
end
