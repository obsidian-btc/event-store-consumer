module EventStore
  class Consumer
    module Position
      class Write
        dependency :logger, Telemetry::Logger
        dependency :stream_metadata, Client::HTTP::StreamMetadata

        def self.build(stream_name, session: nil)
          instance = new

          Client::HTTP::StreamMetadata.configure instance, stream_name, :session => session
          Telemetry::Logger.configure instance

          instance
        end

        def self.call(stream_name, position, session: nil)
          instance = build stream_name, session: session
          instance.(position)
        end

        def self.configure(receiver, stream_name, attr_name: nil, session: nil)
          attr_name ||= :write_position

          instance = build stream_name, :session => session
          receiver.public_send "#{attr_name}=", instance
          instance
        end

        def call(position)
          logger.trace "Updating stream position (Stream Name: #{stream_metadata.stream_name.inspect}, Position: #{position})"

          stream_metadata.update do |metadata|
            metadata[:consumer_position] = position
          end

          logger.debug "Updated stream position (Stream Name: #{stream_metadata.stream_name.inspect}, Position: #{position})"

          position
        end
      end
    end
  end
end
