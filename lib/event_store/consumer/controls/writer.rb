module EventStore
  class Consumer
    module Controls
      module Writer
        def self.write(stream_name=nil, count: nil, position: nil)
          count ||= 1

          if position
            stream_metadata = Position::StreamMetadata.example position
          end

          Messaging::Controls::Writer.write(
            count,
            stream_name,
            stream_metadata: stream_metadata
          )
        end
      end
    end
  end
end
