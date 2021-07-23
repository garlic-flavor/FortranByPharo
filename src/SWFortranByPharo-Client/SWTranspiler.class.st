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
		'indentShifter',
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

{ #category : #initialization }
SWTranspiler class >> resetSelectorName [
	<script>
	selectorName := nil.
]

{ #category : #'as yet unclassified' }
SWTranspiler class >> selectorName [
	^ selectorName ifNil: [
		selectorName := Dictionary new
			at: '+' put: 'opAdd_';
			at: '-' put: 'opSub_';
			at: '*' put: 'opMul_';
			at: '/' put: 'opDiv_';
			at: '%' put: 'opRem_';
			at: '**' put: 'opPow_';
			yourself
	]
]

{ #category : #'as yet unclassified' }
SWTranspiler class >> selectorNameOf: selector [
	^ self selectorName at: selector ifAbsent: [|sel|
		sel := selector asString copyReplaceAll: ':' with: '_'.
		sel last = $_ ifTrue: [ sel ] ifFalse: [ sel, '_' ]
	]
]

{ #category : #'code generation - protected' }
SWTranspiler class >> transpiledNameOf: selector [
	^ selector asString copyReplaceAll: ':' with: '_'
	
]

{ #category : #'as yet unclassified' }
SWTranspiler >> addClass: aClass [
	self classes add: aClass
]

{ #category : #'as yet unclassified' }
SWTranspiler >> addMainClass: aClass [
	self addClass: aClass.
	mainClass := aClass.
]

{ #category : #'code generation' }
SWTranspiler >> assign: key with: value [
	self put: key; put: ' = '.
	^ self variables at: key put: (value transpileUsing: self).

]

{ #category : #accessing }
SWTranspiler >> classes [
	^ classes ifNil: [ classes := OrderedCollection new ]
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
	|nest|
	messageNest := {0. messageNest - 1} max.
	0 < messageNest ifTrue: [ self put: ')' ].

]

{ #category : #'code generation - protected' }
SWTranspiler >> enterBlock [
	self incIndent.

]

{ #category : #'code generation' }
SWTranspiler >> getVariable: name [
	^ self variables at: name ifAbsent: [ nil ]

]

{ #category : #'code generation - protected' }
SWTranspiler >> incIndent [
	indent := indent + 1.
]

{ #category : #'code generation - protected' }
SWTranspiler >> incMessageNest [
	messageNest := messageNest + 1.
	1 < messageNest ifTrue: [ self put: '(' ].
]

{ #category : #'code generation - protected' }
SWTranspiler >> indentShifter [

	^ indentShifter
]

{ #category : #'code generation - protected' }
SWTranspiler >> indentShifter: anObject [

	indentShifter := anObject
]

{ #category : #initialization }
SWTranspiler >> initialize [
	super initialize.
	stream := String new writeStream.
	indent := 0.
	indentShifter := 0.
	tabWidth := 4.
	isNewline := false.
	newline := String crlf.
	preventNewline := false.
	messageNest := 0.
]

{ #category : #'code generation - protected' }
SWTranspiler >> leaveBlock [
	self decIndent.

]

{ #category : #accessing }
SWTranspiler >> mainClass [
	^ mainClass
]

{ #category : #'code generation' }
SWTranspiler >> newline [

	^ newline
]

{ #category : #'code generation' }
SWTranspiler >> newline: anObject [

	newline := anObject
]

{ #category : #'code generation - protected' }
SWTranspiler >> preventNewline [
	preventNewline := true
]

{ #category : #accessing }
SWTranspiler >> programName [ 
	^ self source programName

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

{ #category : #'as yet unclassified' }
SWTranspiler >> putArrayLiteral: anArray [
	self
		put: '[ ';
		putArray: anArray;
		put: ' ]'.
	^ anArray
]

{ #category : #'as yet unclassified' }
SWTranspiler >> putClassDefinition: aClass [
	|decls|
	self put: 'class '.
	self put: aClass name.
	(aClass superclass = Object) ifFalse: [
		self put: ' < '; put: aClass superclass name
	].
	self putLine.
	self incIndent.
	
	aClass methods do: [ :aMethod |
		(aClass declarations anySatisfy: [:each | each = aMethod selector]) ifTrue: [
			self putMethod: aMethod ofClass: aClass
		]
	].

	self flag: #toImplement.

	self decIndent.
	self putLine: 'end'.
]

{ #category : #accessing }
SWTranspiler >> putCode: code [
	^ self putCode: code with: {  }
]

{ #category : #'code generation' }
SWTranspiler >> putCode: code with: anAssociationArray [
	|leftPad lTrimmed|
	leftPad := 0.
	lTrimmed := code trimLeft: [ :c |
		c isSeparator ifTrue: [ leftPad := leftPad + 1 ].
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
SWTranspiler >> putFileFooterOf: filename [
]

{ #category : #'code generation' }
SWTranspiler >> putFileHeaderOf: filename [
	
	
]

{ #category : #'code generation' }
SWTranspiler >> putFileHeaders [
	|sel|
	sel := (self type, '_fileHeaders') asSymbol.
	(self source respondsTo: sel) ifTrue: [
		(self source perform: sel) do: [ :header |
			self putCode: header
		]
	]

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
	stream nextPutAll: (' ' repeat: {0. (self tabWidth * (indent + indentShifter))} max).
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
SWTranspiler >> putMainProgramFooterOf: project [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putMainProgramHeaderOf: project [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWTranspiler >> putMessage: receiver call: selector with: arguments [
	self flag: #toImplement.
	self incMessageNest.
	[
		receiver transpileUsing: self.
		(selector first isLetter) ifTrue: [ self put: '.' ].
		self putFunctionCallOf: (self class transpiledNameOf: selector) with: arguments.
"
		var := receiver transpileUsing: self.
		self assert: [var isNotNil].
		sel := self transformSelector: selector.
		(var respondsTo: sel) ifTrue: [
			^ var perform: sel with: arguments with: self.
		].
		var = self source ifTrue: [ |funcname func|
				funcname := self class selectorNameOf: selector.
				func := self variables at: funcname ifAbsent: [ nil ].
				func ifNotNil: [
					^ func value: arguments value: self.
				]
		].
"
		
	] ensure: [ self decMessageNest ].

]

{ #category : #'as yet unclassified' }
SWTranspiler >> putMethod: aMethod ofClass: aClass [
	|sel|
	self
		put: 'def ';
		put: (self class transpiledNameOf: aMethod selector);
		put: '('.
	aMethod argumentNames do: [ :aName |
		self put: aName asString
	] separatedBy: [
		self put: ', '
	].
	self putLine: ')'.
	sel := self transpilerNameFor: aMethod.
	(aClass respondsTo: sel) ifTrue: [
		self incIndent.
		aClass perform: sel with: self.
		self decIndent.
	] ifFalse: [
		aMethod transpileUsing: self.
	].
	self putLine: 'end'.
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
SWTranspiler >> putString: aString [
	self
		put: '"';
		put: aString;
		put: '"'.
]

{ #category : #'as yet unclassified' }
SWTranspiler >> putVariable: aVariable named: name [
	aVariable ifNil: [
		self preventNewline.
		^ aVariable
	].
	(aVariable class inheritsFrom: SWProjectSource) ifTrue: [ 
		^ aVariable
	].
	self put: name.
	^ aVariable
]

{ #category : #accessing }
SWTranspiler >> readStream [
	^ stream readStream
]

{ #category : #initialization }
SWTranspiler >> reset [
	stream resetToStart.
	self variables: nil.
	preventNewline := false.
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

	^ tabWidth
]

{ #category : #accessing }
SWTranspiler >> tabWidth: anObject [

	tabWidth := anObject
]

{ #category : #'as yet unclassified' }
SWTranspiler >> transformSelector: aSelector [
	^ (String streamContents: [ :s |
		s << self type; << '_'; << (self class selectorNameOf: aSelector); << 'with:using:'
	]) asSymbol.

]

{ #category : #'public API' }
SWTranspiler >> transpile [
	^ self subclassResponsibility		
]

{ #category : #'code generation' }
SWTranspiler >> transpileDeclaredFunctions [
	self source functionDeclarations do: [ :each |
		self transpileFunctionDefinition: each
	]
]

{ #category : #'code generation' }
SWTranspiler >> transpileFunctionDefinition: aMethodName [
	self putFunctionDefinitionHeaderOf: aMethodName.
	self transpileMethod: aMethodName.
	self putFunctionDefinitionFooterOf: aMethodName.	
	
]

{ #category : #'code generation' }
SWTranspiler >> transpileMethod: aMethod [
	(self source class >> aMethod) transpileUsing: self.

]

{ #category : #'code generation' }
SWTranspiler >> transpileProgram [
	self putMainProgramHeaderOf: self programName.
	self transpileMethod: #program.
	self putMainProgramFooterOf: self programName.

]

{ #category : #'as yet unclassified' }
SWTranspiler >> transpilerNameFor: aMethod [
	^ (String streamContents: [ :s |
		s
			<< self type;
			<< '_';
			<< (self class transpiledNameOf: aMethod selector);
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
