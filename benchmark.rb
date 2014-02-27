require 'rubygems'
require 'bundler/setup'
require 'benchmark'
require 'supple'

def measure(adapter)
  client = Elasticsearch::Client.new(adapter: adapter)
  Benchmark.realtime do
    100.times do
      client.nodes.stats(metric: 'http')['nodes'].values.each do |n|
        "#{n['name']} : #{n['http']['total_opened']}"
      end
    end
  end
end

puts measure(:patron)
puts measure(:net_http)

def measure2(adapter)
  Supple.es do |client|
    Benchmark.realtime do
      100.times do
        client.nodes.stats(metric: 'http')['nodes'].values.each do |n|
          "#{n['name']} : #{n['http']['total_opened']}"
        end
      end
    end
  end
end

puts measure2(:patron)
puts measure2(:net_http)
