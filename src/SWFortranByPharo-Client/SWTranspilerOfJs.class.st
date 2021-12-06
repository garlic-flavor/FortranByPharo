Class {
	#name : #SWTranspilerOfJs,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> and_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: ' && ';
		preventNewline;
		put: '(function(){';
		putSequenceWithReturn: (arg2 at: 1) body;
		put: '})()'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> anySatisfy_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: '.find(';
		putBlock: (arg2 at: 1);
		put: ')'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> asStringFor: arg1 With: arg2 [

	self
		pushMessageNest;
		transpile: arg1;
		put: '.toString()';
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> asSymbolFor: arg1 With: arg2 [

	self
		transpile: arg1;
		put: '.toString()'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> at_For: arg1 With: arg2 [

	self
		transpile: arg1;
		put: '[';
		transpile: (arg2 at: 1);
		put: ']'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> at_ifAbsent_For: arg1 With: arg2 [

	self
		putLine: '(function(dict, key){ if(key in dict){';
		putLine: '    return dict[key];';
		putLine: '} else {';
		putSequenceWithReturn: (arg2 at: 2) body;
		put: '}})(';
		transpile: arg1;
		put: ', ';
		transpile: (arg2 at: 1);
		put: ')'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> at_put_For: arg1 With: arg2 [

	self logger log.
	self
		transpile: arg1;
		pushMessageNest;
		put: '[';
		transpile: (arg2 at: 1);
		put: '] = ';
		transpile: (arg2 at: 2);
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> beginsWith_For: arg1 With: arg2 [

	self logger log.
	self putMessage: arg1 send: 'startsWith' with: arg2
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> classFor: arg1 With: arg2 [

	self logger log.
	self
		transpile: arg1;
		put: '.constructor'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> collect_For: arg1 With: arg2 [

	self logger log.
	self
		flag: #ToImplement;
		putMessage: arg1 send: 'flatMap' with: arg2
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> copyFor: arg1 With: arg2 [

	self logger log.
	self
		transpile: arg1;
		put: '.clone'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> copyReplaceAll_with_For: arg1 With: arg2 [

	self logger log.
	self
		incMessageNest;
		pushMessageNest;
		transpile: arg1;
		put: '[';
		transpile: (arg2 at: 1);
		put: ']= ';
		transpile: (arg2 at: 2);
		popMessageNest;
		decMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> descriptionFor: arg1 With: arg2 [

	self logger log.
	self
		pushMessageNest;
		putMessage: arg1 send: 'message' with: arg2;
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> do_For: arg1 With: arg2 [

	self logger log.
	self
		flag: #ToImplement;
		pushMessageNest;
		transpile: arg1;
		put: '.forEach(';
		putBlock: (arg2 at: 1);
		put: ')';
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ensure_For: arg1 With: arg2 [

	self logger log.
	self pushMessageNest.
	arg1 body lastIsReturn
		ifTrue: [ 
			self
				putLine: 'try {';
				putSequence: arg1 body;
				putLine: '} finally {';
				putSequence: (arg2 at: 1) body;
				put: '}' ]
		ifFalse: [ 
			self
				putLine: '(function(){ try {';
				putSequenceWithReturn: arg1 body;
				putLine: '} finally {';
				putSequence: (arg2 at: 1) body;
				put: '}})()' ].
	self popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifFalse_For: arg1 With: arg2 [

	self logger log.
	self
		put: 'if (!';
		pushMessageNest;
		transpile: arg1;
		putLine: '){';
		putSequence: (arg2 at: 1) body;
		popMessageNest;
		put: '}'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifNil_For: arg1 With: arg2 [

	self logger log.
	self
		pushMessageNest;
		put: '(function(o){ if(o === undefined || o === null) { ';
		putSequenceWithReturn: (arg2 at: 1) body;
		put: ' } else {';
		put: 'return o; }})(';
		transpile: arg1;
		put: ')';
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifNotNil_For: arg1 With: arg2 [

	self logger log.
	self pushMessageNest.
	(arg2 at: 1) body lastIsReturn
		ifTrue: [ 
			self
				put:
					'if (!(function(o){ return o === undefined || o === null; })(';
				transpile: arg1;
				putLine: ')){';
				putSequence: (arg2 at: 1) body;
				put: '}' ]
		ifFalse: [ 
			self
				putLine: '(function(o) { if(!(o === undefined || o === null)) {';
				putSequenceWithReturn: (arg2 at: 1) body;
				put: '} else { return null; } })(';
				transpile: arg1;
				put: ')' ].
	self popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifNotNil_ifNil_For: arg1 With: arg2 [

	self logger log.
	self
		pushMessageNest;
		put: 'if not (';
		transpile: arg1;
		putLine: ').nil?';
		transpile: (arg2 at: 1) body;
		putLine: 'else';
		transpile: (arg2 at: 2) body;
		put: 'end';
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifTrue_For: arg1 With: arg2 [

	self logger log.
	self
		pushMessageNest;
		put: 'if(';
		transpile: arg1;
		putLine: '){';
		putSequence: (arg2 at: 1) body;
		put: '}'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifTrue_ifFalse_For: arg1 With: arg2 [

	self logger log.
	self pushMessageNest.
	(arg2 at: 1) body lastIsReturn
		ifTrue: [ 
			self
				put: 'if(';
				transpile: arg1;
				putLine: '){';
				putSequence: (arg2 at: 1) body;
				putLine: '} else {';
				putSequence: (arg2 at: 2) body;
				put: '}' ]
		ifFalse: [ 
			self
				put: '(function() { if(';
				transpile: arg1;
				putLine: '){';
				putSequenceWithReturn: (arg2 at: 1) body;
				putLine: '} else {';
				putSequenceWithReturn: (arg2 at: 2) body;
				put: '}})()' ].
	self popMessageNest
]

{ #category : #initialization }
SWTranspilerOfJs >> initialize [

	super initialize.
	self
		newline: String lf;
		type: #mjs
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> isArrayFor: arg1 With: arg2 [

	self
		pushMessageNest;
		put: 'Array.isArray(';
		transpile: arg1;
		put: ')';
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> join_For: arg1 With: arg2 [

	self logger log.
	self
		pushMessageNest;
		putMessage: (arg2 at: 1) send: 'join' with: { arg1 };
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> newFor: arg1 With: arg2 [

	self logger log.
	self
		put: 'new ';
		transpile: arg1;
		put: '()'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> on_do_For: arg1 With: arg2 [

	| tmp1 |
	self logger log.
	self pushMessageNest.
	tmp1 := arg1 body lastIsReturn or: [ (arg2 at: 2) body lastIsReturn ].
	tmp1
		ifTrue: [ 
			self
				putLine: 'try{';
				putSequence: arg1 body;
				put: '} catch (';
				put: (0 < (arg2 at: 2) arguments size
						 ifTrue: [ (arg2 at: 2) argumentNames at: 1 ]
						 ifFalse: [ 'e' ]);
				putLine: '){';
				putSequence: (arg2 at: 2) body;
				put: '}' ]
		ifFalse: [ 
			self
				putLine: '(function(){ try {';
				putSequenceWithReturn: arg1 body;
				put: '} catch (';
				put: (0 < (arg2 at: 2) arguments size
						 ifTrue: [ (arg2 at: 2) argumentNames at: 1 ]
						 ifFalse: [ 'e' ]);
				putLine: '){';
				putSequenceWithReturn: (arg2 at: 2) body;
				put: '}})()' ].
	self
		popMessageNest;
		pushMessageNest;
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> opArrow_For: arg1 With: arg2 [

	self logger log.
	self
		pushMessageNest;
		put: 'Association.new(';
		transpile: arg1;
		put: ', ';
		transpile: (arg2 at: 1);
		put: ')';
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> opCamma_For: arg1 With: arg2 [

	self logger log.
	self
		transpile: arg1;
		put: ' + ';
		transpile: (arg2 at: 1)
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> opNotEqual_For: arg1 With: arg2 [

	self logger log.
	self
		transpile: arg1;
		put: ' != ';
		transpile: (arg2 at: 1)
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> opWrite_For: arg1 With: arg2 [

	self
		pushMessageNest;
		transpile: arg1;
		put: '.write_';
		putArguments: arg2;
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> perform_For: arg1 With: arg2 [

	self logger log.
	self
		pushMessageNest;
		putMessage: arg1 send: 'send' with: arg2;
		popMessageNest
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putArguments: arg1 [

	self logger log.
	self put: '('.
	arg1
		do: [ :arg2 | arg2 transpileUsing: self ]
		separatedBy: [ self put: ', ' ].
	self put: ')'
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putBlock: arg1 [

	self logger log.
	self
		pushMessageNest;
		put: 'function ('.
	arg1 argumentNames
		do: [ :arg2 | self put: arg2 asString ]
		separatedBy: [ self put: ', ' ].
	self
		putLine: ') {';
		incIndent;
		decIndent;
		putSequenceWithReturn: arg1 body;
		put: '}';
		popMessageNest
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putClassDefinition: arg1 [

	self logger log.
	self
		putComment: arg1 comment;
		put: 'export class ';
		put: arg1 name.
	arg1 superclass = Object
		ifTrue: [ self put: ' extends PharoObject' ]
		ifFalse: [ 
			self
				put: ' extends ';
				put: arg1 superclass name ].
	self
		putLine: '{';
		incIndent;
		putLine: 'constructor(){';
		incIndent;
		putLine: 'super();'.
	arg1 instanceVariables do: [ :arg2 | 
		self
			put: 'this._';
			put: arg2 name;
			putLine: ' = null;' ].
	self
		decIndent;
		putLine: '}'.
	arg1 methods
		select: [ :arg3 | (arg3 protocol beginsWith: 'code generation') not ]
		thenDo: [ :arg4 | self putMethod: arg4 ofClass: arg1 ].
	self
		decIndent;
		putLine: '}'.
	arg1 classVariables do: [ :arg5 | 
		self
			put: arg1 name;
			put: '._';
			put: arg5 name;
			putLine: ' = null;' ].
	arg1 class methods
		select: [ :arg6 | (arg6 protocol beginsWith: 'code generation') not ]
		thenDo: [ :arg7 | self putClassMethod: arg7 ofClass: arg1 ]
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putClassMethod: arg1 ofClass: arg2 [

	| tmp1 |
	self logger log.
	tmp1 := self class safeSelectorNameOf: arg1 selector.
	self
		putComment: arg1 comment;
		put: arg2 name;
		put: '.';
		put: tmp1;
		put: ' = ';
		put: 'function(';
		put:
			(', ' join: (arg1 argumentNames collect: [ :arg3 | arg3 asString ]));
		putLine: ') {';
		pushMessageNest;
		incIndent;
		put: 'var self = ';
		put: arg2 name;
		putLine: ';';
		decIndent.
	tmp1 := self methodBodyGeneratorNameOf: arg1.
	(arg2 respondsTo: tmp1)
		ifTrue: [ 
			self incIndent.
			arg2 perform: tmp1 with: self.
			self
				decIndent;
				putLine ]
		ifFalse: [ self putSequence: arg1 sourceNode body ].
	self
		putLine: '};';
		popMessageNest
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putComment: arg1 [

	self logger log.
	arg1 ifNotNil: [ 
		arg1 linesDo: [ :arg2 | 
			self
				put: '// ';
				putLine: arg2 ] ]
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putFileHeaderOf: arg1 [

	
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putImportClass: arg1 [

	| tmp1 |
	self logger log.
	super putImportClass: arg1.
	tmp1 := self pool getAsSub: arg1 name.
	self
		put: 'import {';
		put: tmp1 moduleName;
		put: '} from ''../../';
		put: tmp1 filename;
		putLine: ''';'
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putImportNative: arg1 from: arg2 [

	self logger log.
	self put: 'import {'.
	arg1 isArray
		ifTrue: [ 
		arg1 do: [ :arg3 | self put: arg3 ] separatedBy: [ self put: ', ' ] ]
		ifFalse: [ self put: arg1 asString ].
	self
		put: '} from ''../../script/';
		put: arg2;
		putLine: ''';'
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putMethod: arg1 ofClass: arg2 [

	| tmp1 |
	self logger log.
	self
		putComment: arg1 comment;
		put: (self class safeSelectorNameOf: arg1 selector);
		put: '(';
		putParameters: arg1 argumentNames;
		putLine: ') {';
		pushMessageNest;
		incIndent;
		putLine: 'var self = this;';
		decIndent.
	tmp1 := self methodBodyGeneratorNameOf: arg1.
	(arg2 respondsTo: tmp1)
		ifTrue: [ 
			self incIndent.
			arg2 perform: tmp1 with: self.
			self
				decIndent;
				putLine ]
		ifFalse: [ self putSequence: arg1 sourceNode body ].
	self
		putLine: '}';
		popMessageNest
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putNil [

	self logger log.
	self put: 'null'
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putProgram: arg1 [

	self logger log.
	arg1 = SWTestBase ifTrue: [ ^ self ].
	self
		putLine;
		putLine: '(function(self){';
		pushMessageNest;
		putSequence:
			(arg1 class allMethods select: [ :arg2 | arg2 selector = #program ])
				first sourceNode body;
		put: '})(';
		put: arg1 name;
		putLine: ');';
		popMessageNest
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putSequence: arg1 [

	self logger log.
	self incIndent.
	arg1 children do: [ :arg2 | 
		arg2 class = RBVariableNode
			ifTrue: [ 
				self
					put: 'var ';
					put: arg2 name;
					putLine: ' = null;' ]
			ifFalse: [ 
				self
					transpile: arg2;
					putLine: ';' ] ].
	self decIndent
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putSequenceWithReturn: arg1 [

	| tmp2 |
	self logger log.
	self incIndent.
	tmp2 := 1.
	arg1 children size timesRepeat: [ 
		| tmp3 |
		tmp3 := arg1 children at: tmp2.
		tmp3 class = RBVariableNode
			ifTrue: [ 
				self
					put: 'var ';
					put: tmp3 name;
					putLine: ' = null;' ]
			ifFalse: [ 
				(tmp3 class ~= RBReturnNode and: [ tmp2 = arg1 children size ]) 
					ifTrue: [ self put: 'return ' ].
				self
					transpile: tmp3;
					putLine: ';' ].
		tmp2 := tmp2 + 1 ].
	self decIndent
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putSymbol: arg1 [

	self logger log: arg1 asString.
	self
		put: '''';
		put: (self class safeSelectorNameOf: arg1);
		put: ''''
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putTestRunner: arg1 [

	self logger log.
	self
		putLine;
		putLine: '(function(self){';
		pushMessageNest;
		incIndent;
		putLine: 'const runner = new self();'.
	(arg1 methods select: [ :arg2 | arg2 protocol beginsWith: 'test' ]) 
		do: [ :arg3 | 
			self
				putLine: 'runner.setUp();';
				put: 'runner.';
				put: arg3 selector asString;
				putLine: '();';
				putLine: 'runner.tearDown();' ].
	self
		decIndent;
		put: '})(';
		put: arg1 name;
		putLine: ');';
		popMessageNest
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putVariable: arg1 [

	self logger log: arg1 name.
	arg1 isInstanceVariable ifTrue: [ 
		self put: 'self._'.
		^ self put: arg1 name ].
	arg1 isClassVariable ifTrue: [ 
		self put: 'self._'.
		^ self put: arg1 name ].
	^ super putVariable: arg1
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> upToEndFor: arg1 With: arg2 [

	self putMessage: arg1 send: 'read' with: arg2
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> valueFor: arg1 With: arg2 [

	self logger log.
	self
		transpile: arg1;
		put: '()'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> value_For: arg1 With: arg2 [

	self logger log.
	self
		put: '(';
		transpile: arg1;
		put: ')';
		putArguments: arg2
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> yourselfFor: arg1 With: arg2 [

	self logger log.
	self transpile: arg1
]
