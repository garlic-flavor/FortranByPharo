"
I am a Pharo to ECMAScript (with node.js) transpiler.
"
Class {
	#name : #SWTranspilerOfJs,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation - protected' }
SWTranspilerOfJs class >> transpiledSelectorNameOf: aName [
	aName = '<<' ifTrue: [ ^ 'input_' ].
	^ super transpiledSelectorNameOf: aName
]

{ #category : #'code generation' }
SWTranspilerOfJs >> and_For: receiver With: arguments [
	self
		transpile: receiver;
		put: ' && ';
		preventNewline;
		putSequence: (arguments at: 1) body.
]

{ #category : #'code generation' }
SWTranspilerOfJs >> anySatisfy_For: receiver With: arguments [
	self
		transpile: receiver;
		put: '.find(';
		putBlock: (arguments at: 1);
		put: ')'.

]

{ #category : #'code generation' }
SWTranspilerOfJs >> asStringFor: receiver With: arguments [
	self
		pushMessageNest;
		transpile: receiver;
		put: '.toString()';
		popMessageNest
		
]

{ #category : #'code generation' }
SWTranspilerOfJs >> asSymbolFor: receiver With: arguments [
	self
		transpile: receiver;
		put: '.toString()'
]

{ #category : #'code generation' }
SWTranspilerOfJs >> at_For: receiver With: arguments [
	self
		transpile: receiver;
		put: '[';
		transpile: (arguments at: 1);
		put: ']'

]

{ #category : #'code generation' }
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

{ #category : #'code generation' }
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

{ #category : #'code generation' }
SWTranspilerOfJs >> beginsWith_For: receiver With: arguments [
	self logger log.
	self putMessage: receiver call: 'start_with?' with: arguments
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> classFor: receiver With: arguments [
	self logger log.
	self
		transpile: receiver;
		put: '.constructor'
]

{ #category : #'code generation' }
SWTranspilerOfJs >> collect_For: receiver With: arguments [
	self logger log.
	self flag: #ToImplement.
	self
		transpile: receiver;
		put: '.collect';
		putBlockWithoutProc: (arguments at: 1)

]

{ #category : #'code generation' }
SWTranspilerOfJs >> copyFor:receiver With: arguments [
	self logger log.
	self
		transpile: receiver;
		put: '.clone'
]

{ #category : #'code generation' }
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

{ #category : #'code generation' }
SWTranspilerOfJs >> descriptionFor: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;	
		putMessage: receiver call: 'message' with: arguments;
		popMessageNest
]

{ #category : #'code generation' }
SWTranspilerOfJs >> do_For: receiver With: arguments [
	self logger log.
	self flag: #ToImplement.
	self
		pushMessageNest;
		transpile: receiver;
		put: '.each';
		putBlockWithoutProc: (arguments at: 1);
		popMessageNest.

]

{ #category : #'code generation' }
SWTranspilerOfJs >> ensure_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		putLine: 'begin';
		transpile: receiver body;
		putLine: 'ensure';
		transpile: (arguments at: 1) body;
		put: 'end';
		popMessageNest

]

{ #category : #'code generation' }
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

{ #category : #'code generation' }
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

{ #category : #'code generation' }
SWTranspilerOfJs >> ifNotNil_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		put: '(not (';
		transpile: receiver;
		putLine: ').nil?) ? (';
		transpile: (arguments at: 1) body;
		put: '): nil';
		popMessageNest
]

{ #category : #'code generation' }
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

{ #category : #'code generation' }
SWTranspilerOfJs >> ifTrue_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		put: 'if ';
		transpile: receiver;
		putLine;
		transpile: (arguments at: 1) body;
		put: 'end'

]

{ #category : #'code generation' }
SWTranspilerOfJs >> ifTrue_ifFalse_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		putLine: '(function(o){ if(o){ ';
		putSequenceWithReturn: (arguments at: 1) body;
		putLine: '} else {';
		putSequenceWithReturn: (arguments at: 2) body;
		put: '}})(';
		transpile: receiver;
		put: ')';
		popMessageNest
]

{ #category : #initialization }
SWTranspilerOfJs >> initialize [
	super initialize.
	self newline: String lf.
	self type: #mjs.

]

{ #category : #'code generation' }
SWTranspilerOfJs >> join_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		putMessage: (arguments at: 1) call: 'join' with: { receiver };
		popMessageNest
]

{ #category : #'code generation' }
SWTranspilerOfJs >> newFor: receiver With: arguments [
	self logger log.
	self
		put: 'new ';
		transpile: receiver;
		put: '()'

]

{ #category : #'code generation' }
SWTranspilerOfJs >> on_do_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		putLine: 'try{';
		putSequence: receiver body;
		put: '} catch (';
		put: ((0 < (arguments at: 2) arguments size) ifTrue: [ (arguments at: 2) argumentNames at: 1 ] ifFalse: ['e']);
		putLine: '){';
		putSequence: (arguments at: 2) body;
		put: '}';
		popMessageNest
]

{ #category : #'code generation' }
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

{ #category : #'code generation' }
SWTranspilerOfJs >> opCamma_For: receiver With: arguments [
	self logger log.
	self
		transpile: receiver;
		put: ' + ';
		transpile: (arguments at: 1)
]

{ #category : #'code generation' }
SWTranspilerOfJs >> opNotEqual_For: receiver With: arguments [
	self logger log.
	self
		transpile: receiver;
		put: ' != ';
		transpile: (arguments at: 1)
]

{ #category : #'code generation' }
SWTranspilerOfJs >> perform_For: receiver With: arguments [
	self logger log.
	self
		pushMessageNest;
		putMessage: receiver call: 'send' with: arguments;
		popMessageNest.
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putArgumentsOf: selector with: arguments [
	self logger log.
	self
		put: '(';
		putArray: arguments;
		put: ')'

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
		self put: aClass name; put: '.'; put: aVal name; putLine: ' = nil'
	].

	aClass class methods select: [:aMethod | (aMethod protocol beginsWith: 'code generation') not ] thenDo: [ :aMethod |
		self putClassMethod: aMethod ofClass: aClass.
	].

]

{ #category : #'code generation' }
SWTranspilerOfJs >> putClassMethod: aMethod ofClass: aClass [
	|sel|
	self logger log.
	sel := self class transpiledSelectorNameOf: aMethod selector.
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
	sel := self transpilerNameOf: aMethod.
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
SWTranspilerOfJs >> putFunctionCallOf: selector with: arguments [
	self logger log.
	self
		pushMessageNest;
		put: (selector asString first isLetter ifTrue: [
			selector
		] ifFalse: [
			' ' join: {''. selector. ''}
		]);
		putArgumentsOf: selector with: arguments;
		popMessageNest
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putImportClass: aClass [
	|s|
	self logger log.
	s := self pool get: aClass name.
	self
		put: 'import {';
		put: s moduleName;
		put: '} from ''../../';
		put: s filename;
		putLine: ''';'.


]

{ #category : #'as yet unclassified' }
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
		put: '} from ''../../';
		put: (SWSourcesPool localScriptDirectory / fileName) fullName;
		putLine: ''';'.

]

{ #category : #'code generation' }
SWTranspilerOfJs >> putMainProgram [
	self logger log.
	self putCode: '\
		(new %entryClass%()).main_(process.argv)
	\' with: { '%entryClass%' -> self source entryClass asString }

]

{ #category : #'code generation' }
SWTranspilerOfJs >> putMethod: aMethod ofClass: aClass [
	|sel|
	self logger log.
	self
		putComment: aMethod comment;
		put: (self class transpiledSelectorNameOf: aMethod selector);
		put: '(';
		put: (', ' join: (aMethod argumentNames collect: [ :each | each asString ]));
		putLine: ') {';
		pushMessageNest;
		incIndent;
		putLine: 'var self = this;';
		decIndent.
	sel := self transpilerNameOf: aMethod.
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
	self put: 'nil'
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
		put: (self class transpiledSelectorNameOf: aSymbol);
		put: ''''
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putTestRunner [
	|hasRunner|
	self logger log.
	hasRunner := false.
	self source mainClass methods do: [ :each |
		(each protocol beginsWith: 'test') ifTrue: [ hasRunner := true ]
	].
	hasRunner ifFalse: [ ^ self ].
	self
		put: 'var runner = new ';
		put: self source mainClass asString;
		putLine: ';'.
	(self source mainClass methods select: [ :each |
		each protocol beginsWith: 'test'
	]) do: [ :each |
		self
			putLine: 'runner.setUp();';
			put: 'runner.';
			put: each selector asString;
			putLine: '();';
			putLine: 'runner.tearDown();'
	]

]

{ #category : #'code generation' }
SWTranspilerOfJs >> putVariable: aVariableNode [
	self logger log: aVariableNode name.
	(#(Dictionary) anySatisfy: [ :each| each = aVariableNode name ]) ifTrue: [
		^ self
			put: 'SW';
			put: aVariableNode name
	].
	(aVariableNode isInstanceVariable) ifTrue: [
		^ self put: 'self._'; put: aVariableNode name
	].

	(aVariableNode isClassVariable) ifTrue: [
		^ self put: '@@'; put: aVariableNode name
	].
	^ super putVariable: aVariableNode
]

{ #category : #'code generation' }
SWTranspilerOfJs >> valueFor: receiver With: argunents [
	self logger log.
	self
		transpile: receiver;
		put: '()'
]

{ #category : #'code generation' }
SWTranspilerOfJs >> value_For: receiver With: arguments [
	self logger log.
	self
		put: '(';
		transpile: receiver;
		put: ')';
		putArgumentsOf: '' with: arguments
]

{ #category : #'code generation' }
SWTranspilerOfJs >> yourselfFor: receiver With:arguments [
	self logger log.
	self transpile: receiver
]