"
I transpile SWProject.
"
Class {
	#name : #SWTranspiler,
	#superclass : #Object,
	#instVars : [
		'type',
		'classes',
		'mainClass',
		'stream',
		'indent',
		'tabWidth',
		'isNewline',
		'newline',
		'preventNewline',
		'messageNest'
	],
	#classVars : [
		'selectorName'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation - protected' }
SWTranspiler class >> transpiledNameOf: selector [
	selector = '=' ifTrue: [
		^ 'opEqual_'
	].
	^ selector asString copyReplaceAll: ':' with: '_'
	
]

{ #category : #'code generation' }
SWTranspiler >> assign: key with: value [
	self put: key; put: ' = '.
	value transpileUsing: self.

]

{ #category : #accessing }
SWTranspiler >> classes [
	^ classes ifNil: [ classes := OrderedCollection new ]
]

{ #category : #accessing }
SWTranspiler >> classes: anArray [
	classes := anArray.

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
	self reset.

]

{ #category : #accessing }
SWTranspiler >> mainClass [
	^ mainClass ifNil: [
		mainClass := self classes detect: [ :aClass |
			(aClass compiledMethodAt: #main: ifAbsent: [ nil ]) isNotNil
		] ifFound: [ :aClass | aClass ] ifNone: [ nil ]
	]
]

{ #category : #accessing }
SWTranspiler >> newline [

	^ newline
]

{ #category : #accessing }
SWTranspiler >> newline: anObject [

	newline := anObject
]

{ #category : #'as yet unclassified' }
SWTranspiler >> opEqual_for: receiver with: arguments [
	self
		transpile: receiver;
		put: ' == ';
		putArgumentsOf: '=' with: arguments
]

{ #category : #'code generation - protected' }
SWTranspiler >> popMessageNest [
	messageNest pop
]

{ #category : #'code generation - protected' }
SWTranspiler >> preventNewline [
	preventNewline := true
]

{ #category : #accessing }
SWTranspiler >> programName [ 
	^ (self mainClass respondsTo: #programName) ifTrue: [
		self mainClass programName
	] ifFalse: [
		self mainClass name
	]

]

{ #category : #'code generation - protected' }
SWTranspiler >> pushMessageNest [
	messageNest push: 0
]

{ #category : #'code generation' }
SWTranspiler >> put: code [
	self putIndent.
	stream nextPutAll: code.
]

{ #category : #'code generation' }
SWTranspiler >> putArgumentsOf: selector with: artuments [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putArray: anArray [
	anArray do: [:each |
		each transpileUsing: self.
	] separatedBy: [
		self put: ', '
	]

]

{ #category : #'code generation' }
SWTranspiler >> putArrayFooter [
	self put: ' ]'
]

{ #category : #'code generation' }
SWTranspiler >> putArrayHeader [
	self put: '[ '.
]

{ #category : #'code generation' }
SWTranspiler >> putArrayLiteral: anArray [
	self
		put: '[ ';
		putArray: anArray;
		put: ' ]'.
	^ anArray
]

{ #category : #'code generation' }
SWTranspiler >> putClassDefinition: aClass [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWTranspiler >> putCode: code [
	^ self putCode: code with: {  }
]

{ #category : #'code generation' }
SWTranspiler >> putCode: code with: anAssociationArray [
	"when a line in code ends with $\, the line continues to the next."
	|leftPad|
	leftPad := 0.
	code trimLeft: [ :c |
		c = Character tab ifTrue: [ leftPad := leftPad + 1 ].
		c isSeparator or: [ c = $\ ]
	].
	(({ code }, anAssociationArray) reduce: [ :acc :assoc|
		acc copyReplaceAll: assoc key with: assoc value asString
	]) linesDo: [ :aLine ||rTrimmed preventsNewline trimmed counter|
		preventsNewline := aLine isEmpty or: [aLine last = $\].
		rTrimmed := aLine trimRight: [:c | c isSeparator or: [c = $\]].
		counter := 0.
		trimmed := rTrimmed trimLeft: [ :c |
			counter := counter + 1.
			c isSeparator and: [ counter <= leftPad ]
		].
		preventsNewline ifTrue: [
			trimmed ifNotEmpty: [self put: trimmed ]
		] ifFalse: [
			self putLine: trimmed.
		]
	]
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
SWTranspiler >> putFunctionCallFooterOf: selector [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putFunctionCallHeaderOf: selector [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putFunctionCallOf: selector with: arguments [
	self
		putFunctionCallHeaderOf: selector;
		putArgumentsOf: selector with: arguments;
		putFunctionCallFooterOf: selector
]

{ #category : #'code generation' }
SWTranspiler >> putFunctionDefinitionFooterOf: aMethodName [.
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putFunctionDefinitionHeaderOf: aMethodName [
	^ self subclassResponsibility 
]

{ #category : #'code generation - protected' }
SWTranspiler >> putIndent [
	isNewline ifFalse: [ ^ self ].
	stream nextPutAll: (' ' repeat: {0. (self tabWidth * indent)} max).
	isNewline := false.

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
SWTranspiler >> putMainProgram [
	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putMessage: receiver call: selector with: arguments [
	self flag: #toImplement.
	self incMessageNest.
	[ |transpiledName|
		transpiledName := ((self class transpiledNameOf: selector), 'for:with:') asSymbol.
		(self respondsTo: transpiledName) ifTrue: [
			^ self perform: transpiledName with: receiver with: arguments
		].

		receiver transpileUsing: self.
		(selector first isLetter) ifTrue: [ self put: '.' ].
		self putFunctionCallOf: (self class transpiledNameOf: selector) with: arguments.
	] ensure: [ self decMessageNest ].

]

{ #category : #'code generation' }
SWTranspiler >> putMethod: selector ofClass: class [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putParameters: anArray [
	anArray do: [:each |
		self put: each asString
	] separatedBy: [
		self put: ', '
	]

]

{ #category : #'code generation' }
SWTranspiler >> putRequirements [
	|sel|
	sel := (self type, '_requirements') asSymbol.
	self classes do: [:aClass |
		(aClass respondsTo: sel) ifTrue: [
			(aClass perform: sel) do: [ :header |
				self putCode: header
			]
		]
	]

]

{ #category : #'code generation' }
SWTranspiler >> putString: aString [
	self
		put: '"';
		put: aString;
		put: '"'.
]

{ #category : #'as yet unclassified' }
SWTranspiler >> putSymbol: aSymbol [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWTranspiler >> readStream [
	^ stream readStream
]

{ #category : #initialization }
SWTranspiler >> reset [
	stream resetToStart.
	isNewline := false.
	preventNewline := false.
	messageNest := Stack new push: 0; yourself.
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
	self putFileHeaderOf: self programName.
	self putRequirements.
	self classes do: [ :aClass |
		self putClassDefinition: aClass
	].
	self mainClass ifNotNil: [
		self putMainProgram
	].
]

{ #category : #execution }
SWTranspiler >> transpile: anObject [
	^ anObject transpileUsing: self
]

{ #category : #'code generation - protected' }
SWTranspiler >> transpiledNameOf: aMethod [
	^ (String streamContents: [ :s |
		s
			<< self type;
			<< '_';
			<< (self class transpiledNameOf: aMethod selector);
			<< 'using:'
	]) asSymbol.

]

{ #category : #accessing }
SWTranspiler >> type [

	^ type
]

{ #category : #accessing }
SWTranspiler >> type: anObject [

	type := anObject
]
