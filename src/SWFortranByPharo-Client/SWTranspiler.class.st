"
I transpile a SWSource.
SWTranspiler>>#source: sets the SWSource as a source of transpilation.
SWTranspiler>>#transpile does transpile.
SWTranspiler>>#contents returns the result.
"
Class {
	#name : #SWTranspiler,
	#superclass : #SWTranspilerBaseOld,
	#instVars : [
		'stream',
		'indent',
		'tabWidth',
		'isNewline',
		'newline',
		'preventNewline',
		'messageNest',
		'source',
		'pool',
		'analyzer'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWTranspiler >> analyzer [

	^ analyzer ifNil: [ analyzer := SWAnalyzerDummy new ]
]

{ #category : #accessing }
SWTranspiler >> analyzer: anObject [

	analyzer := anObject
]

{ #category : #'code generation' }
SWTranspiler >> assign: key with: value [
	self logger log: [ key asString, ' = ', value asString ].
	self transpile: key; put: ' = '.
	value transpileUsing: self.

]

{ #category : #accessing }
SWTranspiler >> contents [
	^ stream contents
]

{ #category : #'code generation - protected' }
SWTranspiler >> decIndent [
	indent := indent - 1.
	indent < 0 ifTrue: [ self error: 'Indentation clauses mismatch.' ]
]

{ #category : #'code generation - protected' }
SWTranspiler >> decMessageNest [
	messageNest push: { 0. messageNest pop - 1 } max.
	0 < messageNest top ifTrue: [ self put: ')' ].

]

{ #category : #'code generation - protected' }
SWTranspiler >> incIndent [
	indent := indent + 1.
]

{ #category : #'code generation - protected' }
SWTranspiler >> incMessageNest [
	messageNest push: (messageNest pop + 1).
	1 < messageNest top ifTrue: [ self put: '(' ].
]

{ #category : #initialization }
SWTranspiler >> initialize [
	super initialize.
	stream := String new writeStream.
	indent := 0.
	newline := String crlf.
	isNewline := false.
	preventNewline := false.
	messageNest := Stack new push: 0; yourself.


]

{ #category : #accessing }
SWTranspiler >> newline [

	^ newline
]

{ #category : #accessing }
SWTranspiler >> newline: anObject [

	newline := anObject
]

{ #category : #'code generation' }
SWTranspiler >> opEqual_For: receiver With: arguments [
	self logger log: [ receiver asString, ' == ', (arguments at: 1) asString ].
	self
		transpile: receiver;
		put: ' == ';
		transpile: (arguments at: 1).

]

{ #category : #accessing }
SWTranspiler >> pool [

	^ pool ifNil: [ pool := SWSourcesPool new type: self type; yourself ]
]

{ #category : #accessing }
SWTranspiler >> pool: anObject [

	pool := anObject
]

{ #category : #'code generation - protected' }
SWTranspiler >> popMessageNest [
	messageNest pop
]

{ #category : #'code generation - protected' }
SWTranspiler >> preventNewline [
	preventNewline := true
]

{ #category : #'code generation - protected' }
SWTranspiler >> pushMessageNest [
	messageNest push: 0
]

{ #category : #'code generation' }
SWTranspiler >> put: code [
	self logger log: code.
	self putIndent.
	stream nextPutAll: code.
]

{ #category : #'code generation' }
SWTranspiler >> putArguments: artuments [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putArray: anArray [
	self logger log.
	self put: '['.
	anArray do: [:each |
		each transpileUsing: self.
	] separatedBy: [
		self put: ', '
	].
	self put: ']'.

]

{ #category : #'code generation' }
SWTranspiler >> putBlock: aBlock [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putCascade: aRBCascadeNode [
	|msg block seq tmp|
	tmp := RBVariableNode new
		name: 'tmp';
		yourself.
	seq := RBSequenceNode new
		addNodes: (aRBCascadeNode messages collect: [:each |
			each copy receiver: tmp; yourself
		]);
		yourself.

	block := RBBlockNode new
		arguments: { tmp };
		body: seq;
		yourself.
	msg := RBMessageNode new
		receiver: block;
		selector: #value:;
		arguments: { aRBCascadeNode receiver copy };
		yourself.

	^ msg transpileUsing: self.

]

{ #category : #'code generation' }
SWTranspiler >> putCharacter: c [
	self logger log.

	self
		put: '"';
		put: c asString;
		put: '"'.
]

{ #category : #'code generation' }
SWTranspiler >> putClassAccessor [
	self put: '.'
]

{ #category : #'code generation' }
SWTranspiler >> putClassDefinition: aClass [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putCode: code [
	^ self putCode: code with: {  }
]

{ #category : #'code generation' }
SWTranspiler >> putCode: code with: anAssociationArray [
	"when a line in code ends with $\, the line continues to the next."
	|matcher leftPad escaped|
	self logger log.

	matcher := RxMatcher forString: '(\\\r|\s+\\$)'.
	escaped := matcher copy: code replacingMatchesWith: ''.
	leftPad := (escaped findFirst: [ :c | c ~= Character tab ])-1.
	matcher := RxMatcher forString: '\t+'.
	escaped := matcher copy: escaped translatingMatchesUsing: [ :m |
		String tab repeat: (m size - leftPad)
	].
	anAssociationArray do: [ :each |
		escaped := escaped copyReplaceAll: each key with: each value.
	].
	self put: escaped.


]

{ #category : #'code generation' }
SWTranspiler >> putComment: aComment [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putFileFooterOf: filename [
]

{ #category : #'code generation' }
SWTranspiler >> putFileHeaderOf: filename [
	
	
]

{ #category : #'code generation' }
SWTranspiler >> putFloat: anFloat [
	self put: anFloat asString
]

{ #category : #'code generation' }
SWTranspiler >> putImportClass: aClass [
	self logger log.
	self halt.
	self flag: #toImplement.
	self analyzer putImportClass: aClass
]

{ #category : #'code generation - protected' }
SWTranspiler >> putIndent [
	isNewline ifFalse: [ ^ self ].
	stream nextPutAll: (' ' repeat: {0. (self tabWidth * indent)} max).
	isNewline := false.

]

{ #category : #'code generation' }
SWTranspiler >> putInteger: anInteger [
	self put: anInteger asString
]

{ #category : #'code generation' }
SWTranspiler >> putLine [
	preventNewline
		ifTrue: [ preventNewline := false ]
		ifFalse: [
			stream << newline.
			isNewline := true.
		].

]

{ #category : #'code generation' }
SWTranspiler >> putLine: code [
	self put: code.
	self putLine.

]

{ #category : #'code generation' }
SWTranspiler >> putMessage: receiver call: selector with: arguments [
	self logger log.
	self incMessageNest.
	super putMessage: receiver call: selector with: arguments.
	self decMessageNest.
]

{ #category : #'code generation' }
SWTranspiler >> putMethod: selector ofClass: class [
	|sAnalyzer|
	sAnalyzer := self analyzer subAnalyzer.
	self halt.
	self flag: #toImplement.
]

{ #category : #'code generation' }
SWTranspiler >> putNil [
	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putOrdinaryMessage: receiver call: selector with: arguments [
	receiver transpileUsing: self.
	selector first isLetter ifTrue: [
		self putClassAccessor;
			put: (self class safeSelectorNameOf: selector);
			putArguments: arguments.
	] ifFalse: [
		self
			put: selector;
			transpile: (arguments at: 1)
	]


]

{ #category : #'code generation' }
SWTranspiler >> putParameters: anArray [
	self logger log.
	anArray do: [:each |
		self put: each asString
	] separatedBy: [
		self put: ', '
	]

]

{ #category : #'code generation' }
SWTranspiler >> putProgram: aClass [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putRequirements [
	|sel|
	sel := self type, '_requirements:'.
	self source classes do: [ :aClass |
		(aClass respondsTo: sel) ifTrue: [
			aClass perform: sel with: self
		]
	]

]

{ #category : #'code generation' }
SWTranspiler >> putReturn: value [
	self logger log.
	^ self
		put: 'return ';
		transpile: value.
]

{ #category : #'code generation' }
SWTranspiler >> putSequence: aSequence [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putString: aString [
	self logger log.
	self
		put: '"';
		put: aString;
		put: '"'.
]

{ #category : #'code generation' }
SWTranspiler >> putSymbol: aSymbol [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putTestRunner: aClass [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putVariable: aVariableNode [
	self logger log: aVariableNode name.
	self put: aVariableNode name
]

{ #category : #accessing }
SWTranspiler >> readStream [
	^ stream readStream
]

{ #category : #accessing }
SWTranspiler >> source [

	^ source
]

{ #category : #accessing }
SWTranspiler >> source: anObject [

	source := anObject
]

{ #category : #accessing }
SWTranspiler >> tabWidth [

	^ tabWidth ifNil: [ tabWidth := 4 ]
]

{ #category : #accessing }
SWTranspiler >> tabWidth: anObject [

	tabWidth := anObject
]

{ #category : #'public API' }
SWTranspiler >> transpile [
	|programClass|
	self putFileHeaderOf: self source moduleName.
	self putRequirements.
	self source classes do: [ :aClass |
		self putClassDefinition: aClass
	].

	(programClass := self source programClass) ifNotNil: [
		(programClass inheritsFrom: SWTestBase) ifTrue: [
			self putTestRunner: programClass
		] ifFalse: [
			self putProgram: programClass
		]
	].

	self putFileFooterOf: self source moduleName

]

{ #category : #'code generation' }
SWTranspiler >> transpile: anObject [
	self logger log.
	^ anObject transpileUsing: self
]

{ #category : #'public API' }
SWTranspiler >> transpileAsModule [
	self putFileHeaderOf: self source moduleName.
	self putRequirements.
	self source classes do: [ :aClass |
		self putClassDefinition: aClass
	]
]
