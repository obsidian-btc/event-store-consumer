require_relative '../bench_init'

context "Periodically recording the stream position" do
  update_interval = 2

  stream_name = EventStore::Consumer::Controls::Writer.write

  record_position = EventStore::Consumer::Position::Record.build stream_name, update_interval

  context "The stream position is at the beginning" do
    event_data = EventStore::Consumer::Controls::EventData::Read.example position: 0

    wrote_position = record_position.(event_data)

    test "The position is updated" do
      assert wrote_position
    end
  end

  context "The stream position is divisible by the update interval" do
    position = update_interval * 2
    event_data = EventStore::Consumer::Controls::EventData::Read.example position: position

    wrote_position = record_position.(event_data)

    test "The position is updated" do
      assert wrote_position
    end
  end

  context "The stream position is not divisible by the update interval" do
    position = update_interval + 1
    event_data = EventStore::Consumer::Controls::EventData::Read.example position: position

    wrote_position = record_position.(event_data)

    test "The position is not updated" do
      refute wrote_position
    end
  end

end
