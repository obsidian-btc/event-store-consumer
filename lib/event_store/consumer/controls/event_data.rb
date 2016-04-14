module EventStore
  class Consumer
    module Controls
      module EventData
        module Read
          def self.example(number=nil)
            Client::HTTP::Controls::EventData::Read.example number
          end
        end
      end
    end
  end
end
