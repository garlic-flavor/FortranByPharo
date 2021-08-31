
# Adapter classes for Pharo

require 'stringio'
require 'os'
require 'pathname'

#------------------------------------------------------------------------------
#
class Transcript
  def self.<< (msg)
    print msg
  end
  
  def self.cr()
    puts ''
    STDOUT.flush
  end
end

#------------------------------------------------------------------------------
#
def output(msg)
  puts msg
  STDOUT.flush
end

#------------------------------------------------------------------------------
#
class Association
  attr_accessor :key, :value

  def initialize(k, v)
    @key, @value = k, v
  end
end

#------------------------------------------------------------------------------
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

  def trimLeft_(procedure)
    for i in 0...self.length do
      if not procedure.call(self[i]) then
        return self[i, self.length - i]
      end
    end
    return ''
  end

end

#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
#
class SWDictionary < Hash
end

#------------------------------------------------------------------------------
#
class FileTime < Time
  def prettyPrint()
    return self.to_s
  end
end

#------------------------------------------------------------------------------
#
class FileLocator < Pathname
  def self.imageDirectory()
    return FileLocator.new(Dir.getwd)
  end

  def isDirectory()
    return self.directory?
  end

  def exists()
    return self.exist?
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

  def accessTime()
    return FileTime.at(self.atime.to_i)
  end

  def changeTime()
    return FileTime.at(self.mtime.to_i)
  end

  def relativeTo_(relBase)
    return FileLocator.new(self.relative_path_from(relBase))
  end

  def contains_(path)
    base = self.to_s
    child = path.to_s
    return (base.size < child.size and base == child[0, base.size])
  end

  def parent()
    return FileLocator.new(super)
  end

  def ensureCreateDirectory()
    if (self.exist? and self.directory?) then
      return
    end
    self.mkdir
  end

  def /(path)
    return FileLocator.new(super)
  end

  def writeStreamDo_(procedure)
    io = SWFile.new(self.to_s)
    begin
      procedure.call(io)
    ensure
      io.close
    end
  end

end


#------------------------------------------------------------------------------
#
class SWFile < File
  def initialize(path)
    super(path, "a")
  end

  def truncate()
    super(self.pos)
  end

  def position_(p)
    self.pos = p
  end


end


# for Dummy
class SWGFortranCompilerAdapter
end
