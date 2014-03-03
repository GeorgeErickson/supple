module Connection
  def self.create
    ConnectionPool.new(timeout: config.pool.timeout, size: config.pool.size) do
      Elasticsearch::Client.new(adapter: :patron)
    end
  end
end

def self.es(&block)
  @es ||= Connection.create
  @es.with(&block)
end
