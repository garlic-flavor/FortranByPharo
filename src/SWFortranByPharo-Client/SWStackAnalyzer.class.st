"
I fork decode process of SymbolicBytecodeBuilder to emulate stack status.
"
Class {
	#name : #SWStackAnalyzer,
	#superclass : #SWMethodInfo,
	#instVars : [
		'jumperStack',
		'tempStore',
		'sends'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #private }
SWStackAnalyzer class >> binaryOpInfo [
	^ [ :selector :args |
		SWMethodInfo new
			method: selector;
			types: args;
			return: (SWVariableInfo new
				type: [ args first type ];
				priority: { SWVariableInfo wellknownMethodPriority. (args collect: [:a | a priority]) } flattened min;
				yourself);
			yourself
	]
]

{ #category : #'as yet unclassified' }
SWStackAnalyzer class >> definedMethod: selector ifPresent: presentBlock ifAbsent: absentBlock [
	|generatorSelector|
	generatorSelector := #defined_, (self safeSelectorNameOf: selector).
	^ (self respondsTo: generatorSelector) ifTrue: [
		presentBlock value: (self perform: generatorSelector)
	] ifFalse: [
		absentBlock value
	]
]

{ #category : #'instance creation' }
SWStackAnalyzer class >> defined_new [
	^ [ :selector :args |
		self new
			method: #new;
			return: (SWVariableInfo new
				type: args first type soleInstance;
				priority: {SWVariableInfo wellknownMethodPriority. args first priority} min;
				yourself);
			yourself
	]
]

{ #category : #initialization }
SWStackAnalyzer class >> defined_opEqual_ [
	^ self binaryOpInfo
]

{ #category : #initialization }
SWStackAnalyzer class >> defined_opLT_ [
	^ self binaryOpInfo
]

{ #category : #initialization }
SWStackAnalyzer class >> defined_opMul_ [
	^ self binaryOpInfo
]

{ #category : #initialization }
SWStackAnalyzer class >> defined_opPlus_ [
	^ self binaryOpInfo
]

{ #category : #initialization }
SWStackAnalyzer class >> defined_opSub_ [
	^ self binaryOpInfo
]

{ #category : #'instance creation' }
SWStackAnalyzer class >> defined_yourself [
	^ [ :selector :args |
		SWMethodInfo new
			method: Object>>#yourself;
			return: (SWVariableInfo new
				type: [args first type];
				priority: { SWVariableInfo wellknownMethodPriority. args first priority } min;
				yourself);
			yourself
	]
]

{ #category : #'instance creation' }
SWStackAnalyzer class >> new: selector types: types [
	^ self definedMethod: selector ifPresent: [ :dm |
		dm value: selector value: types
	] ifAbsent: [
		self new
			method: selector;
			types: types;
			yourself
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
	(SWVariableInfo wellknownMethodPriority <= right priority and: [ right type = SWVariableInfo ]) ifTrue: [
		left << (	((self method sourceNodeForPC: oldPC) evaluate)
			priority: SWVariableInfo userSpecifiesTypePriority;
			yourself);
			assignCounter: 0
	] ifFalse: [
		left << right.
	].


	super popIntoTemporaryVariable: offset.

]

{ #category : #private }
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
		type:  anAssociation value class;
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
		type: [
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

{ #category : #private }
SWStackAnalyzer >> pushToSendStack: aMethod [
	(self sendStack anySatisfy: [ :each | each = aMethod ]) ifTrue: [
		Exception signal: 'A circular referencing detected: '. aMethod
	].
	self sendStack push: aMethod.

]

{ #category : #api }
SWStackAnalyzer >> ready [
	^ self return type isNotNil
]

{ #category : #accessing }
SWStackAnalyzer >> return [
	^ return ifNil: [
		return := SWVariableInfo new
			type: [
				self decode.
				return type
			];
			priority: SWVariableInfo defaultReturnTypePriority;
			yourself
	]
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> send: selector super: supered numArgs: numberArguments [
	|args methodInfo|
	args := self stack pop: numberArguments + 1.
	supered ifTrue: [ args first: args first copyAsSuper ].
	methodInfo := self class new: selector types: args.

	self sends at: (self method sourceNodeForPC: oldPC) put: methodInfo.
	self stack push: methodInfo return.
	
	super send: selector super: supered numArgs: numberArguments.

]

{ #category : #accessing }
SWStackAnalyzer >> sends [

	^ sends ifNil: [ sends := Dictionary new ]
]

{ #category : #accessing }
SWStackAnalyzer >> sends: anObject [

	sends := anObject
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

{ #category : #accessing }
SWStackAnalyzer >> variableInfoOf: aName [
	^ self return type ifNotNil: [
		super variableInfoOf: aName
	]

]
