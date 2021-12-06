Class {
	#name : #SWTranspiler,
	#superclass : #SWTranspilerBaseOld,
	#instVars : [
		'stream',
		'indent',
		'tabWidth',
		'isNewline',
		'newline',
		'preventNewline',
		'messageNest',
		'source',
		'pool',
		'analyzer'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWTranspiler >> analyzer [

	^ analyzer
		  ifNil: [ analyzer := SWAnalyzerDummy new ]
		  ifNotNil: [ analyzer ]
]

{ #category : #accessing }
SWTranspiler >> analyzer: arg1 [

	analyzer := arg1
]

{ #category : #'code generation' }
SWTranspiler >> assign: arg1 with: arg2 [

	self logger log: [ arg1 asString , ' = ' , arg2 asString ].
	self
		transpile: arg1;
		put: ' = '.
	arg2 transpileUsing: self
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

	messageNest push: { 
			0.
			(messageNest pop - 1) } max.
	0 < messageNest top ifTrue: [ self put: ')' ]
]

{ #category : #'code generation - protected' }
SWTranspiler >> incIndent [

	indent := indent + 1
]

{ #category : #'code generation - protected' }
SWTranspiler >> incMessageNest [

	messageNest push: messageNest pop + 1.
	1 < messageNest top ifTrue: [ self put: '(' ]
]

{ #category : #initialization }
SWTranspiler >> initialize [

	| tmp2 |
	super initialize.
	stream := String new writeStream.
	indent := 0.
	newline := String crlf.
	isNewline := false.
	preventNewline := false.
	tmp2 := Stack new.
	tmp2 push: 0.
	messageNest := tmp2 yourself
]

{ #category : #accessing }
SWTranspiler >> newline [

	^ newline
]

{ #category : #accessing }
SWTranspiler >> newline: arg1 [

	newline := arg1
]

{ #category : #'code generation' }
SWTranspiler >> opEqual_For: arg1 With: arg2 [

	self logger log: [ arg1 asString , ' == ' , (arg2 at: 1) asString ].
	self
		transpile: arg1;
		put: ' == ';
		transpile: (arg2 at: 1)
]

{ #category : #accessing }
SWTranspiler >> pool [

	^ pool
		  ifNil: [ 
			  | tmp2 |
			  tmp2 := SWSourcesPool new.
			  tmp2 type: self type.
			  pool := tmp2 yourself ]
		  ifNotNil: [ pool ]
]

{ #category : #accessing }
SWTranspiler >> pool: arg1 [

	pool := arg1
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
SWTranspiler >> put: arg1 [

	self logger log: arg1.
	self putIndent.
	stream nextPutAll: arg1
]

{ #category : #'code generation' }
SWTranspiler >> putArguments: arg1 [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putArray: arg1 [

	self logger log.
	self put: '['.
	arg1
		do: [ :arg2 | arg2 transpileUsing: self ]
		separatedBy: [ self put: ', ' ].
	self put: ']'
]

{ #category : #'code generation' }
SWTranspiler >> putBlock: arg1 [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putCascade: arg1 [

	| tmp1 tmp2 tmp3 tmp4 tmp6 tmp8 tmp12 tmp14 |
	tmp6 := RBVariableNode new.
	tmp6 name: 'tmp'.
	tmp4 := tmp6 yourself.
	tmp8 := RBSequenceNode new.
	tmp8 addNodes: (arg1 messages collect: [ :arg2 | 
			 | tmp10 |
			 tmp10 := arg2 copy.
			 tmp10
				 receiver: tmp4;
				 yourself ]).
	tmp3 := tmp8 yourself.
	tmp12 := RBBlockNode new.
	tmp12
		arguments: { tmp4 };
		body: tmp3.
	tmp2 := tmp12 yourself.
	tmp14 := RBMessageNode new.
	tmp14
		receiver: tmp2;
		selector: #value:;
		arguments: { arg1 receiver copy }.
	tmp1 := tmp14 yourself.
	^ tmp1 transpileUsing: self
]

{ #category : #'code generation' }
SWTranspiler >> putCharacter: arg1 [

	self logger log.
	self
		put: '"';
		put: arg1 asString;
		put: '"'
]

{ #category : #'code generation' }
SWTranspiler >> putClassAccessor [

	self put: '.'
]

{ #category : #'code generation' }
SWTranspiler >> putClassDefinition: arg1 [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putCode: arg1 [

	^ self putCode: arg1 with: {  }
]

{ #category : #'code generation' }
SWTranspiler >> putCode: arg1 with: arg2 [

	| tmp1 tmp2 tmp4 |
	self logger log.
	tmp1 := RxMatcher forString: '(\\\r|\s+\\$)'.
	tmp4 := tmp1 copy: arg1 replacingMatchesWith: ''.
	tmp2 := (tmp4 findFirst: [ :arg3 | arg3 ~= Character tab ]) - 1.
	tmp1 := RxMatcher forString: '\t+'.
	tmp4 := tmp1
		        copy: tmp4
		        translatingMatchesUsing: [ :arg4 | 
		        String tab repeat: arg4 size - tmp2 ].
	arg2 do: [ :arg5 | 
		tmp4 := tmp4 copyReplaceAll: arg5 key with: arg5 value ].
	self put: tmp4
]

{ #category : #'code generation' }
SWTranspiler >> putComment: arg1 [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putFileFooterOf: arg1 [

	
]

{ #category : #'code generation' }
SWTranspiler >> putFileHeaderOf: arg1 [

	
]

{ #category : #'code generation' }
SWTranspiler >> putFloat: arg1 [

	self put: arg1 asString
]

{ #category : #'code generation' }
SWTranspiler >> putImportClass: arg1 [

	self logger log.
	self
		halt;
		flag: #toImplement.
	self analyzer putImportClass: arg1
]

{ #category : #'code generation - protected' }
SWTranspiler >> putIndent [

	isNewline ifFalse: [ ^ self ].
	stream nextPutAll: (' ' repeat: { 
				 0.
				 (self tabWidth * indent) } max).
	isNewline := false
]

{ #category : #'code generation' }
SWTranspiler >> putInteger: arg1 [

	self put: arg1 asString
]

{ #category : #'code generation' }
SWTranspiler >> putLine [

	preventNewline
		ifTrue: [ preventNewline := false ]
		ifFalse: [ 
			stream << newline.
			isNewline := true ]
]

{ #category : #'code generation' }
SWTranspiler >> putLine: arg1 [

	self
		put: arg1;
		putLine
]

{ #category : #'code generation' }
SWTranspiler >> putMessage: arg1 send: arg2 with: arg3 [

	self logger log.
	self incMessageNest.
	super putMessage: arg1 send: arg2 with: arg3.
	self decMessageNest
]

{ #category : #'code generation' }
SWTranspiler >> putMethod: arg1 ofClass: arg2 [

	| tmp1 |
	tmp1 := self analyzer subAnalyzer.
	self
		halt;
		flag: #toImplement
]

{ #category : #'code generation' }
SWTranspiler >> putNil [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putOrdinaryMessage: arg1 send: arg2 with: arg3 [

	arg1 transpileUsing: self.
	arg2 first isLetter
		ifTrue: [ 
			self
				putClassAccessor;
				put: (self class safeSelectorNameOf: arg2);
				putArguments: arg3 ]
		ifFalse: [ 
			self
				put: arg2;
				transpile: (arg3 at: 1) ]
]

{ #category : #'code generation' }
SWTranspiler >> putParameters: arg1 [

	self logger log.
	arg1
		do: [ :arg2 | self put: arg2 asString ]
		separatedBy: [ self put: ', ' ]
]

{ #category : #'code generation' }
SWTranspiler >> putProgram: arg1 [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putRequirements [

	| tmp1 |
	tmp1 := self type , '_requirements:'.
	self source classes do: [ :arg1 | 
		(arg1 respondsTo: tmp1) ifTrue: [ arg1 perform: tmp1 with: self ] ]
]

{ #category : #'code generation' }
SWTranspiler >> putReturn: arg1 [

	self logger log.
	self put: 'return '.
	^ self transpile: arg1
]

{ #category : #'code generation' }
SWTranspiler >> putSequence: arg1 [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putString: arg1 [

	self logger log.
	self
		put: '"';
		put: arg1;
		put: '"'
]

{ #category : #'code generation' }
SWTranspiler >> putSymbol: arg1 [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putTestRunner: arg1 [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWTranspiler >> putVariable: arg1 [

	self logger log: arg1 name.
	self put: arg1 name
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
SWTranspiler >> source: arg1 [

	source := arg1
]

{ #category : #accessing }
SWTranspiler >> tabWidth [

	^ tabWidth ifNil: [ tabWidth := 4 ] ifNotNil: [ tabWidth ]
]

{ #category : #accessing }
SWTranspiler >> tabWidth: arg1 [

	tabWidth := arg1
]

{ #category : #'public API' }
SWTranspiler >> transpile [

	| tmp1 |
	self
		putFileHeaderOf: self source moduleName;
		putRequirements.
	self source classes do: [ :arg1 | self putClassDefinition: arg1 ].
	(tmp1 := self source programClass) ifNotNil: [ 
		(tmp1 inheritsFrom: SWTestBase)
			ifTrue: [ self putTestRunner: tmp1 ]
			ifFalse: [ self putProgram: tmp1 ] ].
	self putFileFooterOf: self source moduleName
]

{ #category : #'code generation' }
SWTranspiler >> transpile: arg1 [

	self logger log.
	^ arg1 transpileUsing: self
]

{ #category : #'public API' }
SWTranspiler >> transpileAsModule [

	self
		putFileHeaderOf: self source moduleName;
		putRequirements.
	self source classes do: [ :arg1 | self putClassDefinition: arg1 ]
]
