"
This transpile Pharo to Fortran.
"
Class {
	#name : #SWTranspilerOfFortran,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWTranspilerOfFortran >> analyzer [
	^ analyzer ifNil: [ analyzer := SWAnalyzer new ]
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
SWTranspilerOfFortran >> putFunctionCallOf: selector with: arguments [
	self logger log.
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

{ #category : #'public API' }
SWTranspilerOfFortran >> putMethod: methodInfo [
	|uniqueTranspiler|
	self logger log.
	self incIndent.
	methodInfo variables keysAndValuesDo: [ :val :valType |
		val ~= #self ifTrue: [ 
			self
				put:  (valType typeIn: self type);
				put: ' ';
				putLine: val asString
		]
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
		putComment: programClass comment;
		put: 'program ';
		putLine: self source moduleName;
		incIndent;
		putLine: 'implicit none';
		decIndent;
		putMethod: methodInfo;
		putLine: 'contains';
		putSubprograms: analyzer methods;
		put: 'end program ';
		putLine: self source moduleName

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
