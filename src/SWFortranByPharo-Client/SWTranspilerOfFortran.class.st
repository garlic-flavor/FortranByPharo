"
This transpile Pharo to Fortran.
"
Class {
	#name : #SWTranspilerOfFortran,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

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

{ #category : #'code generation' }
SWTranspilerOfFortran >> putMessage: receiver call: selector with: arguments [
	|receiverClass|
	((receiverClass := self getClassInside: receiver) isNotNil and: [ receiverClass = self source programClass ]) ifTrue: [|selectorName|
		selectorName := (self class transpiledSelectorNameOf: selector) asSymbol.
		^ self
			pushMessageNest;
			put: 'call ';
			putFunctionCallOf: selectorName with: arguments;
			popMessageNest
	].
	^ super putMessage: receiver call: selector with: arguments
]

{ #category : #'public API' }
SWTranspilerOfFortran >> putProgram: aClass [
	self logger log.
	self
		incIndent;
		putLine: 'implicit none';
		decIndent;
		putSequence: (aClass class methodDictionary at: #program) sourceNode body
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putSequence: aSequence [
	self logger log.
	self incIndent.
	aSequence children do: [ :child |
		(child class = RBVariableNode) ifFalse: [
			self
				transpile: child;
				putLine
		]
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
SWTranspilerOfFortran >> putSubprogram: aMethod ofClass: aClass [
	|sel|
	self logger log.
	sel := self class transpiledSelectorNameOf: aMethod selector.
	self
		putComment: aMethod comment;
		put: 'subroutine ';
		put: sel;
		put: '(';
		put: (', ' join: (aMethod argumentNames collect: [:each | each asString]));
		putLine: ')';
		putSequence: aMethod sourceNode body;
		put: 'end subroutine ';
		putLine: sel.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran >> putSubprograms: aClass [
	self logger log.
	self incIndent.
	aClass class methods select: [:aMethod |
		(aMethod protocol beginsWith: 'code generation') not and: [ aMethod selector ~= #program ]
	] thenDo: [ :aMethod |
		self putSubprogram: aMethod ofClass: aClass.
	].
	self decIndent.
]

{ #category : #'public API' }
SWTranspilerOfFortran >> transpile [
	|programClass|
	self putFileHeaderOf: self source moduleName.
	self putRequirements.
	self source classes do: [ :aClass |
		self putClassDefinition: aClass
	].

	(programClass := self source programClass) ifNotNil: [
		self
			putComment: programClass comment;
			put: 'program ';
			putLine: self source moduleName;
			putProgram: programClass;
			putLine: 'contains';
			putSubprograms: programClass;
			put: 'end program ';
			putLine: self source moduleName
	].

]
