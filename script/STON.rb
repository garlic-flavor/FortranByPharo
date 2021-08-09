require 'json'

class STONWriter
  @stream = nil
  def on_(stream)
    @stream = stream
  end
  def nextPut_(anObject)
    anObject.stonOn_(stream)
  end
end

class STONReader
  @stream = nil
  def on_(stream)
    @stream = stream
  end
  def contents()
    return @stream.read
  end
end

class STONDict
  @entity = nil
  def initialize(dict = nil)
    if dict.nil?
      @entity = {}
    else
      @entity = dict
    end
  end
  def [](key)
    return entity[key]
  end
  def []=(key, value)
    entity[key] = value
    return value
  end
  def stonOn_(stream)
    stream.write(JSON[entity])
  end
  def self.fromSton_(reader)
    ret = JSON[reader.contents]

  end
end

class STON
  def writer()
    return STONWriter.new
  end
  def reader()
    return STONReader.new
  end

  def mapClass()
    return STONDict
  end
end

if $DEBUG
  puts 'hello, debugger'
end
