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

{ #category : #converting }
SWTranspilerOfRuby >> asStringfor: receiver with: arguments [
	self
		transpile: receiver;
		put: '.to_s'
]

{ #category : #accessing }
SWTranspilerOfRuby >> at_ifAbsent_for: receiver with: arguments [
	self
		put: '(';
		transpile: receiver;
		put: '[';
		transpile: (arguments at: 1);
		put: '] || ';
		transpile: (arguments at: 2);
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
		put: '(';
		transpile: receiver;
		putLine: ').present? ? (';
		transpile: (arguments at: 1) body;
		put: '): nil';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifNotNil_ifNil_for: receiver with: arguments [
	self
		pushMessageNest;
		put: 'if(';
		transpile: receiver;
		putLine: '.present?){';
		transpile: (arguments at: 1) body;
		putLine: '} else {';
		transpile: (arguments at: 2) body;
		put: '}';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifTrue_for: receiver with: arguments [
	self
		pushMessageNest;
		put: 'if(';
		transpile: receiver;
		putLine: '){';
		transpile: (arguments at: 1) body;
		put: '}'

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
SWTranspilerOfRuby >> opCamma_for: receiver with: arguments [
	self
		transpile: receiver;
		put: ' + ';
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
		pushMessageNest;
		put: 'proc {'.
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
	aClass instanceVariables select: [:var | aClass instanceVariableDeclarationFilter: var name ] thenDo: [ :var |
		self put: '@'; put: var name; putLine: ' = nil'
	].

	aClass class methods select: [:aMethod | aClass classMethodDeclarationFilter: aMethod selector] thenDo: [ :aMethod |
		self putMethod: aMethod ofClass: aClass class
	].

	aClass methods select: [ :aMethod | aClass methodDeclarationFilter: aMethod selector] thenDo: [ :aMethod |
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

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putSymbol: aSymbol [
	self
		put: ':';
		put: aSymbol
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
SWTranspilerOfRuby >> putVariable: aName [
	(#(String) anySatisfy: [ :each| each = aName ]) ifTrue: [
		^ self
			put: 'SW';
			put: aName
	].
	^ super putVariable: aName
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
