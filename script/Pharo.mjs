
class Transcript {};

Transcript.write = function(msg) {
  console.log(msg);
};

class TestCase {
  setUp() {
  }
  tearDown() {
  }
  assert_equals_(left, right) {
    if (left != right)
      throw `Assertion failed: ${left} != ${right}.`;
  }
  assert_(aBlock) {
    if(!aBlock())
      throw `Assertion failed: ${aBlock} failed.`;
  }
}

export {Transcript, TestCase}
