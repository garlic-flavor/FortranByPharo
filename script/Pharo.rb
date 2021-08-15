
# Adapter classes for Pharo

require 'stringio'
require 'os'
require 'pathname'

#
class Transcript
  def self.<< (msg)
    print msg
  end
  
  def self.cr()
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

#
class SWStringIO < StringIO
  def contents()
    self.rewind
    return self.read
  end
  def upToEnd()
    return self.read
  end
end

#
class SWStringIOWrapper
  def initialize(entity)
    @entity = entity
  end
  def contents()
    @entity.rewind
    return @entity.read
  end
  def upToEnd()
    return @entity.read
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

  def self.isMacOS
    return OS.mac?
  end

end

#
class SWDictionary < Hash
end

#
class FileTime < Time
  def prettyPrint()
    return self.to_s
  end
end

#
class FileLocator < Pathname
  def self.imageDirectory()
    return FileLocator.new(Dir.getwd)
  end

  def isDirectory()
    return self.directory?
  end

  def fullName()
    return self.to_s
  end

  def basename()
    return super.to_s
  end
  
  def creationTime()
    return FileTime.at(self.ctime.to_i)
  end

  def relativeTo_(relBase)
    return FileLocator.new(self.relative_path_from(relBase))
  end
end


# for Dummy
class SWGFortranCompilerAdapter
end
