"
I am a Pharo to ECMAScript (with node.js) transpiler.
"
Class {
	#name : #SWTranspilerOfJs,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation - protected' }
SWTranspilerOfJs class >> transpiledNameOf: aName [
	aName = '<<' ifTrue: [ ^ 'input_' ].
	^ super transpiledNameOf: aName
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> and_For: receiver With: arguments [
	self
		transpile: receiver;
		put: ' && ';
		preventNewline;
		transpile: (arguments at: 1) body.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> anySatisfy_For: receiver With: arguments [
	self
		transpile: receiver;
		put: '.find';
		putBlockWithoutProc: (arguments at: 1)

]

{ #category : #converting }
SWTranspilerOfJs >> asStringFor: receiver With: arguments [
	self
		pushMessageNest;
		transpile: receiver;
		put: '.toString()';
		popMessageNest
		
]

{ #category : #converting }
SWTranspilerOfJs >> asSymbolFor: receiver With: arguments [
	self
		transpile: receiver;
		put: '.intern'
]

{ #category : #accessing }
SWTranspilerOfJs >> at_For: receiver With: arguments [
	self
		transpile: receiver;
		put: '[';
		transpile: (arguments at: 1);
		put: ']'

]

{ #category : #accessing }
SWTranspilerOfJs >> at_ifAbsent_For: receiver With: arguments [
	self
		put: '(';
		transpile: receiver;
		put: '[';
		transpile: (arguments at: 1);
		put: '] || ';
		preventNewline;
		transpile: (arguments at: 2) body;
		put: ')'

]

{ #category : #accessing }
SWTranspilerOfJs >> at_put_For: receiver With: arguments [
	self
		transpile: receiver;
		pushMessageNest;
		put: '[';
		transpile: (arguments at: 1);
		put: '] = ';
		transpile: (arguments at: 2);
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> beginsWith_For: receiver With: arguments [
	self putMessage: receiver call: 'start_with?' with: arguments
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> collect_For: receiver With: arguments [
	self
		transpile: receiver;
		put: '.collect';
		putBlockWithoutProc: (arguments at: 1)

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> copyFor:receiver With: arguments [
	self
		transpile: receiver;
		put: '.clone'
]

{ #category : #copying }
SWTranspilerOfJs >> copyReplaceAll_with_For: receiver With: arguments [
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

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> descriptionFor: receiver With: arguments [
	self
		pushMessageNest;	
		putMessage: receiver call: 'message' with: arguments;
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> do_For: receiver With: arguments [
	self
		pushMessageNest;
		transpile: receiver;
		put: '.each';
		putBlockWithoutProc: (arguments at: 1);
		popMessageNest.

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> ensure_For: receiver With: arguments [
	self
		pushMessageNest;
		putLine: 'begin';
		transpile: receiver body;
		putLine: 'ensure';
		transpile: (arguments at: 1) body;
		put: 'end';
		popMessageNest

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> ifFalse_For: receiver With: arguments [
	self
		put: 'if (!';
		pushMessageNest;
		transpile: receiver;
		putLine: '){';
		transpile: (arguments at: 1) body;
		popMessageNest;
		put: '}'

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> ifNil_For: receiver With: arguments [
	self
		pushMessageNest;
		put: '(if ';
		transpile: receiver;
		putLine: '.nil?';
		transpile: (arguments at: 1) body;
		putLine: 'else';
		incIndent;
		transpile: receiver;
		putLine;
		decIndent;
		put: 'end)';
		popMessageNest
		
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> ifNotNil_For: receiver With: arguments [
	self
		pushMessageNest;
		put: '(not (';
		transpile: receiver;
		putLine: ').nil?) ? (';
		transpile: (arguments at: 1) body;
		put: '): nil';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> ifNotNil_ifNil_For: receiver With: arguments [
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

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> ifTrue_For: receiver With: arguments [
	self
		pushMessageNest;
		put: 'if ';
		transpile: receiver;
		putLine;
		transpile: (arguments at: 1) body;
		put: 'end'

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> ifTrue_ifFalse_For: receiver With: arguments [
	self
		pushMessageNest;
		put: '(if ';
		transpile: receiver;
		putLine;
		transpile: (arguments at: 1) body;
		putLine: 'else';
		transpile: (arguments at: 2) body;
		put: 'end)';
		popMessageNest
]

{ #category : #initialization }
SWTranspilerOfJs >> initialize [
	super initialize.
	self newline: String lf.
	self type: #js.

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> join_For: receiver With: arguments [
	self
		pushMessageNest;
		putMessage: (arguments at: 1) call: 'join' with: { receiver };
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> on_do_For: receiver With: arguments [
	self
		pushMessageNest;
		putLine: 'begin';
		transpile: receiver body;
		put: 'rescue => ';
		putLine: ((0 < (arguments at: 2) arguments size) ifTrue: [ (arguments at: 2) argumentNames at: 1 ] ifFalse: ['e']);
		transpile: (arguments at: 2) body;
		put: 'end';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> opArrow_For: receiver With: arguments [
	self
		pushMessageNest;
		put: 'Association.new(';
		transpile: receiver;
		put: ', ';
		transpile: (arguments at: 1);
		put: ')';
		popMessageNest.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> opCamma_For: receiver With: arguments [
	self
		transpile: receiver;
		put: ' + ';
		transpile: (arguments at: 1)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> opEqual_For: receiver With: arguments [
	self
		transpile: receiver;
		put: ' == ';
		transpile: (arguments at: 1)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> opNotEqual_For: receiver With: arguments [
	self
		transpile: receiver;
		put: ' != ';
		transpile: (arguments at: 1)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> perform_For: receiver With: arguments [
	self
		pushMessageNest;
		putMessage: receiver call: 'send' with: arguments;
		popMessageNest.
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putArgumentsOf: selector with: arguments [
	self
		put: '(';
		putArray: arguments;
		put: ')'

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putBlock: aBlock [
	self 
		put: 'proc';
		putBlockWithoutProc: aBlock

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putBlockWithoutProc: aBlock [
	self 
		pushMessageNest;
		put: '{'.
	(0 < aBlock arguments size) ifTrue: [
		self put: '|'.
		aBlock argumentNames do: [ :each |
			self put: each asString
		] separatedBy: [
			self put: ', '
		].
		self put: '|'
	].
	self
		putLine;
		transpile: aBlock body;
		put: '}';
		popMessageNest


]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putClassDefinition: aClass [
	self putComment: aClass comment.
	self put: 'class '.
	self put: aClass name.
	(aClass superclass = Object) ifFalse: [
		self put: ' extends '; put: aClass superclass name
	].
	self putLine: '{'.
	self incIndent.

	aClass classVariables do: [ :aVal |
		self put: '@@'; put: aVal name; putLine: ' = nil'
	].

	aClass instanceVariables do: [ :aVal |
		self put: '_'; put: aVal name; putLine: ' = null'
	].

	aClass class methods select: [:aMethod | (aMethod protocol beginsWith: 'code generation') not ] thenDo: [ :aMethod |
		self putMethod: aMethod ofClass: aClass
	].

	aClass methods select: [ :aMethod | (aMethod protocol beginsWith: 'code generation') not ] thenDo: [ :aMethod |
		self putMethod: aMethod ofClass: aClass
	].

	self flag: #toImplement.

	self decIndent.
	self putLine: '}'.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putComment: comment [
	comment ifNotNil: [
		comment linesDo: [ :aLine |
			self
				put: '// ';
				putLine: aLine
		]
	]
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putFileHeaderOf: filename [


]

{ #category : #'code generation' }
SWTranspilerOfJs >> putFunctionCallOf: selector with: arguments [
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

{ #category : #tests }
SWTranspilerOfJs >> putMainProgram [
	self putCode: '\
		(new %entryClass%()).main_(process.argv)
	\' with: { '%entryClass%' -> self source entryClass asString }

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putMessage: receiver call: selector with: arguments [
	(receiver respondsTo: #name) ifTrue: [
		(receiver name = 'super') ifTrue: [
			^ self putFunctionCallOf: 'super' with: arguments
		].
		(receiver name = 'self') ifTrue: [ 
			^ super putMessage: (RBVariableNode new name: 'this'; yourself) call: selector with: arguments
		].
	].
	^ super putMessage: receiver call: selector with: arguments
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putMethod: aMethod ofClass: aClass [
	|sel|
	self
		putComment: aMethod comment;
		put: ((aMethod methodClass class = Metaclass) ifTrue: ['self.'] ifFalse: [ '' ]);
		put: (self class transpiledNameOf: aMethod selector);
		put: '(';
		put: (', ' join: (aMethod argumentNames collect: [ :each | each asString ]));
		putLine: ') {';
		pushMessageNest.
	sel := self transpiledNameOf: aMethod.
	(aClass respondsTo: sel) ifTrue: [
		self incIndent.
		aClass perform: sel with: self.
		self decIndent.
		self putLine.
	] ifFalse: [
		aMethod transpileUsing: self.
	].
	self
		putLine: '}';
		popMessageNest.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putNil [
	self put: 'nil'
]

{ #category : #'code generation' }
SWTranspilerOfJs >> putRequirements [
	|sel|
	sel := #'js_requirements'.
	self source classes do: [:aClass |
		(aClass respondsTo: sel) ifTrue: [
			(aClass perform: sel) do: [ :dependence |
				dependence isString ifTrue: [
					self putLine: dependence
				] ifFalse: [
					self halt
				]
			]
		]
	]

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putSymbol: aSymbol [
	self
		put: ':';
		put: (self class transpiledNameOf: aSymbol)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putTestRunner [
	self
		put: 'runner = ';
		put: self source mainClass asString;
		putLine: '.new'.
	(self source mainClass methods select: [ :each |
		each protocol beginsWith: 'test'
	]) do: [ :each |
		self
			putLine: 'runner.setUp';
			put: 'runner.';
			putLine: each selector asString;
			putLine: 'runner.tearDown'
	]

]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> putVariable: aVariableNode [
	(#(String Dictionary) anySatisfy: [ :each| each = aVariableNode name ]) ifTrue: [
		^ self
			put: 'SW';
			put: aVariableNode name
	].

	(aVariableNode isInstanceVariable) ifTrue: [
		^ self put: '_'; put: aVariableNode name
	].

	(aVariableNode isClassVariable) ifTrue: [
		^ self put: '@@'; put: aVariableNode name
	].
	^ super putVariable: aVariableNode
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> valueFor: receiver With: argunents [
	self
		transpile: receiver;
		put: '()'
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> value_For: receiver With: arguments [
	self
		transpile: receiver;
		put: '.';
		putFunctionCallOf: 'call' with: arguments
]

{ #category : #'as yet unclassified' }
SWTranspilerOfJs >> yourselfFor: receiver With:arguments [
	self transpile: receiver
]
