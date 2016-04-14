module EventStore
  class Consumer
    module Controls
      module EventData
        module Read
          def self.example(number=nil, position: nil)
            Client::HTTP::Controls::EventData::Read.example number, position: position
          end
        end
      end
    end
  end
end
