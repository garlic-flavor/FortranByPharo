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

{ #category : #'code generation - protected' }
SWTranspiler class >> transpiledNameOf: selector [
	^ selector asString copyReplaceAll: ':' with: '_'
	
]

{ #category : #'code generation' }
SWTranspiler >> assign: key with: value [
	self put: key; put: ' = '.
	^ self variables at: key put: (value transpileUsing: self).

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
SWTranspiler >> putClass: aClass [
	self put: 'class '.
	self put: aClass name.
	(aClass superclass = Object) ifFalse: [
		self put: ' > '; put: aClass superclass name
	].
	self putLine.
	self incIndent.

	aClass methods do: [ :aMethod |
		self putMethod: aMethod ofClass: aClass
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
	|leftPad|
	leftPad := -1.
	(({ code. ('\', String crlf) -> ''. ('\', String cr) -> ''. ('\', String lf) -> '' }, anAssociationArray) reduce: [ :acc :assoc|
		acc copyReplaceAll: assoc key with: assoc value asString
	]) linesDo: [ :aLine ||rTrimmed trimmed|
		rTrimmed := aLine trimRight.
		leftPad < 0 ifTrue: [
			trimmed := rTrimmed trimLeft.
			leftPad := rTrimmed size - trimmed size.
		] ifFalse: [ |counter|
			counter := 0.
			trimmed := rTrimmed trimLeft: [ :c |
				counter := counter + 1.
				c isSeparator and: [ counter <= leftPad ]
			]
		].
		self putLine: trimmed.
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
	aMethod transpileUsing: self.
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

{ #category : #accessing }
SWTranspiler >> type [

	^ type
]

{ #category : #accessing }
SWTranspiler >> type: anObject [

	type := anObject
]
