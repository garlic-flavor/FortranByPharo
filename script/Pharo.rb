
# Adapter classes for Pharo

require 'stringio'
require 'os'

#
class Transcript
  def << (msg)
    print msg
  end
  
  def cr()
    puts ''
  end
end

#
class Association
  @key = nil
  @value = nil

  def initialize(k, v)
    @key = k
    @value = v
  end

  def key()
    return @key
  end

  def value()
    return @value
  end

  def key(k)
    @key = k
  end

  def value(v)
    @value = v
  end
end

#
class SWString < String

  def self.cr()
    return "\r"
  end
  def self.lf()
    return "\n"
  end
  def self.crlf()
    return "\r\n"
  end

  def readStream()
    return SWStringIO.new(self)
  end

  def self.streamContents_(aBlock)
    s = StringIO.new
    aBlock.call(s)
    s.rewind
    return self.new(s.read)
  end

end

class SWStringIO < StringIO
  def contents()
    self.rewind
    return self.read
  end
end

#
class TestCase
  def setUp()
  end

  def tearDown()
  end

  def assert_equals_(left, right)
    if left != right
      raise "Assertion failed: #{left} != #{right}."
    end
  end

  def assert_(aBlock)
    if !(aBlock.call)
      raise "Assertion failed: #{aBlock.to_s} failed."
    end
  end
end

#
class OSPlatform
  def self.current
    return self
  end

end
