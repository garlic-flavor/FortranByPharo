"
This transpile Pharo to Fortran.
"
Class {
	#name : #SWTranspilerOfFortran,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran class >> typeNameFor: aClass [
	aClass = Integer ifTrue: [
		^ #integer
	].
	aClass = Float ifTrue: [
		^ #'double precision'
	].
	self halt.
]

{ #category : #accessing }
SWTranspilerOfFortran >> analyzer [
	^ analyzer ifNil: [ analyzer := SWAnalyzer new ]
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> assign: key with: value [
	self analyzer variables at: key name ifPresent: [:vi |
		vi initialValue ifNotNil: [ self preventNewline. ^ self ].
		(value transpileUsing: self analyzer) = SWVariableInfo class ifTrue: [ self preventNewline. ^ self ]
	].
	super assign: key with: value.

]

{ #category : #initialization }
SWTranspilerOfFortran >> initialize [
	super initialize. 
	self type: #f90.
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putArgumentsOf: selector with: arguments [
	self logger log.
	self
		put: '(';
		putArray: arguments;
		put: ')'

]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putClassAccessor [
	self put: '_'
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putClassDefinition: aClass [
	self logger log.
	
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putComment: comment [
	self logger log.
	comment ifNotNil: [
		comment linesDo: [ :aLine |
			self
				put: '! ';
				putLine: aLine
		]
	]
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putFileFooterOf: aModuleName [
	self
		put: 'end program ';
		putLine: aModuleName
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putFileHeaderOf: aModuleName [
	self
		putComment: self source programClass comment;
		put: 'program ';
		putLine: aModuleName;
		incIndent;
		putLine: 'implicit none';
		decIndent.
]

{ #category : #'public API' }
SWTranspilerOfFortran >> putMethod: methodInfo [
	|uniqueTranspiler|
	self logger log.
	self incIndent.
	methodInfo variables values select: [ :val | val name ~= #self ] thenDo: [ :val |
		self putVariableDeclarationOf: val
	].
	uniqueTranspiler := self methodBodyGeneratorNameOf: (methodInfo owner methodDictionary at: methodInfo name).
	(methodInfo owner respondsTo: uniqueTranspiler) ifTrue: [
		methodInfo owner perform: uniqueTranspiler with: self.
	] ifFalse: [
		(methodInfo owner methodDictionary at: methodInfo name) sourceNode body statements do: [ :each |
			self
				transpile: each;
				putLine
		]
	].
	self decIndent

]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putOrdinaryMessage: receiver call: selector with: arguments [
	| receiverClass mangledName argumentTypes methodInfo selectorName |
	self logger log.
	selectorName := self class safeSelectorNameOf: selector.
	receiverClass := receiver transpileUsing: self analyzer.
	argumentTypes := arguments collect: [ :each | 
                 each transpileUsing: self analyzer
	].
	mangledName := self analyzer class mangledNameOf: receiverClass s: selector with: argumentTypes.
	methodInfo := self analyzer methods at: mangledName ifAbsent: [
		SWMethodInfo new
			mangledName: selector;
			yourself.
	].
	methodInfo hasReturn
		ifTrue: [
			self flag: #ToImplement
		] ifFalse: [ 
			self
				put: 'call ';
				put: (self class safeSelectorNameOf: mangledName);
				pushMessageNest;
				putArgumentsOf: selector with: arguments;
				popMessageNest
		]

]

{ #category : #'public API' }
SWTranspilerOfFortran >> putProgram: programClass [
	|methodInfo|
	methodInfo := self analyzer analyze: programClass class s: #program with: #().
	self
		putMethod: methodInfo;
		putLine: 'contains';
		putSubprograms: analyzer methods

]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putSequence: aSequence [
	self logger log.
	self incIndent.
	aSequence statements do: [ :child |
		self
			transpile: child;
			putLine
	].
	self decIndent
]

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran >> putString: aString [
	self
		put: '''';
		put: aString;
		put: ''''.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran >> putSubprograms: methods [
	self logger log.
	self incIndent.
	methods valuesDo: [ :methodInfo ||method methodName methodType|
		method := methodInfo owner >> methodInfo name.
		methodName := self class safeSelectorNameOf: methodInfo mangledName.
		methodType := methodInfo hasReturn ifTrue: [ 
			'function '.
		] ifFalse: [
			 'subroutine '.
		].
		self
			put: methodType;
			put: methodName;
			put: '(';
			putArray: method argumentNames;
			putLine: ')'.
		self analyzer variables: methodInfo variables.
		self putMethod: methodInfo.
		self
			put: 'end ';
			put: methodType;
			putLine: methodName
	].
	self decIndent.
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putSymbol: aSymbol [
	self put: aSymbol asString.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran >> putVariableDeclarationOf: aVariableInfo [
	self put:  ( self class typeNameFor: aVariableInfo type).
	(aVariableInfo const and: [ aVariableInfo initialValue isNotNil ]) ifTrue: [
		self put: ', parameter'
	].
	self
		put: ' :: ';
		put: aVariableInfo name.
	aVariableInfo initialValue ifNotNil: [
		self
			put: ' = ';
			putLine: aVariableInfo initialValue asString
	] ifNil: [
		self putLine
	]

]
