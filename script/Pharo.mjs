
export class Transcript {};

Transcript.show_ = function(msg) {
  console.log(msg);
};

export class PharoObject {
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
}

export class TestCase extends PharoObject {
  setUp() {
  }
  tearDown() {
  }
  assert_equals_(left, right) {
    if (left != right)
      throw `Assertion failed: ${left} != ${right}.`;
  }

  error_(msg) {
    throw msg;
  }
}

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
