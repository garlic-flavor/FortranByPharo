"
I am a Pharo to ECMAScript (with node.js) transpiler.
"
Class {
	#name : #SWTranspilerOfJs,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> and_For: receiver With: arguments [
	self
		transpile: receiver;
		put: ' && ';
		preventNewline;
		put: '(function(){';
		putSequenceWithReturn: (arguments at: 1) body;
		put: '})()'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> anySatisfy_For: receiver With: arguments [
	self
		transpile: receiver;
		put: '.find(';
		putBlock: (arguments at: 1);
		put: ')'.

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> asStringFor: receiver With: arguments [
	self
		pushMessageNest;
		transpile: receiver;
		put: '.toString()';
		popMessageNest
		
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> asSymbolFor: receiver With: arguments [
	self
		transpile: receiver;
		put: '.toString()'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> at_For: receiver With: arguments [
	self
		transpile: receiver;
		put: '[';
		transpile: (arguments at: 1);
		put: ']'

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> at_ifAbsent_For: receiver With: arguments [
	self
		putLine: '(function(dict, key){ if(key in dict){';
		putLine: '    return dict[key];';
		putLine: '} else {';
		putSequenceWithReturn: (arguments at: 2) body;
		put: '}})(';
		transpile: receiver;
		put: ', ';
		transpile: (arguments at: 1);
		put: ')'.

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> at_put_For: receiver With: arguments [
	self logger log.
	self
		transpile: receiver;
		pushMessageNest;
		put: '[';
		transpile: (arguments at: 1);
		put: '] = ';
		transpile: (arguments at: 2);
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> beginsWith_For: receiver With: arguments [
	self logger log.
	self putMessage: receiver call: 'startsWith' with: arguments
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> classFor: receiver With: arguments [
	self logger log.
	self
		transpile: receiver;
		put: '.constructor'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> collect_For: receiver With: arguments [
	self logger log.
	self flag: #ToImplement.
	self putMessage: receiver call: 'flatMap' with: arguments.

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> copyFor:receiver With: arguments [
	self logger log.
	self
		transpile: receiver;
		put: '.clone'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> copyReplaceAll_with_For: receiver With: arguments [
	self logger log.
	self
		incMessageNest;
		pushMessageNest;
		transpile: receiver;
		put: '[';
		transpile: (arguments at: 1);
		put: ']= ';
		transpile: (arguments at: 2);
		popMessageNest;
		decMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> descriptionFor: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;	
		putMessage: receiver call: 'message' with: arguments;
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> do_For: receiver With: arguments [
	self logger log.
	self flag: #ToImplement.
	self
		pushMessageNest;
		transpile: receiver;
		put: '.forEach(';
		putBlock: (arguments at: 1);
		put: ')';
		popMessageNest.

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ensure_For: receiver With: arguments [
	self logger log.
	self pushMessageNest.
	(receiver body lastIsReturn) ifTrue: [
		self
			putLine: 'try {';
			putSequence: receiver body;
			putLine: '} finally {';
			putSequence: (arguments at: 1) body;
			put: '}'
	] ifFalse: [
		self
			putLine: '(function(){ try {';
			putSequenceWithReturn: receiver body;
			putLine: '} finally {';
			putSequence: (arguments at: 1) body;
			put: '}})()'
	].
	self popMessageNest.

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifFalse_For: receiver With: arguments [
	self logger log.
	self
		put: 'if (!';
		pushMessageNest;
		transpile: receiver;
		putLine: '){';
		putSequence: (arguments at: 1) body;
		popMessageNest;
		put: '}'

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifNil_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		put: '(function(o){ if(o === undefined || o === null) { ';
		putSequenceWithReturn: (arguments at: 1) body;
		put: ' } else {';
		put: 'return o; }})(';
		transpile: receiver;
		put: ')';
		popMessageNest
		
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifNotNil_For: receiver With: arguments [
	self logger log.
	self pushMessageNest.
	(arguments at: 1) body lastIsReturn ifTrue: [ 
		self
			put: 'if (!(function(o){ return o === undefined || o === null; })(';
			transpile: receiver;
			putLine: ')){';
			putSequence: (arguments at: 1) body;
			put: '}'
	] ifFalse: [
		self
			putLine: '(function(o) { if(!(o === undefined || o === null)) {';
			putSequenceWithReturn: (arguments at: 1) body;
			put: '} else { return null; } })(';
			transpile: receiver;
			put: ')'
	].
	self popMessageNest

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifNotNil_ifNil_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		put: 'if not (';
		transpile: receiver;
		putLine: ').nil?';
		transpile: (arguments at: 1) body;
		putLine: 'else';
		transpile: (arguments at: 2) body;
		put: 'end';
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifTrue_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		put: 'if(';
		transpile: receiver;
		putLine: '){';
		putSequence: (arguments at: 1) body;
		put: '}'.

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> ifTrue_ifFalse_For: receiver With: arguments [
	self logger log.
	self pushMessageNest.
	(arguments at: 1) body lastIsReturn ifTrue: [
		self
			put: 'if(';
			transpile: receiver;
			putLine: '){';
			putSequence: (arguments at: 1) body;
			putLine: '} else {';
			putSequence: (arguments at: 2) body;
			put: '}'
	] ifFalse: [
		self
			put: '(function() { if(';
			transpile: receiver;
			putLine: '){';
			putSequenceWithReturn: (arguments at: 1) body;
			putLine: '} else {';
			putSequenceWithReturn: (arguments at: 2) body;
			put: '}})()'
	].
	self popMessageNest.

]

{ #category : #initialization }
SWTranspilerOfJs >> initialize [
	super initialize.
	self newline: String lf.
	self type: #mjs.

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> isArrayFor: receiver With: arguments [
	self
		pushMessageNest;
		put: 'Array.isArray(';
		transpile: receiver;
		put: ')';
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> join_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		putMessage: (arguments at: 1) call: 'join' with: { receiver };
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> newFor: receiver With: arguments [
	self logger log.
	self
		put: 'new ';
		transpile: receiver;
		put: '()'

]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> on_do_For: receiver With: arguments [
	|hasReturn|
	self logger log.
	self pushMessageNest.
	hasReturn := receiver body lastIsReturn or: [ (arguments at: 2) body lastIsReturn ].
	hasReturn ifTrue: [
		self
			putLine: 'try{';
			putSequence: receiver body;
			put: '} catch (';
			put: ((0 < (arguments at: 2) arguments size) ifTrue: [ (arguments at: 2) argumentNames at: 1 ] ifFalse: ['e']);
			putLine: '){';
			putSequence: (arguments at: 2) body;
			put: '}'
	] ifFalse: [
		self
			putLine: '(function(){ try {';
			putSequenceWithReturn: receiver body;
			put: '} catch (';
			put: ((0 < (arguments at: 2) arguments size) ifTrue: [ (arguments at: 2) argumentNames at: 1 ] ifFalse: ['e']);
			putLine: '){';
			putSequenceWithReturn: (arguments at: 2) body;
			put: '}})()'
	].
	self popMessageNest.

	self
		pushMessageNest;
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> opArrow_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		put: 'Association.new(';
		transpile: receiver;
		put: ', ';
		transpile: (arguments at: 1);
		put: ')';
		popMessageNest.
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> opCamma_For: receiver With: arguments [
	self logger log.
	self
		transpile: receiver;
		put: ' + ';
		transpile: (arguments at: 1)
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> opNotEqual_For: receiver With: arguments [
	self logger log.
	self
		transpile: receiver;
		put: ' != ';
		transpile: (arguments at: 1)
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> opWrite_For: receiver With: arguments [
	self
		pushMessageNest;
		transpile: receiver;
		put: '.write_';
		putArguments: arguments;
		popMessageNest
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> perform_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		putMessage: receiver call: 'send' with: arguments;
		popMessageNest.
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putArguments: arguments [
	self logger log.
	self put: '('.
	arguments do: [ :each |
		each transpileUsing: self.
	] separatedBy: [
		self put: ', '
	].
	self put: ')'

]

{ #category : #'code generation' }
SWTranspilerOfJs >> putBlock: aBlock [
	self logger log.
	self
		pushMessageNest;
		put: 'function ('.
	aBlock argumentNames do: [ :each |
		self put: each asString
	] separatedBy: [ self put: ', ' ].
	self
		putLine: ') {';
		incIndent.
	self
		decIndent;
		putSequenceWithReturn: aBlock body;
		put: '}';
		popMessageNest.

]

{ #category : #'code generation' }
SWTranspilerOfJs >> putClassDefinition: aClass [
	self logger log.
	self putComment: aClass comment.
	self put: 'export class '.
	self put: aClass name.
	(aClass superclass = Object) ifTrue: [
		self put: ' extends PharoObject'
	] ifFalse: [
		self put: ' extends '; put: aClass superclass name
	].
	self putLine: '{'.
	self incIndent.

	self
		putLine: 'constructor(){';
		incIndent;
		putLine: 'super();'.
	aClass instanceVariables do: [ :aVal |
		self put: 'this._'; put: aVal name; putLine: ' = null;'
	].
	self
		decIndent;
		putLine: '}'.

	aClass methods select: [ :aMethod | (aMethod protocol beginsWith: 'code generation') not ] thenDo: [ :aMethod |
		self putMethod: aMethod ofClass: aClass
	].

	self decIndent.
	self putLine: '}'.
	
	aClass classVariables do: [ :aVal |
		self put: aClass name; put: '._'; put: aVal name; putLine: ' = null;'
	].

	aClass class methods select: [:aMethod | (aMethod protocol beginsWith: 'code generation') not ] thenDo: [ :aMethod |
		self putClassMethod: aMethod ofClass: aClass.
	].

]

{ #category : #'code generation' }
SWTranspilerOfJs >> putClassMethod: aMethod ofClass: aClass [
	|sel|
	self logger log.
	sel := self class safeSelectorNameOf: aMethod selector.
	self
		putComment: aMethod comment;
		put: aClass name; put: '.'; put: sel; put: ' = ';
		put: 'function(';
		put: (', ' join: (aMethod argumentNames collect: [ :each | each asString ]));
		putLine: ') {';
		pushMessageNest;
		incIndent;
		put: 'var self = ';
		put: aClass name;
		putLine: ';';
		decIndent.
	sel := self methodBodyGeneratorNameOf: aMethod.
	(aClass respondsTo: sel) ifTrue: [
		self incIndent.
		aClass perform: sel with: self.
		self decIndent.
		self putLine.
	] ifFalse: [
		self putSequence: aMethod sourceNode body.
	].
	self
		putLine: '};';
		popMessageNest.
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putComment: comment [
	self logger log.
	comment ifNotNil: [
		comment linesDo: [ :aLine |
			self
				put: '// ';
				putLine: aLine
		]
	]
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putFileHeaderOf: filename [


]

{ #category : #'code generation' }
SWTranspilerOfJs >> putImportClass: aClass [
	|s|
	self logger log.
	super putImportClass: aClass.
	s := self pool getAsSub: aClass name.
	self
		put: 'import {';
		put: s moduleName;
		put: '} from ''../../';
		put: s filename;
		putLine: ''';'.


]

{ #category : #'code generation' }
SWTranspilerOfJs >> putImportNative: classes from: fileName [
	self logger log.
	self put: 'import {'.
	classes isArray ifTrue: [
		classes do: [ :each |
			self put: each
		] separatedBy: [ self put: ', ' ]
	] ifFalse: [
		self put: classes asString
	].
	self
		put: '} from ''../../script/';
		put: fileName;
		putLine: ''';'.

]

{ #category : #'code generation' }
SWTranspilerOfJs >> putMethod: aMethod ofClass: aClass [
	|sel|
	self logger log.
	self
		putComment: aMethod comment;
		put: (self class safeSelectorNameOf: aMethod selector);
		put: '(';
		putParameters: aMethod argumentNames;
		putLine: ') {';
		pushMessageNest;
		incIndent;
		putLine: 'var self = this;';
		decIndent.
	sel := self methodBodyGeneratorNameOf: aMethod.
	(aClass respondsTo: sel) ifTrue: [
		self incIndent.
		aClass perform: sel with: self.
		self decIndent.
		self putLine.
	] ifFalse: [
		self putSequence: aMethod sourceNode body.
	].
	self
		putLine: '}';
		popMessageNest.
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putNil [
	self logger log.
	self put: 'null'
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putProgram: aClass [
	self logger log.
	aClass = SWTestBase ifTrue: [ ^ self ].
	self
		putLine;
		putLine: '(function(self){';
		pushMessageNest;
		putSequence: ((aClass class allMethods select: [ :each | each selector = #program  ]) first) sourceNode body;
		put: '})(';
		put: aClass name;
		putLine: ');';
		popMessageNest.

]

{ #category : #'code generation' }
SWTranspilerOfJs >> putSequence: aSequence [
	self logger log.
	self incIndent.
	aSequence children do: [ :child |
		(child class = RBVariableNode) ifTrue: [
			self put: 'var '; put: child name; putLine: ' = null;'
		] ifFalse: [
			self
				transpile: child;
				putLine: ';'.
		].
	].
	self
		decIndent
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putSequenceWithReturn: aSequence [
	| counter |
	self logger log.
	self incIndent.
	counter := 1.
	aSequence children size timesRepeat: [|child|
		child := aSequence children at: counter.
		(child class = RBVariableNode) ifTrue: [
			self put: 'var '; put: child name; putLine: ' = null;'.
		] ifFalse: [
			(child class ~= RBReturnNode and: [ counter = aSequence children size ]) ifTrue: [
				self put: 'return '.
			].
			self
				transpile: child;
				putLine: ';'.
		].
		counter := counter + 1.
	].
	self
		decIndent
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putSymbol: aSymbol [
	self logger log: aSymbol asString.
	self
		put: '''';
		put: (self class safeSelectorNameOf: aSymbol);
		put: ''''
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putTestRunner: aClass [
	self logger log.
	self
		putLine;
		putLine: '(function(self){';
		pushMessageNest;
		incIndent;
		putLine: 'const runner = new self();'.
	(aClass methods select: [ :each | each protocol beginsWith: 'test' ]) do: [ :each |
		self
			putLine: 'runner.setUp();';
			put: 'runner.';
			put: each selector asString;
			putLine: '();';
			putLine: 'runner.tearDown();'
	].
	self decIndent;
		put: '})(';
		put: aClass name;
		putLine: ');'.	
	self popMessageNest.

]

{ #category : #'code generation' }
SWTranspilerOfJs >> putVariable: aVariableNode [
	self logger log: aVariableNode name.
	(aVariableNode isInstanceVariable) ifTrue: [
		^ self put: 'self._'; put: aVariableNode name
	].

	(aVariableNode isClassVariable) ifTrue: [
		^ self put: 'self._'; put: aVariableNode name
	].
	^ super putVariable: aVariableNode
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> upToEndFor: receiver With: arguments [
	self putMessage: receiver call: 'read' with: arguments
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> valueFor: receiver With: argunents [
	self logger log.
	self
		transpile: receiver;
		put: '()'
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> value_For: receiver With: arguments [
	self logger log.
	self
		put: '(';
		transpile: receiver;
		put: ')';
		putArguments: arguments
]

{ #category : #'code generation - domain specific' }
SWTranspilerOfJs >> yourselfFor: receiver With:arguments [
	self logger log.
	self transpile: receiver
]
