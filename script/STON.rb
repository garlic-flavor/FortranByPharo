require 'json'

class STONWriter
  @stream = nil
  def on_(stream)
    @stream = stream
  end
  def nextPut_(anObject)
    anObject.stonOn_(@stream)
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

class STONDict < Hash
  def [](key)
    return super(key.to_s)
  end
  def []=(key, value)
    super(key.to_s, value)
    return value
  end
  def stonOn_(stream)
    stream.write(JSON[self])
  end
  def self.fromSton_(reader)
    ret = self.new
    (JSON[reader.contents]).each { |k, v|
      ret[k] = v
    }
    return ret
  end

end

class STON
  def self.writer()
    return STONWriter.new
  end
  def self.reader()
    return STONReader.new
  end

  def self.mapClass()
    return STONDict
  end
end

if $DEBUG
  require 'stringio'

  str=<<JSON
{ "hello": "world", "goodbye": "heaven", "c": 3 }
JSON

  reader = STON.reader
  reader.on_(StringIO.new(str))
  ston = STON.mapClass.fromSton_(reader)
  puts ston

  stream = StringIO.new("")
  writer = STON.writer
  writer.on_(stream)
  writer.nextPut_(ston)
  stream.rewind
  puts stream.read

end
