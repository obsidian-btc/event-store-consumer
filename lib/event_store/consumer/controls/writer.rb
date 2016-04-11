module EventStore
  class Consumer
    module Controls
      module Writer
        def self.write(position: nil)
          if position
            stream_metadata = Position::StreamMetadata.example position
          end

          Messaging::Controls::Writer.write :stream_metadata => stream_metadata
        end
      end
    end
  end
end
