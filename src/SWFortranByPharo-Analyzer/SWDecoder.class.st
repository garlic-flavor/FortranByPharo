"
SWStackAnalyzer forks decode process of SymbolicBytecodeBuilder to emulate stack status.
"
Class {
	#name : #SWDecoder,
	#superclass : #SWCompiledCode,
	#instVars : [
		'jumperStack',
		'pool',
		'logger',
		'debugMode'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #'as yet unclassified' }
SWDecoder class >> poolClass [
	^ SWPool
]

{ #category : #private }
SWDecoder >> addBytecode: description [
	|item node operands sender|

	self logger log: [ String streamContents: [ :s |
		s << '[' print: oldPC; << '] '; << description
	] ] withStack: self stack.
	super addBytecode: description.

	(self jumperStack nextPeriodIs: scanner pc) ifFalse: [ ^ self  ]. 

	"Below evaluates when ifTrue:ifFalse:."
	item := self jumperStack pop.
	node := self method sourceNodeForPC: item startPC.
	operands := self stack popSlotForJumper: self stack size - item stackSize.
	sender := self pool newSenderOf: node selector super: false with: operands.
	sender hasReturn ifTrue: [
		self stack push: sender return 
	] ifFalse: [
		sender return << self stack top
	].
	sender node: node.
	self senders at: node put: sender.

]

{ #category : #'instruction decoding' }
SWDecoder >> blockReturnConstant: cst [
	self halt.
	
	super blockReturnConstant: cst
]

{ #category : #'instruction decoding' }
SWDecoder >> blockReturnTop [
	self return << self stack top.
	
	super blockReturnTop
]

{ #category : #'instruction decoding' }
SWDecoder >> callPrimitive: primNumber [

	super callPrimitive: primNumber
]

{ #category : #'instruction decoding' }
SWDecoder >> directedSuperSend: selector numArgs: numberArguments [

	self halt.
	
	super directedSuperSend: selector numArgs: numberArguments 
]

{ #category : #'instruction decoding' }
SWDecoder >> doDup [
	|top|
	top := self stack top.
	self stack push: top.
	super doDup.

]

{ #category : #'instruction decoding' }
SWDecoder >> doPop [
	self stack pop.
	super doPop.

]

{ #category : #'instruction decoding' }
SWDecoder >> jump: offset [
	self jumperStack update: scanner pc + offset.
	super jump: offset.
	
]

{ #category : #'instruction decoding' }
SWDecoder >> jump: offset if: condition [

	self jumperStack pushAt: oldPC period: scanner pc + offset size: self stack size.
	self stack pop.
	
	super jump: offset if: condition.

]

{ #category : #'private - accessing' }
SWDecoder >> jumperStack [

	^ jumperStack ifNil: [ jumperStack := SWJumperStack new ]
]

{ #category : #'private - accessing' }
SWDecoder >> jumperStack: anObject [

	jumperStack := anObject
]

{ #category : #accessing }
SWDecoder >> logger [

	^ logger ifNil: [ logger := SWLogger new ]
]

{ #category : #accessing }
SWDecoder >> logger: anObject [

	logger := anObject
]

{ #category : #private }
SWDecoder >> mergeStackTopAndSecond [
	|right|
	right := self stack pop.
	self stack top << right.


]

{ #category : #'instruction decoding' }
SWDecoder >> methodReturnConstant: value [
	self return << (SWVariableTypeInfo new: value class owner: self pc: oldPC).
	super methodReturnConstant: value
]

{ #category : #'instruction decoding' }
SWDecoder >> methodReturnReceiver [
	self return << (self stack at: 0).
	super methodReturnReceiver

]

{ #category : #'instruction decoding' }
SWDecoder >> methodReturnTop [
	self return << self stack top.
	super methodReturnTop.

]

{ #category : #private }
SWDecoder >> newFullClosure: lit with: args [
	^ (self class new: lit with: args)
		pool: self pool;
		classInfo: self classInfo;
		logger: self logger;
		yourself


]

{ #category : #accessing }
SWDecoder >> pool [

	^ pool ifNil: [
		pool := self class poolClass new
			owner: self;
			yourself
	]
]

{ #category : #accessing }
SWDecoder >> pool: anObject [

	pool := anObject

]

{ #category : #'instruction decoding' }
SWDecoder >> popIntoLiteralVariable: anAssociation [

	self halt.
	
	super popIntoLiteralVariable: anAssociation 
]

{ #category : #'instruction decoding' }
SWDecoder >> popIntoReceiverVariable: offset [
	(self classInfo getVariableInfoAtOffset: offset) << self stack pop.
	super popIntoReceiverVariable: offset
]

{ #category : #'instruction decoding' }
SWDecoder >> popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [

	self halt.
	
	super popIntoRemoteTemp: remoteTempIndex  inVectorAt: tempVectorIndex 
]

{ #category : #'instruction decoding' }
SWDecoder >> popIntoTemporaryVariable: offset [
	|left right|

	left := self stack atOffset: offset.
	right := self stack pop.

	left << right.

	super popIntoTemporaryVariable: offset.

]

{ #category : #'instruction decoding' }
SWDecoder >> pushActiveContext [ 
	self stack push: (SWVariableTypeInfo new: Context owner: self pc: oldPC).
	super pushActiveContext
]

{ #category : #'instruction decoding' }
SWDecoder >> pushActiveProcess [ 
	self halt.
	super pushActiveProcess 
]

{ #category : #'instruction decoding' }
SWDecoder >> pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize [

	self halt.
	
	super pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize 
]

{ #category : #'instruction decoding' }
SWDecoder >> pushClosureTemps: numTemps [

	self halt.
	
	super pushClosureTemps: numTemps
]

{ #category : #'instruction decoding' }
SWDecoder >> pushConsArrayWithElements: numElements [

	|args|
	args := self stack pop: numElements.
	self flag: #toImplement.
	"There are no type information for each elements in an Array."
	self stack push: (SWVariableTypeInfo new: Array).
	
	super pushConsArrayWithElements: numElements
]

{ #category : #'instruction decoding' }
SWDecoder >> pushConstant: obj [
	self stack push: (SWVariableTypeInfo new: obj class owner: self pc: oldPC).

	super pushConstant: obj.

]

{ #category : #'instruction decoding' }
SWDecoder >> pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore [
	|mi ret|

	rcvr ifTrue: [ self error ].
	ignore ifTrue: [ self error ].

	"I only interest in type information on the stack.
	So, I decode a closure before invoking. it's ok."
	mi := self newFullClosure: lit with: (self stack popSlotForClosure: numCopied).
	self logger log: 'decode closure' withStack: self stack.
	mi decode.
	ret := (SWContainerType new: BlockClosure)
		elementType: mi return value;
		yourself.
	lit hasMethodReturn ifTrue: [
		self return << ret
	].
	self senders addAll: mi senders.
	self stack push: (SWVariableTypeInfo new: ret).

	super pushFullClosure: lit numCopied: numCopied  receiverOnStack: rcvr ignoreOuterContext: ignore 
]

{ #category : #'instruction decoding' }
SWDecoder >> pushLiteralVariable: anAssociation [
	self stack push: (SWVariableTypeInfo new: anAssociation value class owner: self pc: oldPC).

	super pushLiteralVariable: anAssociation.

]

{ #category : #'instruction decoding' }
SWDecoder >> pushNewArrayOfSize: numElements [

	self stack push: (SWVariableTypeInfo new: Array owner: self pc: oldPC).
	
	super pushNewArrayOfSize: numElements 
]

{ #category : #'instruction decoding' }
SWDecoder >> pushReceiver [
	self stack push: (self stack at: 0).

	super pushReceiver.

]

{ #category : #'instruction decoding' }
SWDecoder >> pushReceiverVariable: offset [
	self stack push: (self classInfo getVariableInfoAtOffset: offset).
	super pushReceiverVariable: offset
]

{ #category : #'instruction decoding' }
SWDecoder >> pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [

	self halt.
	super pushRemoteTemp: remoteTempIndex  inVectorAt: tempVectorIndex 
]

{ #category : #'instruction decoding' }
SWDecoder >> pushTemporaryVariable:  offset [
	self stack push: (self stack atOffset: offset).
	super pushTemporaryVariable: offset.

]

{ #category : #'instruction decoding' }
SWDecoder >> send: selector super: supered numArgs: numberArguments [
	|operands sender|
	self logger log: [ 'decode: ', selector ] withStack: self stack.

	operands := self stack popSlotForSender: numberArguments.
selector = #beginsWith: ifTrue: [ self halt ].

	sender := (self pool newSenderOf: selector super: supered with: operands)
		node: (self method sourceNodeForPC: oldPC);
		yourself.
	self senders at: sender node put: sender.
	self stack push: sender return.
"
	self error; flag: #toRewrite.
	methodInfo := self pool getMethodTranspiler: selector supered: supered with: args.

	self messages at: (self method sourceNodeForPC: oldPC) put: methodInfo.
	self stack push: methodInfo return.
"
	"A special case for user specifying."
	(selector = #declare:as: and: [ operands receiver value = SWType class ]) ifTrue: [|assoc|
		assoc := (self method sourceNodeForPC: oldPC) evaluate.
		(assoc key = #return ifTrue: [
			self return
		] ifFalse: [
			(self getVariableInfoOf: assoc key) 
		])
			<<  assoc value;
			owner: self;
			pc: oldPC
	].
	super send: selector super: supered numArgs: numberArguments.

]

{ #category : #'instruction decoding' }
SWDecoder >> storeIntoLiteralVariable: anAssociation [
	self getVariableInfoOf: anAssociation key ifPresent: [ :vi |
		vi << self stack top
	].
	super storeIntoLiteralVariable: anAssociation
]

{ #category : #'instruction decoding' }
SWDecoder >> storeIntoReceiverVariable: offset [
	(self classInfo getVariableInfoAtOffset: offset) << self stack top.
	super storeIntoReceiverVariable: offset
]

{ #category : #'instruction decoding' }
SWDecoder >> storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	self halt.
	super storeIntoRemoteTemp: remoteTempIndex  inVectorAt: tempVectorIndex 
]

{ #category : #'instruction decoding' }
SWDecoder >> storeIntoTemporaryVariable: offset [
	|left right|
	left := self stack atOffset: offset.
	right := self stack top.
	left << right.

	super storeIntoTemporaryVariable: offset
]

{ #category : #'instruction decoding' }
SWDecoder >> trap [
	self halt.
	super trap
]
