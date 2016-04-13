module EventStore
  class Consumer
    module Controls
      module EventData
        module Read
          def self.example(number=nil)
            json = Client::HTTP::Controls::EventData::Read::JSON.text number

            Client::HTTP::EventData::Read.parse json
          end
        end
      end
    end
  end
end
