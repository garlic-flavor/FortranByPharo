Class {
	#name : #SWMethodBodyTranspiler,
	#superclass : #SWStackAnalyzerToTranspile,
	#instVars : [
		'stream',
		'type',
		'messageNest'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #utils }
SWMethodBodyTranspiler class >> messageTranspilerMethodNameFor: arg1 [

	^ ((self safeSelectorNameOf: arg1) , 'For:With:') asSymbol
]

{ #category : #utils }
SWMethodBodyTranspiler class >> uniqueMessageTranspilerNameFor: arg1 for: arg2 [

	^ (String streamContents: [ :arg3 | 
		   arg3
			   << arg2;
			   << '_';
			   << (self safeSelectorNameOf: arg1);
			   << 'For:With:Using:' ]) asSymbol
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> << arg1 [

	self stream log.
	arg1 transpileUsing: self
]

{ #category : #'private - utilities' }
SWMethodBodyTranspiler >> classOf: arg1 [

	arg1 class = RBLiteralValueNode ifTrue: [ ^ arg1 value class ].
	arg1 class = RBVariableNode ifTrue: [ 
		^ arg1 name first isUppercase
			  ifTrue: [ Smalltalk globals at: arg1 name ]
			  ifFalse: [ (self variableInfoOf: arg1 name) type ] ].
	self halt
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> cr [

	self stream putLine
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> decMessageNest [

	messageNest push: { 
			0.
			(messageNest pop - 1) } max.
	0 < messageNest top ifTrue: [ self put: ')' ]
]

{ #category : #'private - testing' }
SWMethodBodyTranspiler >> hasOwnMessageTranspilerMethodOf: arg1 ifTrue: arg2 [

	| tmp1 tmp2 |
	tmp1 := self class messageTranspilerMethodNameFor: arg1.
	(tmp2 := self class search: tmp1 in: self class) ifNotNil: [ 
		arg2 value: [ :arg3 :arg4 | 
			tmp2 valueWithReceiver: self arguments: { 
					arg3.
					arg4 } ] ]
]

{ #category : #'private - testing' }
SWMethodBodyTranspiler >> ifUniqueMessageTranspilerExistsOn: arg1 of: arg2 thenDo: arg3 [

	| tmp1 tmp2 tmp3 |
	tmp1 := self metaclassOf: arg1.
	tmp2 := self class
		        uniqueMessageTranspilerNameFor: arg2
		        for: self type.
	(tmp3 := self class search: tmp2 in: tmp1) ifNotNil: [ 
		arg3 value: [ :arg4 | 
			tmp3 valueWithReceiver: tmp1 arguments: { 
					arg4.
					self } ] ]
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> incMessageNest [

	messageNest push: messageNest pop + 1.
	1 < messageNest top ifTrue: [ self put: '(' ]
]

{ #category : #initialization }
SWMethodBodyTranspiler >> initialize [

	super initialize.
	messageNest := Stack newFrom: { 0 }
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> logging: arg1 [

	self stream logging: arg1
]

{ #category : #'private - utilities' }
SWMethodBodyTranspiler >> metaclassOf: arg1 [

	| tmp1 |
	^ (tmp1 := self classOf: arg1) class = Metaclass
		  ifTrue: [ tmp1 ]
		  ifFalse: [ tmp1 class ]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> opEqual_For: arg1 With: arg2 [

	self stream log: [ arg1 asString , ' == ' , (arg2 at: 1) asString ].
	self
		<< arg1;
		put: ' == ';
		<< (arg2 at: 1)
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> put: arg1 [

	self stream put: arg1 asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArguments: arg1 [

	self stream log.
	self put: '('.
	arg1 do: [ :arg2 | self << arg2 ] separatedBy: [ self put: ', ' ].
	self put: ')'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putArray: arg1 [

	self stream log.
	self put: '['.
	arg1 do: [ :arg2 | self << arg2 ] separatedBy: [ self put: ', ' ].
	self put: ']'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putAssignTo: arg1 with: arg2 [

	self stream log: [ arg1 asString , ' = ' , arg2 asString ].
	self
		<< arg1;
		put: ' = ';
		<< arg2
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCascade: arg1 [

	| tmp1 tmp2 tmp4 tmp6 |
	tmp4 := RBVariableNode new.
	tmp4 name: self tempStore pop name.
	tmp2 := tmp4 yourself.
	tmp6 := RBSequenceNode new.
	tmp6
		addNode:
			(RBAssignmentNode variable: tmp2 value: arg1 leftmostChainReceiver);
		addNodes: (arg1 messages collect: [ :arg2 | 
					 | tmp8 |
					 tmp8 := arg2 copy.
					 tmp8
						 receiver: tmp2;
						 yourself ]).
	tmp1 := tmp6 yourself.
	self putSequence: tmp1
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCharacter: arg1 [

	self stream log.
	self
		put: '"';
		put: arg1 asString;
		put: '"'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putClassAccessor [

	self put: '.'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCode: arg1 [

	^ self putCode: arg1 with: {  }
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putCode: arg1 with: arg2 [

	| tmp1 tmp2 tmp4 |
	self stream log.
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
SWMethodBodyTranspiler >> putInteger: arg1 [

	self stream log.
	self put: arg1 asString
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putMessage: arg1 send: arg2 with: arg3 [

	self stream log: [ arg1 asString , ' >> ' , arg2 asString ].
	self
		incMessageNest;
		selectTranspilerFor: arg1 send: arg2 with: arg3;
		decMessageNest
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putOrdinaryMessage: arg1 send: arg2 with: arg3 [

	self stream log.
	self << arg1.
	arg2 first isLetter
		ifTrue: [ 
			self
				putClassAccessor;
				put: (self class safeSelectorNameOf: arg2);
				putArguments: arg3 ]
		ifFalse: [ 
			self
				put: arg2;
				<< (arg3 at: 1) ]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putParameters: arg1 [

	self stream log.
	arg1
		do: [ :arg2 | self put: arg2 asString ]
		separatedBy: [ self put: ', ' ]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putReturn: arg1 [

	self stream log.
	self put: 'return '.
	^ self << arg1
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putSequence: arg1 [

	arg1 statements do: [ :arg2 | self putStatement: arg2 ]
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatement: arg1 [

	self << arg1.
	arg1 class = RBCascadeNode ifTrue: [ ^ self ].
	self
		putStatementDelimiter;
		cr
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putStatementDelimiter [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putString: arg1 [

	self stream log.
	self
		put: '"';
		put: arg1;
		put: '"'
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariable: arg1 [

	self stream log: arg1 name.
	self put: arg1 name
]

{ #category : #'code generation' }
SWMethodBodyTranspiler >> putVariableDeclarationOf: arg1 [

	^ self subclassResponsibility
]

{ #category : #'private - code generation' }
SWMethodBodyTranspiler >> selectTranspilerFor: arg1 send: arg2 with: arg3 [

	self stream log: [ arg1 asString , ' >> ' , arg2 asString ].
	self
		ifUniqueMessageTranspilerExistsOn: arg1
		of: arg2
		thenDo: [ :arg4 | ^ arg4 value: arg3 ];
		hasOwnMessageTranspilerMethodOf: arg2
		ifTrue: [ :arg5 | ^ arg5 with: arg1 with: arg3 ].
	^ self putOrdinaryMessage: arg1 send: arg2 with: arg3
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream [

	^ stream
		  ifNil: [ stream := SWTranspilerStream new ]
		  ifNotNil: [ stream ]
]

{ #category : #accessing }
SWMethodBodyTranspiler >> stream: arg1 [

	stream := arg1
]

{ #category : #'public API' }
SWMethodBodyTranspiler >> transpile [

	self stream log.
	self locals do: [ :arg1 | self putVariableDeclarationOf: arg1 ].
	self putSequence: self method sourceNode body.
	^ self stream contents
]

{ #category : #accessing }
SWMethodBodyTranspiler >> type [

	^ type
]

{ #category : #accessing }
SWMethodBodyTranspiler >> type: arg1 [

	type := arg1
]
