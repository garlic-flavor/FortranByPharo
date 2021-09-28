export class STONWriter {
  constructor() {
    this.stream = null;
  }

  on_(stream) {
    this.stream = stream;
  }

  nextPut_(anObject) {
    anObject.stonOn_(this.stream);
  }
}

export class STONReader {
  constructor() {
    this.stream = null;
  }

  on_(stream) {
    this.stream = stream;
    return this;
  }

  contents() {
    return this.stream.read().toString();
  }
}

export class STONDict {
  stonOn_(stream) {
    stream.write(JSON.stringify(this));
  }
}
STONDict.fromSton_ = function(reader) {
  var ret = new STONDict();
  for(const [k, v] of Object.entries(JSON.parse(reader.contents()))){
    ret[k] = v;
  };
  return ret;
};

export class STON {
}
STON.jsonWriter = function() {
  return new STONWriter();
};

STON.reader = function() {
  return new STONReader();
};

STON.mapClass = function() {
  return STONDict;
};


import Stream from 'memory-streams';
if (process.env.NODE_ENV == 'test') {
  console.log('testcode');

  var str= `
    {
      "target":"script/SWTestBase/754bb877139a540199a0edd553d0f4aef5b81e2dff5e432873c0eb03326b9eb9.rb",
       "length":0,
       "options":{},
       "code":"head"
    }
  `;
  var stream = new Stream.ReadableStream(str);
  var reader = STON.reader();
  reader.on_(stream);
  var ston = STON.mapClass().fromSton_(reader);
  for(const [k, v] of Object.entries(ston)) {
    console.log(k, ' = ', v);
  }

  stream = new Stream.WritableStream();
  var writer = STON.jsonWriter();
  writer.on_(stream);
  writer.nextPut_(ston);
  console.log(stream.toString());

}

