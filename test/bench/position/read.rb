require_relative '../bench_init'

context "Reading the current stream position" do
  context "Consumer has previously written position state" do
    control_position = EventStore::Consumer::Controls::Position.example
    stream_name = EventStore::Consumer::Controls::Writer.write position: control_position

    position = EventStore::Consumer::Position::Read.(stream_name)

    test "The previously recorded position is returned" do
      assert position == control_position
    end
  end

  context "Consumer has not previously written any position state" do
    stream_name = EventStore::Consumer::Controls::Writer.write
    position = EventStore::Consumer::Position::Read.(stream_name)

    test "Position is 0 (start of stream)" do
      assert position == 0
    end
  end

  context "Stream does not exist" do
    stream_name = EventStore::Consumer::Controls::StreamName.get
    position = EventStore::Consumer::Position::Read.(stream_name)

    test "Position is 0 (start of stream)" do
      assert position == 0
    end
  end

  context "Configuration" do
    receiver = OpenStruct.new
    stream_name = EventStore::Consumer::Controls::StreamName.get

    context "Default attribute name" do
      EventStore::Consumer::Position::Read.configure receiver, stream_name

      test "The receiver has an instance of a position reader" do
        assert receiver.read_position.is_a?(EventStore::Consumer::Position::Read)
      end
    end

    context "Specific attribute name" do
      EventStore::Consumer::Position::Read.configure receiver, stream_name, attr_name: :some_attr

      test "The receiver has an instance of a position reader" do
        assert receiver.some_attr.is_a?(EventStore::Consumer::Position::Read)
      end
    end
  end
end
