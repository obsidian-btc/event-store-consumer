module EventStore
  class Consumer
    module Position
      class Record
        attr_writer :update_interval

        dependency :logger, Telemetry::Logger
        dependency :write, Write

        def update_interval
          @update_interval ||= Defaults::UpdateInterval.get
        end

        def initialize(update_interval=nil)
          @update_interval = update_interval
        end

        def self.build(stream_name, update_interval=nil, session: nil)
          instance = new update_interval
          Telemetry::Logger.configure instance
          Write.configure instance, stream_name, session: session, attr_name: :write
          instance
        end

        def self.configure(receiver, stream_name, update_interval=nil, session: nil, attr_name: nil)
          attr_name ||= :record_position

          instance = build stream_name, update_interval, session: session
          receiver.public_send "#{attr_name}=", instance
          instance
        end

        def call(event_data)
          position = event_data.position

          logger.trace "Recording position (Position: #{position}, Stream: #{write.stream_name.inspect})"

          if update_position? position
            write.(position)
            wrote_position = true
          end

          logger.debug "Recorded position (Position: #{position}, Stream: #{write.stream_name.inspect})"

          wrote_position
        end

        def update_position?(position)
          cycle = position % update_interval
          cycle.zero?
        end

        module Defaults
          module UpdateInterval
            def self.get
              100
            end
          end
        end
      end
    end
  end
end
