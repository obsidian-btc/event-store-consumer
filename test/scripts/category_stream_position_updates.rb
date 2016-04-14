require_relative './scripts_init'

# Write three events to three different streams in the same category
category_id = Identifier::UUID::Random.get.gsub '-', ''
category = "categoryStreamPositionUpdatesTest#{category_id}"

3.times do |stream_id|
  stream_name = EventStore::Consumer::Controls::StreamName.get category, stream_id, random: false
  EventStore::Consumer::Controls::Writer.write stream_name
end

# Wait for projection to update
sleep 1

# Start a consumer, probing the recorded stream position after every message
category_stream = EventStore::Client::StreamName.category_stream_name category
__logger.focus category_stream
consumer = EventStore::Consumer.build category_stream, EventStore::Consumer::Controls::Dispatcher::SomeDispatcher

count = 0
consumer.start do |_, event_data|
  __logger.focus "Read event at position #{event_data.position}"

  count += 1

  break if count == 3
end
