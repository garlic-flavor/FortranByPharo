
//-----------------------------------------------------------------------------
export class PharoObject {

  error_(msg) {
    throw msg;
  }

  assert_(aBlock) {
    var value = false;
    if (typeof aBlock == 'function') {
      value = aBlock();
    } else {
      value = aBlock;
    }
    if(value === undefined || value === null || value === false)
        throw `Assertion failed: ${aBlock} failed.`;
  }

  static name() {
    return this.constructor.name;
  }

}
PharoObject.error_ = function(msg) {
  throw msg;
};

//-----------------------------------------------------------------------------
export class Transcript {};

Transcript.show_ = function(msg) {
  console.log(msg);
};
Transcript.write_ = function(msg) {
  process.stdout.write(msg);
};
Transcript.cr = function(msg) {
  process.stdout.write('\n');
};

//-----------------------------------------------------------------------------
export class OSPlatform {}
OSPlatform.current = function() {
  return OSPlatform;
};
OSPlatform.isMacOS = function() {
  return 'darwin' == process.platform;
};

//-----------------------------------------------------------------------------
export class TestAsserter extends PharoObject {
  setUp() {
  }
  tearDown() {
  }
  assert_equals_(left, right) {
    var lvalue = null;
    var rvalue = null;
    if (typeof left == 'function') {
      lvalue = left();
    } else {
      lvalue = left;
    }
    if (typeof right == 'function') {
      rvalue = right();
    } else {
      rvalue = right;
    }
    if (lvalue != rvalue)
      throw `Assertion failed: ${left} != ${right}.`;
  }

  static suiteClass() {
    return TestSuite;
  }
}

//-----------------------------------------------------------------------------
class TestResult {
  selectorName = null;
  result = null;
  message = null;

  run(proc) {
    var oldLog = console.log;
    var outer = this;
    this.message = "";
    console.log = function(message){
      outer.message = outer.message + message + "\r\n";
    };
    try {
      proc();
    } catch (e) {
      this.result = false;
      this.message = e.message;
      return;
    } finally {
      console.log = oldLog;
    }
    this.result = true;
  }
}

//-----------------------------------------------------------------------------
class TestResultSummary {
  className = null;
  eachTest = null;
  succeeded = 0;
  failed = 0;
  constructor() {
    this.eachTest = [];
  }
  push(result) {
    this.eachTest.push(result);
    if(result.result) {
      this.succeeded++;
    } else {
      this.failed++;
    }
  }
}


//-----------------------------------------------------------------------------
export class TestSuite {
  static named_(name) {
    return new TestSuite(name)
  }

  className = null;
  tests = null;

  constructor(name){
    this.tests = [];
    this.className = name;
  }

  addTest_(aTest) {
    this.tests.push(aTest);
    return this;
  }

  run() {
    var results = new TestResultSummary();
    this.tests.forEach(function(element) {
      var result = new TestResult();
      result.selectorName = element.testSelector;
      result.run(function() {
        element.setUp();
        element[element.testSelector]();
        element.tearDown();
      });
      results.push(result);
    });
    console.log(JSON.stringify(results));
  }
}


//-----------------------------------------------------------------------------
import stream from 'memory-streams';

String.cr = function() { return '\r'; };
String.lf = function() { return '\n'; };
String.crlf = function() { return '\r\n'; };
String.prototype.readStream = function() {
  return new stream.ReadableStream(this);
};
String.streamContents_ = function(aBlock) {
  var s = new stream.WritableStream();
  aBlock(s);
  return s.toString();
};
String.prototype.trimLeft_ = function(aBlock) {
  for(var i = 0; i < this.length; i++) {
    if (!aBlock(this.charAt(i))) {
      return this.substring(i);
    }
  }
  return this;
};
String.prototype.asString = function() {
  return this;
};

//-----------------------------------------------------------------------------
Error.prototype.getMessage = function() {
  return this.message;
};

Error.prototype._toString = Error.prototype.toString;
Error.prototype.toString = function() {
  return this.stack.toString();
};

//-----------------------------------------------------------------------------
import fs from 'fs';
import path from 'path';
export class FileLocator {
  constructor(path) {
    this._payload = path;
  }
  isDirectory() {
    return fs.statSync(this._payload).isDirectory();
  }
  exists() {
    return fs.existsSync(this._payload);
  }
  fullName() {
    return this._payload;
  }
  basename() {
    return path.basename(this._payload);
  }
  creationTime() {
    return fs.statSync(this._payload).ctime;
  }
  accessTime() {
    return fs.statSync(this._payload).atime;
  }
  changeTime() {
    return fs.statSync(this._payload).mtime.toLocaleString();
  }
  relativeTo_(relBase) {
    return new FileLocator(path.relative(this._payload, relBase.fullName()));
  }
  contains_(p) {
    var fullName = p;
    if (fullName.constructor.name === 'FileLocator'){
      fullName = fullName.fullName();
    }
    var abs = path.resolve(this._payload, fullName);
    return abs.startsWith(this._payload);
  }
  parent() {
    return new FileLocator(path.dirname(this._payload));
  }
  ensureCreateDirectory() {
    var dir = this.isDirectory ?
      dir = this._payload : path.dirname(this._payload);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, {recursive: true});
    }
  }
  joinPath_(p) {
    return new FileLocator(path.resolve(this._payload, p));
  }
  writeStreamDo_(aBlock) {
    var io = new SWFile(this._payload);
    try {
      aBlock(io);
    } finally {
      io.destroy();
    }
  }

  children() {
    var self = this;
    return fs.readdirSync(this._payload).flatMap(function(name) {
      return self.join(name);
    });
  }
}

FileLocator.imageDirectory = function() {
  return new FileLocator(process.cwd());
}

//-----------------------------------------------------------------------------
Date.prototype.prettyPrint = function() {
  return this.toLocaleString();
};

//-----------------------------------------------------------------------------
export class SWFile {
  constructor(path) {
    this._path = path;
  }

  truncate() {
  }

  position_(p) {
  }

  write_(contents) {
    fs.writeFileSync(this._path, contents);
  }

  destroy() {
  }
}

//-----------------------------------------------------------------------------
export class Dictionary {}

// for Dummy
export class SWGFortranCompilerAdapter {}


//-----------------------------------------------------------------------------
if (process.env.NODE_ENV == 'test') {

  var fl = FileLocator.imageDirectory();
  console.log(fl.fullName());
  console.log(fl.isDirectory());
  console.log(fl.exists());
  console.log(fl.basename());
  console.log(fl.creationTime());
  console.log(fl.accessTime());
  console.log(fl.changeTime());
  console.log(fl.relativeTo_(new FileLocator('/bin')).fullName());
  var fl2 = fl.join('hoge/fuga.txt');
  console.log(fl2.fullName());
  console.log(fl.contains_(fl2));
  fl2.ensureCreateDirectory();
  fl2.writeStreamDo_(function(io) {
    console.log(io._path);
    io.write_('Hello, World\n');
  });
  console.log(fl.children());
}
