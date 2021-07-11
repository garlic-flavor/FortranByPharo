"
I transpile SWProject.
"
Class {
	#name : #SWTranspiler,
	#superclass : #Object,
	#instVars : [
		'type',
		'stream',
		'indent',
		'indentShifter',
		'isNewline',
		'variables',
		'newline'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #compiling }
SWTranspiler class >> transpile: source [
	source type = #f90 ifTrue: [ 
		^ (SWTranspilerOfFortran new) type: source type; transpileProgram: source.
	].
	source type = #rb ifTrue: [
		^ (SWTranspilerOfRuby new) type: source type; transpileProgram: source.
	].
	self error: 'not implemented yet for transpiling.'.
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

{ #category : #copying }
SWTranspiler >> duplicate [
	^ self class new variables: self variables copy.
]

{ #category : #'code generation' }
SWTranspiler >> enterBlock [
	self incIndent
]

{ #category : #'code generation' }
SWTranspiler >> incIndent [
	indent := indent + 1.
]

{ #category : #initialization }
SWTranspiler >> initialize [
	super initialize.
	stream := ReadWriteStream on: String new.
	indent := 0.
	indentShifter := 0.
	isNewline := true.
	newline := String cr, String lf.
]

{ #category : #'code generation' }
SWTranspiler >> leaveBlock [
	self decIndent
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
	^ self subclassResponsibility 
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
	self flag: #TODO. "Under construction"
	(receiver name at: 1) isUppercase ifTrue: [
		|r|
		r := Smalltalk globals at: receiver name asSymbol.
		r transpile: selector with: arguments using: self.
		^ self
	].

	var := self variables at: receiver name ifAbsent: [ 
		^ self error: 'no variables.'
	].
	sel := String streamContents: [ :s |
		s << self type; << '_'; << (selector asString copyReplaceAll: ':' with: '_'); << 'with:using:'
	].
	(var respondsTo: sel) ifTrue: [
		var perform: sel with: arguments with: self.
	] ifFalse: [
		^ self error: 'no implementation.'
	]

]

{ #category : #accessing }
SWTranspiler >> readStream [
	^ stream readStream
]

{ #category : #'public API' }
SWTranspiler >> transpileProgram: source [
	| programName|
	programName := (source respondsTo: #programName) ifTrue: [
		source programName.
	] ifFalse: [ 
		source class asString.
	].
	self variables at: #self put: source.

	self putMainProgramHeaderOf: programName.
	(source class>>#program) transpileUsing: self.
	self putMainProgramFooterOf: programName.

]

{ #category : #'public API' }
SWTranspiler >> transpiledOf: aObject [
	aObject transpileUsing: self.
	^ self contents
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

	^ variables ifNil: [ variables := Dictionary new ]
]

{ #category : #accessing }
SWTranspiler >> variables: aObject [
	variables := aObject
]
