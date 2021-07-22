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
		'preventNewline'
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
			at: #+ put: 'opAdd_';
			at: #- put: 'opSub_';
			at: #* put: 'opMul_';
			at: #/ put: 'opDiv_';
			at: #% put: 'opRem_';
			at: #** put: 'opPow_';
			at: #, put: 'opConcat_';
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
	nest := self variables at: '%messageNest%' put: {(self variables at: '%messageNest%' ifAbsentPut: 0) - 1. 0} max.
	0 < nest ifTrue: [ self put: ')' ].

]

{ #category : #'code generation - protected' }
SWTranspiler >> enterBlock [
	self incIndent.
	self variables push.
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
	|nest|
	nest := self variables at: '%messageNest%' put: (self variables at: '%messageNest%' ifAbsentPut: 0) + 1.
	1 < nest ifTrue: [ self put: '(' ].
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
	stream := ReadWriteStream on: String new.
	indent := 0.
	indentShifter := 0.
	isNewline := true.
	newline := String cr, String lf.
	preventNewline := false.
]

{ #category : #'code generation - protected' }
SWTranspiler >> leaveBlock [
	self decIndent.
	self variables pop.
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
SWTranspiler >> putArrayFooter [
	self put: ' ]'
]

{ #category : #'code generation' }
SWTranspiler >> putArrayHeader [
	self put: '[ '.
]

{ #category : #accessing }
SWTranspiler >> putCode: code [
	^ self putCode: code with: {  }
]

{ #category : #'code generation' }
SWTranspiler >> putCode: code with: anAssociationArray [
	(({ code }, anAssociationArray) reduce: [ :acc :assoc|
		acc copyReplaceAll: assoc key with: assoc value
	]) linesDo: [ :aLine ||trimmed|
		trimmed := aLine trimBoth.
		(trimmed endsWith: '\') ifTrue: [
			self put: (trimmed trimRight: [ :c | c = $\ ])
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
	stream nextPutAll: (' ' repeat: {0. (4 * (indent + indentShifter))} max).
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
	indentShifter := -1
]

{ #category : #'code generation' }
SWTranspiler >> putMessage: receiver call: selector with: arguments [
	|var sel|
	self flag: #toImplement.
	self incMessageNest.
	[
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
		self error: 'NO IMPLEMENTATION.'
	] ensure: [ self decMessageNest ].

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

{ #category : #'code generation' }
SWTranspiler >> putVariable: aVariable named: name [
	name first isUppercase ifTrue: [ 
		^ Smalltalk globals at: name
	].
	aVariable ifNil: [
		self preventNewline.
		^ aVariable
	].
	(aVariable class inheritsFrom: SWSource) ifTrue: [ 
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

{ #category : #'code generation - protected' }
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
SWTranspiler >> transpileDeclaredFunction: dict [
		|symbol name ret argtype|
		symbol := dict at: #name.
		name := dict at: #transpiledName.
		argtype := dict at: #argtype ifAbsent: [ #position ].
		ret := self transpileFunctionDefinition: symbol.

		argtype = #position ifTrue: [
			^ [ :args :transpiler |
				transpiler putFunctionCallOf: name with: args.
				ret.
			]
		].
		argtype = #named ifTrue: [
			self error: 'no implementation'
		].
		argtype = #dict ifTrue: [ 
			self error: 'no implementation'
		]

]

{ #category : #'code generation' }
SWTranspiler >> transpileDeclaredFunctions [
	self source functionDeclarations do: [ :each ||dict name|
		dict := each isArray ifTrue: [
			Dictionary newFrom: each
		] ifFalse: [
			Dictionary new
				at: #name put: each;
				yourself
		].
		name := dict at: #transpiledName ifAbsentPut: [ self class selectorNameOf: (dict at: #name) ].
		(dict at: #foreign ifAbsent: [ false ]) ifTrue: [
			self variables at: name put: (dict at: #return ifAbsent: [nil])
		] ifFalse: [
			self variables at: name put: (self transpileDeclaredFunction: dict)
		]
	]
]

{ #category : #'code generation' }
SWTranspiler >> transpileFunctionDefinition: aMethodName [
	|res|
	self putFunctionDefinitionHeaderOf: aMethodName.
	res := self transpileMethod: aMethodName.
	self putFunctionDefinitionFooterOf: aMethodName.	
	^ res
	
]

{ #category : #'code generation' }
SWTranspiler >> transpileMethod: aMethod [
	|res|
	self variables push.
	res := (self source class >> aMethod) transpileUsing: self.
	res := variables at: '%returnValue%' ifAbsent: [ res ].
	self variables pop.
	^ res
]

{ #category : #'code generation' }
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
