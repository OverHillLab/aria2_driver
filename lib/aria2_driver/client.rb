module Aria2Driver
  class Client
    private_class_method :new

    def self.from_url(url)
      new
    end
  end
end