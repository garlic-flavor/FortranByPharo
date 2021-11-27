"
I analyze bytecodes of a method. See also, SymbolicBytecodeBuilder.
"
Class {
	#name : #SWStackAnalyzer,
	#superclass : #SWMethodInfo,
	#instVars : [
		'sendStack',
		'jumperStack',
		'tempStore'
	],
	#classVars : [
		'definedMethods'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #private }
SWStackAnalyzer class >> binaryOpInfo [
	^ [ :selector :types |
		SWMethodInfo new
			method: (self search: selector in: types first);
			types: types;
			return: (SWVariableInfo new
				type: (types at: 1);
				yourself);
			yourself
	]
]

{ #category : #decoding }
SWStackAnalyzer class >> decode: selector types: types [
	^ self decode: selector types: types sendStack: nil
]

{ #category : #decoding }
SWStackAnalyzer class >> decode: selector types: types sendStack: ss [
	^ (self new: selector types: types)
		sendStack: ss;
		decoded;
		yourself

]

{ #category : #acccessing }
SWStackAnalyzer class >> definedMethods [
	^ definedMethods
]

{ #category : #initialization }
SWStackAnalyzer class >> initialize [
	self installMethods
]

{ #category : #initialization }
SWStackAnalyzer class >> installMethods [
	definedMethods := Dictionary newFrom: (self class methods select: [ :method |
		method selector beginsWith: 'install_'
	] thenCollect: [ :method |
		method valueWithReceiver: self arguments: #().
	])
]

{ #category : #initialization }
SWStackAnalyzer class >> install_add [
	^ #+ -> self binaryOpInfo
]

{ #category : #initialization }
SWStackAnalyzer class >> install_eq [
	^ #= -> self binaryOpInfo
]

{ #category : #initialization }
SWStackAnalyzer class >> install_lt [
	^ #< -> self binaryOpInfo
]

{ #category : #private }
SWStackAnalyzer class >> install_new [
	^ #new -> [ :selector :types |
		SWMethodInfo new
			return: (SWVariableInfo new
				type: (types at: 1);
				yourself);
			yourself
	]
]

{ #category : #initialization }
SWStackAnalyzer class >> install_sub [
	^ #- -> self binaryOpInfo
]

{ #category : #'instance creation' }
SWStackAnalyzer class >> new: selector types: types [
	^ self definedMethods at: selector ifPresent: [ :dm |
		dm value: selector value: types
	] ifAbsent: [
		super new: selector types: types
	]

]

{ #category : #private }
SWStackAnalyzer >> addBytecode: description [
	super addBytecode: description.
	(self jumperStack nextPeriodIs: scanner pc) ifFalse: [ ^ self  ].
	self jumperStack pop.
	self mergeStackTopAndSecond .

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> blockReturnConstant: cst [
	self halt.
	
	super blockReturnConstant: cst
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> blockReturnTop [
	self halt.
	
	super blockReturnTop
]

{ #category : #api }
SWStackAnalyzer >> decoded [
	self return hasAnyType ifTrue: [ ^ self ].
	self pushToSendStack: self method.
	self decode.
	self popSendStack: self method.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> directedSuperSend: selector numArgs: numberArguments [

	self halt.
	
	super directedSuperSend: selector numArgs: numberArguments 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> doDup [
	|top|
	top := self stack top.
	self stack push: top.
	(self tempStore push: top) ifTrue: [
		self addLocalVariable: top
	].
	super doDup.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> doPop [
	self stack pop.
	super doPop.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> jump: offset [
	self jumperStack pushAt: scanner pc period: scanner pc + offset.
	super jump: offset.
	
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> jump: offset if: condition [
	self jumperStack pushAt: scanner pc period: scanner pc + offset.
	super jump: offset if: condition.

]

{ #category : #'private - accessing' }
SWStackAnalyzer >> jumperStack [

	^ jumperStack ifNil: [ jumperStack := SWJumperStack new ]
]

{ #category : #'private - accessing' }
SWStackAnalyzer >> jumperStack: anObject [

	jumperStack := anObject
]

{ #category : #private }
SWStackAnalyzer >> mergeStackTopAndSecond [
	|result|
	result := SWVariableInfo new.
	result << self stack pop.
	result << self stack pop.

	self stack push: result

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnConstant: value [
	self halt.
	super methodReturnConstant: value
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnReceiver [
	self return << (self stack at: 0).
	super methodReturnReceiver

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnTop [
	self return << self stack top.
	super methodReturnTop.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoLiteralVariable: anAssociation [

	self halt.
	
	super popIntoLiteralVariable: anAssociation 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoReceiverVariable: offset [

	self halt.
	
	super popIntoReceiverVariable: offset
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [

	self halt.
	
	super popIntoRemoteTemp: remoteTempIndex  inVectorAt: tempVectorIndex 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoTemporaryVariable: offset [
	|left right|
	left := self stack atOffset: offset.
	right := self stack pop.
	left << right.

	super popIntoTemporaryVariable: offset.

]

{ #category : #'private - accessing' }
SWStackAnalyzer >> popSendStack: aMethod [
	aMethod = self sendStack pop ifFalse: [
		Exception signal: ('A stacking mismatch was detected: ', aMethod)
	].
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushActiveContext [ 
	self halt.
	super pushActiveContext
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushActiveProcess [ 
	self halt.
	super pushActiveProcess 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize [

	self halt.
	
	super pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushClosureTemps: numTemps [

	self halt.
	
	super pushClosureTemps: numTemps
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushConsArrayWithElements: numElements [

	self halt.
	
	super pushConsArrayWithElements: numElements
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushConstant: obj [
	self stack push: (SWVariableInfo new
		type: obj class;
		yourself).

	super pushConstant: obj.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushFullClosure: lit numCopies: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore [

	self halt.
	
	super pushFullClosure: lit numCopied: numCopied  receiverOnStack: rcvr ignoreOuterContext: ignore 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushLiteralVariable: anAssociation [
	self stack push: (SWVariableInfo new
		type: (anAssociation key
			ifNil: [ anAssociation value class ]
			ifNotNil: [anAssociation value ]);
		yourself).

	super pushLiteralVariable: anAssociation.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushNewArrayOfSize: numElements [

	self halt.
	
	super pushNewArrayOfSize: numElements 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushReceiver [
	self stack push: (self stack at: 0).

	super pushReceiver.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushReceiverVariable: offset [
	self stack push: (SWVariableInfo new
		initializer: [
			(self classInfo getVariableInfoAt: offset) type
		];
		priority: 10;
		yourself
	).
	super pushReceiverVariable: offset
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [

	self halt.
	super pushRemoteTemp: remoteTempIndex  inVectorAt: tempVectorIndex 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushTemporaryVariable:  offset [
	self stack push: (self stack atOffset: offset).
	super pushTemporaryVariable: offset.

]

{ #category : #'private - accessing' }
SWStackAnalyzer >> pushToSendStack: aMethod [
	(self sendStack anySatisfy: [ :each | each = aMethod ]) ifTrue: [
		Exception signal: 'A circular referencing detected: '. aMethod
	].
	self sendStack push: aMethod.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> send: selector super: supered numArgs: numberArguments [
	|args|
	args := self stack pop: numberArguments + 1.
	self stack push: (SWVariableInfo new
		initializer: [|aTypes|
			aTypes := args collect: [ :each | each type ].
			supered ifTrue: [ aTypes first: aTypes first superclass ].
			(self class decode: selector types: aTypes sendStack: self sendStack) return type
		];
		yourself
	).
	
	super send: selector super: supered numArgs: numberArguments.

]

{ #category : #'private - accessing' }
SWStackAnalyzer >> sendStack [

	^ sendStack ifNil: [ sendStack := Stack new ]
]

{ #category : #'private - accessing' }
SWStackAnalyzer >> sendStack: anObject [

	sendStack := anObject
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> storeIntoLiteralVariable: anAssociation [

	self halt.
	
	super storeIntoLiteralVariable: anAssociation
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	self halt.
	super storeIntoRemoteTemp: remoteTempIndex  inVectorAt: tempVectorIndex 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> storeIntoTemporaryVariable: offset [
	|left right|
	left := self stack atOffset: offset.
	right := self stack top.
	left << right.

	super storeIntoTemporaryVariable: offset
]

{ #category : #accessing }
SWStackAnalyzer >> tempStore [

	^ tempStore ifNil: [
		tempStore := SWTempStore new
			method: self method;
			yourself
	]
]

{ #category : #accessing }
SWStackAnalyzer >> tempStore: anObject [

	tempStore := anObject
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> trap [
	self halt.
	super trap
]
