"
I translate pharo code to Ruby.
"
Class {
	#name : #SWTranspilerOfRuby,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> and_for: receiver with: arguments [
	self
		transpile: receiver;
		put: ' && ';
		preventNewline;
		transpile: (arguments at: 1) body.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> anySatisfy_for: receiver with: arguments [
	self
		transpile: receiver;
		put: '.find';
		putBlockWithoutProc: (arguments at: 1)

]

{ #category : #converting }
SWTranspilerOfRuby >> asStringfor: receiver with: arguments [
	self
		transpile: receiver;
		put: '.to_s'
]

{ #category : #converting }
SWTranspilerOfRuby >> asSymbolfor: receiver with: arguments [
	self
		transpile: receiver;
		put: '.intern'
]

{ #category : #accessing }
SWTranspilerOfRuby >> at_for: receiver with: arguments [
	self
		transpile: receiver;
		put: '[';
		transpile: (arguments at: 1);
		put: ']'

]

{ #category : #accessing }
SWTranspilerOfRuby >> at_ifAbsent_for: receiver with: arguments [
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
SWTranspilerOfRuby >> at_put_for: receiver with: arguments [
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
SWTranspilerOfRuby >> beginsWith_for: receiver with: arguments [
	self putMessage: receiver call: 'start_with?' with: arguments
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> collect_for: receiver with: arguments [
	self
		transpile: receiver;
		put: '.collect';
		putBlockWithoutProc: (arguments at: 1)

]

{ #category : #copying }
SWTranspilerOfRuby >> copyReplaceAll_with_for: receiver with: arguments [
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
SWTranspilerOfRuby >> copyfor:receiver with: arguments [
	self
		transpile: receiver;
		put: '.clone'
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ensure_for: receiver with: arguments [
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
SWTranspilerOfRuby >> ifFalse_for: receiver with: arguments [
	self
		put: 'if not ';
		pushMessageNest;
		transpile: receiver;
		putLine;
		transpile: (arguments at: 1) body;
		popMessageNest;
		put: 'end'

]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifNil_for: receiver with: arguments [
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
SWTranspilerOfRuby >> ifNotNil_for: receiver with: arguments [
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
SWTranspilerOfRuby >> ifNotNil_ifNil_for: receiver with: arguments [
	self
		pushMessageNest;
		put: 'if ';
		transpile: receiver;
		putLine: '.present?';
		transpile: (arguments at: 1) body;
		putLine: 'else';
		transpile: (arguments at: 2) body;
		put: 'end';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifTrue_for: receiver with: arguments [
	self
		pushMessageNest;
		put: 'if ';
		transpile: receiver;
		putLine;
		transpile: (arguments at: 1) body;
		put: 'end'

]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifTrue_ifFalse_for: receiver with: arguments [
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
SWTranspilerOfRuby >> initialize [
	super initialize.
	self newline: String lf.
	self type: #rb.

]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> join_for: receiver with: arguments [
	self
		pushMessageNest;
		putMessage: (arguments at: 1) call: 'join' with: { receiver };
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> on_do_for: receiver with: arguments [
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
SWTranspilerOfRuby >> opArrow_for: receiver with: arguments [
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
SWTranspilerOfRuby >> opCamma_for: receiver with: arguments [
	self
		transpile: receiver;
		put: ' + ';
		transpile: (arguments at: 1)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> opNotEqual_for: receiver with: arguments [
	self
		transpile: receiver;
		put: ' != ';
		transpile: (arguments at: 1)
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putArgumentsOf: selector with: arguments [
	(0 < arguments size) ifTrue: [
		self
			put: '(';
			putArray: arguments;
			put: ')'
	]
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putBlock: aBlock [
	self 
		put: 'proc';
		putBlockWithoutProc: aBlock

]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putBlockWithoutProc: aBlock [
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
SWTranspilerOfRuby >> putClassDefinition: aClass [
	self putComment: aClass comment.
	self put: 'class '.
	self put: aClass name.
	(aClass superclass = Object) ifFalse: [
		self put: ' < '; put: aClass superclass name
	].
	self putLine.
	self incIndent.

	aClass classVariables do: [ :aVal |
		self put: '@@'; put: aVal name; putLine: ' = nil'
	].

	aClass instanceVariables do: [ :aVal |
		self put: '@'; put: aVal name; putLine: ' = nil'
	].

	aClass class methods select: [:aMethod | aMethod protocol ~= #'code generation'] thenDo: [ :aMethod |
		self putMethod: aMethod ofClass: aClass
	].

	aClass methods select: [ :aMethod | aMethod protocol ~= #'code generation'] thenDo: [ :aMethod |
		self putMethod: aMethod ofClass: aClass
	].

	self flag: #toImplement.

	self decIndent.
	self putLine: 'end'.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putClassname: aName [
	(#(String) anySatisfy: [ :each| each = aName ]) ifTrue: [
		^ self
			put: 'SW';
			put: aName
	].

	^ super putClassname: aName
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putComment: comment [
	comment ifNotNil: [
		comment linesDo: [ :aLine |
			self
				put: '# ';
				putLine: aLine
		]
	]
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putFileHeaderOf: filename [
	self putLine: '#!/usr/bin/ruby'.

]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putFunctionCallOf: selector with: arguments [
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
SWTranspilerOfRuby >> putMainProgram [
	self putCode: '\
		(%entryClass%.new).main_(ARGV)
	\' with: { '%entryClass%' -> self source entryClass }

]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putMessage: receiver call: selector with: arguments [
	((receiver respondsTo: #name) and: [receiver name = 'super']) ifTrue: [
		^ self putFunctionCallOf: 'super' with: arguments
	].
	^ super putMessage: receiver call: selector with: arguments
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putMethod: aMethod ofClass: aClass [
	|sel|
	self
		putComment: aMethod comment;
		put: 'def ';
		put: ((aMethod methodClass class = Metaclass) ifTrue: ['self.'] ifFalse: [ '' ]);
		put: (self class transpiledNameOf: aMethod selector);
		put: '(';
		put: (', ' join: (aMethod argumentNames collect: [ :each | each asString ]));
		putLine: ')';
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
		putLine: 'end';
		popMessageNest.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putNil [
	self put: 'nil'
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putRequirements [
	|sel|
	sel := #'rb_requirements'.
	self source classes do: [:aClass |
		(aClass respondsTo: sel) ifTrue: [
			(aClass perform: sel) do: [ :dependence |
				dependence isString ifTrue: [
					self put: 'require '''; put: dependence; putLine: ''''
				] ifFalse: [|dep|
					dep := SWSource new
						classes: { dependence };
						type: self type;
						putTo: self client;
						yourself.
					self put: 'require '''; put: dep filename; putLine: ''''
				]
			]
		]
	]

]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putSymbol: aSymbol [
	self
		put: ':';
		put: (self class transpiledNameOf: aSymbol)
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putTestRunner [
	self
		put: 'runner = ';
		put: self source mainClass asString;
		putLine: '.new'.
	(self source mainClass methods select: [ :each |
		each selector asString beginsWith: 'test'
	]) do: [ :each |
		self
			putLine: 'runner.setUp';
			put: 'runner.';
			putLine: each selector asString;
			putLine: 'runner.tearDown'
	]

]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putVariable: aVariableNode [
	(#(String Dictionary) anySatisfy: [ :each| each = aVariableNode name ]) ifTrue: [
		^ self
			put: 'SW';
			put: aVariableNode name
	].

	(aVariableNode isInstanceVariable) ifTrue: [
		^ self put: '@'; put: aVariableNode name
	].

	(aVariableNode isClassVariable) ifTrue: [
		^ self put: '@@'; put: aVariableNode name
	].
	^ super putVariable: aVariableNode
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> value_for: receiver with: arguments [
	self
		transpile: receiver;
		put: '.';
		putFunctionCallOf: 'call' with: arguments
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> valuefor: receiver with: argunents [
	self
		transpile: receiver;
		put: '.call'
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> yourselffor: receiver with:arguments [
	self transpile: receiver
]
