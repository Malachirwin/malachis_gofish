require 'json'

class Request
  def initialize(text)
    @data = text
  end

  def read
    @data
  end

  def to_json
    read.to_json
  end
end
