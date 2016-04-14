# EventStore Consumer

## Running up a consumer

```ruby
consumer = EventStore::Consumer.build :some_category, SomeDispatcher
consumer.start
```

## Process Host integration

```ruby
consumer = EventStore::Consumer.build :some_category, SomeDispatcher

cooperation = ProcessHost::Cooperation.build
cooperation.register consumer, "some-category-consumer"

cooperation.start!
```

