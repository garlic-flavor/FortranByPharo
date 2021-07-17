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
		'isNewline',
		'variables',
		'newline',
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
			at: '*' put: 'opMul_';
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

{ #category : #'code generation' }
SWTranspiler >> assign: key with: value [
	self variables at: key put: value value.
	self put: key; put: ' = '.
	^ value transpileUsing: self.
]

{ #category : #accessing }
SWTranspiler >> contents [
	^ stream contents
]

{ #category : #'code generation' }
SWTranspiler >> decIndent [
	indent := indent - 1.
	indent < 0 ifTrue: [ self error: 'Indentation clauses mismatch.' ]
]

{ #category : #accessing }
SWTranspiler >> decMessageNest [

	messageNest := {messageNest - 1. 0} max.
	0 < messageNest ifTrue: [ self put: ')' ]
]

{ #category : #'code generation' }
SWTranspiler >> enterBlock [
	self incIndent.
	self variables push.
]

{ #category : #'code generation' }
SWTranspiler >> getVariable: name [
	^ self variables at: name ifAbsent: [ nil ]

]

{ #category : #'code generation' }
SWTranspiler >> incIndent [
	indent := indent + 1.
]

{ #category : #'as yet unclassified' }
SWTranspiler >> incMessageNest [
	messageNest := messageNest + 1.
	1 < messageNest ifTrue: [ self put: '(' ].
]

{ #category : #accessing }
SWTranspiler >> indentShifter [

	^ indentShifter
]

{ #category : #accessing }
SWTranspiler >> indentShifter: anObject [

	indentShifter := anObject
]

{ #category : #initialization }
SWTranspiler >> initialize [
	super initialize.
	stream := ReadWriteStream on: String new.
	indent := 0.
	indentShifter := 0.
	isNewline := true.
	newline := String cr, String lf.
	messageNest := 0.
]

{ #category : #'code generation' }
SWTranspiler >> leaveBlock [
	self decIndent.
	self variables pop.
]

{ #category : #accessing }
SWTranspiler >> newline [

	^ newline
]

{ #category : #accessing }
SWTranspiler >> newline: anObject [

	newline := anObject
]

{ #category : #accessing }
SWTranspiler >> programName [ 
	self assert: (self source isNotNil).
	^ (self source respondsTo: #programName) ifTrue: [
		self source programName.
	] ifFalse: [ 
		self source class asString.
	]
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
SWTranspiler >> putIndent [
	isNewline ifFalse: [ ^ self ].
	stream nextPutAll: (' ' repeat: {0. (4 * (indent + indentShifter))} max).
	isNewline := false.

]

{ #category : #'code generation' }
SWTranspiler >> putLine [
	stream << newline.
	isNewline := true.
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
	indentShifter := -1
]

{ #category : #'code generation' }
SWTranspiler >> putMessage: receiver call: selector with: arguments [
	|var sel|
	self flag: #toImplement.
	self incMessageNest.
	var := receiver transpileUsing: self.
	self assert: [var isNotNil].
	sel := self transformSelector: selector.
	(var respondsTo: sel) ifTrue: [|res|
		res := var perform: sel with: arguments with: self.
		self decMessageNest.
		^ res
	] ifFalse: [
		self error: 'NO IMPLEMENTATION.'
	].

]

{ #category : #'as yet unclassified' }
SWTranspiler >> putVariable: aVariable named: name [
	aVariable ifNil: [ ^ aVariable ].
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
	messageNest := 0.
	self variables: nil.
]

{ #category : #accessing }
SWTranspiler >> source [

	^ source
]

{ #category : #accessing }
SWTranspiler >> source: anObject [

	source := anObject
]

{ #category : #'as yet unclassified' }
SWTranspiler >> transformSelector: aSelector [
	^ (String streamContents: [ :s |
		s << self type; << '_'; << (self class selectorNameOf: aSelector); << 'with:using:'
	]) asSymbol.

]

{ #category : #'as yet unclassified' }
SWTranspiler >> transpileMethod: aMethod [
	|res|
	self variables push.
	res := (self source class >> aMethod) transpileUsing: self.
	self variables pop.
	^ res
]

{ #category : #'public API' }
SWTranspiler >> transpileProgram [
	|res|
	self putMainProgramHeaderOf: self programName.
	res := self transpileMethod: #program.
	self putMainProgramFooterOf: self programName.
	^ res
]

{ #category : #accessing }
SWTranspiler >> type [

	^ type
]

{ #category : #accessing }
SWTranspiler >> type: anObject [

	type := anObject
]

{ #category : #accessing }
SWTranspiler >> variables [

	^ variables ifNil: [
		variables := VariableStack new
			at: #self put: self source;
			yourself
	]
]

{ #category : #accessing }
SWTranspiler >> variables: aObject [
	variables := aObject
]
