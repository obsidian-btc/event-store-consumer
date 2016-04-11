module EventStore
  class Consumer
    module Position
      class Read
        dependency :logger, Telemetry::Logger
        dependency :stream_metadata, Client::HTTP::StreamMetadata

        def self.build(stream_name, session: nil)
          instance = new

          Client::HTTP::StreamMetadata.configure instance, stream_name, :session => session
          Telemetry::Logger.configure instance

          instance
        end

        def self.call(*arguments)
          instance = build *arguments
          instance.()
        end

        def self.configure(receiver, stream_name, attr_name: nil, session: nil)
          attr_name ||= :read_position

          instance = build stream_name, :session => session
          receiver.public_send "#{attr_name}=", instance
          instance
        end

        def call
          logger.trace "Retrieving stream position (Stream Name: #{stream_metadata.stream_name.inspect})"
          metadata = stream_metadata.get

          if metadata.nil?
            position = 0
          else
            position = metadata[:consumer_position].to_i
          end

          logger.debug "Retrieved stream position (Stream Name: #{stream_metadata.stream_name.inspect}, Position: #{position})"

          position
        end
      end
    end
  end
end
