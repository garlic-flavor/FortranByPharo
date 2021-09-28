"
I transpile SWProject.
"
Class {
	#name : #SWTranspiler,
	#superclass : #Object,
	#instVars : [
		'type',
		'source',
		'stream',
		'indent',
		'tabWidth',
		'isNewline',
		'newline',
		'preventNewline',
		'messageNest',
		'pool',
		'logger'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation - protected' }
SWTranspiler class >> transpiledSelectorNameOf: selector [
	selector = '=' ifTrue: [ ^ 'opEqual_' ].
	selector = '~=' ifTrue: [ ^ 'opNotEqual_' ].
	selector = ',' ifTrue: [ ^ 'opCamma_' ].
	selector = '->' ifTrue: [ ^ 'opArrow_' ].
	^ selector asString copyReplaceAll: ':' with: '_'
	
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
SWTranspiler >> logger [
	^ logger ifNil: [ logger := SWLogger new ]
]

{ #category : #accessing }
SWTranspiler >> logging: trueOrFalse [
	self logger enabled: trueOrFalse
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

	^ pool ifNil: [ pool := SWSourcesPool default ]
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
SWTranspiler >> putArgumentsOf: selector with: artuments [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putArray: anArray [
	self logger log.
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
	self logger log.
	self
		put: '[ ';
		putArray: anArray;
		put: ' ]'.
	^ anArray
]

{ #category : #'code generation' }
SWTranspiler >> putBlock: aBlock [
	^ self subclassResponsibility 
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
SWTranspiler >> putFunctionCallOf: selector with: arguments [
	^ self subclassResponsibility

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
	self logger log: [receiver asString, '>>', selector asString].
	self incMessageNest.
	[ |selectorName uniqueSelector|
		selectorName := (self class transpiledSelectorNameOf: selector) asSymbol.
		uniqueSelector := selectorName, 'For:With:'.
		(self respondsTo: uniqueSelector) ifTrue: [
			^ self perform: uniqueSelector with: receiver with: arguments
		].
		receiver transpileUsing: self.
		(selectorName first isLetter) ifTrue: [ self put: '.' ].
		self putFunctionCallOf: selectorName with: arguments.
	] ensure: [ self decMessageNest ].

]

{ #category : #'code generation' }
SWTranspiler >> putMethod: selector ofClass: class [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putNil [
	^ self subclassResponsibility
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
SWTranspiler >> putTestRunner [
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
	self putFileHeaderOf: self source moduleName.
	self putRequirements.
	self source classes do: [ :aClass |
		self putClassDefinition: aClass
	].
	self source entryClass ifNotNil: [
		self putMainProgram
	] ifNil: [ 
		(self source mainClass inheritsFrom: TestCase) ifTrue: [
			self putTestRunner
		]
	]
]

{ #category : #'code generation' }
SWTranspiler >> transpile: anObject [
	self logger log.
	^ anObject transpileUsing: self
]

{ #category : #'code generation - protected' }
SWTranspiler >> transpilerNameOf: aMethod [
	^ (String streamContents: [ :s |
		s
			<< self type;
			<< '_';
			<< (self class transpiledSelectorNameOf: aMethod selector);
			<< 'Using:'
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
