Class {
	#name : #SWTranspilerOfFortran,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran class >> typeNameFor: arg1 [

	arg1 = Integer ifTrue: [ ^ #integer ].
	arg1 = Float ifTrue: [ ^ #'double precision' ].
	(arg1 inheritsFrom: SWType) ifTrue: [ 
		^ (String streamContents: [ :arg2 | 
			   arg2
				   << 'type(';
				   << arg1 name;
				   << ')' ]) asSymbol ].
	^ #no_implementation
]

{ #category : #accessing }
SWTranspilerOfFortran >> analyzer [

	^ analyzer
		  ifNil: [ analyzer := SWAnalyzer new ]
		  ifNotNil: [ analyzer ]
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> assign: arg1 with: arg2 [

	self analyzer variables at: arg1 name ifPresent: [ :arg3 | 
		arg3 initialValue ifNotNil: [ 
			self preventNewline.
			^ self ].
		(arg2 transpileUsing: self analyzer) = SWVariableInfo class ifTrue: [ 
			self preventNewline.
			^ self ] ].
	super assign: arg1 with: arg2
]

{ #category : #initialization }
SWTranspilerOfFortran >> initialize [

	super initialize.
	self type: #f90
]

{ #category : #'instance creation' }
SWTranspilerOfFortran >> newWith_For: arg1 With: arg2 [

	self
		transpile: arg1;
		putArguments: arg2;
		putLine
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putArguments: arg1 [

	self logger log.
	self
		put: '(';
		putArray: arg1;
		put: ')'
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putArgumentsOf: arg1 with: arg2 [

	self logger log.
	self
		put: '(';
		putArray: arg2;
		put: ')'
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putClassAccessor [

	self put: '_'
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putClassDefinition: arg1 [

	| tmp1 |
	self logger log.
	(arg1 inheritsFrom: SWType) ifFalse: [ ^ self ].
	self
		incIndent;
		putComment: arg1 comment;
		put: 'type ';
		putLine: arg1 name;
		incIndent.
	tmp1 := (self analyzer subAnalyzer
		         analyze: arg1 >> #initialize
		         with: #(  )) variables.
	arg1 instanceVariables
		collect: [ :arg2 | tmp1 at: arg2 name ]
		thenDo: [ :arg3 | self putVariableDeclarationOf: arg3 ].
	self
		decIndent;
		put: 'end type ';
		putLine: arg1 name;
		decIndent
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putComment: arg1 [

	self logger log.
	arg1 ifNotNil: [ 
		arg1 linesDo: [ :arg2 | 
			self
				put: '! ';
				putLine: arg2 ] ]
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putFileFooterOf: arg1 [

	self
		put: 'end program ';
		putLine: arg1
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putFileHeaderOf: arg1 [

	self
		putComment: self source programClass comment;
		put: 'program ';
		putLine: arg1;
		incIndent;
		putLine: 'implicit none';
		decIndent
]

{ #category : #'public API' }
SWTranspilerOfFortran >> putMethod: arg1 [

	| tmp1 |
	self logger log.
	self incIndent.
	arg1 variables values
		select: [ :arg2 | arg2 name ~= #self ]
		thenDo: [ :arg3 | self putVariableDeclarationOf: arg3 ].
	tmp1 := self methodBodyGeneratorNameOf:
		        (arg1 owner methodDictionary at: arg1 name).
	(arg1 owner respondsTo: tmp1)
		ifTrue: [ arg1 owner perform: tmp1 with: self ]
		ifFalse: [ 
			(arg1 owner methodDictionary at: arg1 name) sourceNode body
				statements do: [ :arg4 | 
				self
					transpile: arg4;
					putLine ] ].
	self decIndent
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putOrdinaryMessage: arg1 send: arg2 with: arg3 [

	| tmp1 tmp2 tmp3 tmp4 tmp5 |
	self logger log.
	tmp5 := self class safeSelectorNameOf: arg2.
	tmp1 := arg1 transpileUsing: self analyzer.
	tmp3 := arg3 collect: [ :arg4 | arg4 transpileUsing: self analyzer ].
	tmp2 := self analyzer class mangledNameOf: tmp1 >> arg2 with: tmp3.
	tmp4 := self analyzer methods at: tmp2 ifAbsent: [ 
		        | tmp7 |
		        tmp7 := SWMethodInfo new.
		        tmp7
			        mangledName: arg2;
			        yourself ].
	tmp4 hasReturn
		ifTrue: [ self flag: #ToImplement ]
		ifFalse: [ 
			self
				put: 'call ';
				put: (self class safeSelectorNameOf: tmp2);
				pushMessageNest;
				putArguments: arg3;
				popMessageNest ]
]

{ #category : #'public API' }
SWTranspilerOfFortran >> putProgram: arg1 [

	| tmp1 |
	tmp1 := self analyzer analyze: arg1 class >> #program with: #(  ).
	self
		putMethod: tmp1;
		putLine: 'contains';
		putSubprograms: analyzer methods
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putSequence: arg1 [

	self logger log.
	self incIndent.
	arg1 statements do: [ :arg2 | 
		self
			transpile: arg2;
			putLine ].
	self decIndent
]

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran >> putString: arg1 [

	self
		put: '''';
		put: arg1;
		put: ''''
]

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran >> putSubprograms: arg1 [

	self logger log.
	self incIndent.
	arg1 valuesDo: [ :arg2 | 
		| tmp1 tmp2 tmp3 |
		tmp1 := arg2 owner >> arg2 name.
		tmp2 := self class safeSelectorNameOf: arg2 mangledName.
		tmp3 := arg2 hasReturn
			        ifTrue: [ 'function ' ]
			        ifFalse: [ 'subroutine ' ].
		self
			put: tmp3;
			put: tmp2;
			put: '(';
			putArray: tmp1 argumentNames;
			putLine: ')'.
		self analyzer variables: arg2 variables.
		self
			putMethod: arg2;
			put: 'end ';
			put: tmp3;
			putLine: tmp2 ].
	self decIndent
]

{ #category : #'code generation' }
SWTranspilerOfFortran >> putSymbol: arg1 [

	self put: arg1 asString
]

{ #category : #'as yet unclassified' }
SWTranspilerOfFortran >> putVariableDeclarationOf: arg1 [

	self put: (self class typeNameFor: arg1 type).
	(arg1 const and: [ arg1 initialValue isNotNil ]) ifTrue: [ 
		self put: ', parameter' ].
	self
		put: ' :: ';
		put: arg1 name.
	arg1 initialValue ifNil: [ self putLine ] ifNotNil: [ 
		self
			put: ' = ';
			putLine: arg1 initialValue asString ]
]
