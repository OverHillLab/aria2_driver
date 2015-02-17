class Aria2Driver::JsonRpcClient
  attr_reader :scheme, :path, :port, :host

  DEFAULT_SCHEME = 'http'
  DEFAULT_PORT = 80
  DEFAULT_PATH = 'jsonrpc'

  def initialize(host, options={})
    @host = host
    check_defaults(options)
  end


  def self.from_url(url)
    uri = URI.parse(url)
    new uri.host, {scheme: uri.scheme, port: uri.port, path: uri.path}
  end

  private
  
  def check_defaults(options)
    @scheme = options.fetch(:scheme, DEFAULT_SCHEME)
    @port = options.fetch(:port, DEFAULT_PORT)
    @path = options.fetch(:path, DEFAULT_PATH)
  end

end