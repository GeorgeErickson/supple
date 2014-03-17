$:.unshift 'lib'
require 'yaml'
require 'supple'
require 'pry'

analysis = File.open('settings.yml') {|f| YAML.load(f.read)}
settings = {
  settings: {
    analysis: analysis
  }
}
Supple.client.indices.delete index: 'test' rescue puts 'no exist'
Supple.client.indices.create index: 'test', body: settings

tokens = Supple.client.indices.analyze text: "Booker's True Barrel", index: 'test', analyzer: 'auto'
puts tokens["tokens"].map {|t| t["token"]}
