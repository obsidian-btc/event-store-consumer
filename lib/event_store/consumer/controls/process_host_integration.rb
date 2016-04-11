module EventStore
  class Consumer
    module Controls
      module ProcessHostIntegration
        module Scheduler
          def self.example
            Connection::Scheduler::Substitute.build
          end
        end
      end
    end
  end
end
