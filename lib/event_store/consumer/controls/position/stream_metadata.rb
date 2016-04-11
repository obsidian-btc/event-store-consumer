module EventStore
  class Consumer
    module Controls
      module Position
        def self.example
          11
        end

        module StreamMetadata
          def self.example(position=nil)
            position ||= Position.example

            { :consumer_position => position }
          end
        end
      end
    end
  end
end
