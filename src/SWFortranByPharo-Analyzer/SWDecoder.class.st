"
SWStackAnalyzer forks decode process of SymbolicBytecodeBuilder to emulate stack status.
"
Class {
	#name : #SWDecoder,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'code',
		'pool',
		'classInfo',
		'jumperStack',
		'haltList',
		'logger'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #'instance creation' }
SWDecoder class >> classTranspilerClass [
	^ SWClass
]

{ #category : #'instance creation' }
SWDecoder class >> new: aCompiledCode [
	^ self new
		code: aCompiledCode;
		yourself
]

{ #category : #'as yet unclassified' }
SWDecoder class >> poolClass [
	^ SWPool
]

{ #category : #accessing }
SWDecoder class >> senderTranspilerClass [
	^ SWSender
]

{ #category : #private }
SWDecoder >> addBytecode: description [

	self logger log: [ String streamContents: [ :s |
		s << '[' print: oldPC; << '] '; << description
	] ] withStack: self code slot.
	super addBytecode: description.

	self solveJumper

]

{ #category : #private }
SWDecoder >> atOffset: offset [
	^ self code slot atOffset: offset
]

{ #category : #'instruction decoding' }
SWDecoder >> blockReturnConstant: cst [
	self halt.
	
	super blockReturnConstant: cst
]

{ #category : #'instruction decoding' }
SWDecoder >> blockReturnTop [
	self code return << self code top.
	
	super blockReturnTop
]

{ #category : #'instruction decoding' }
SWDecoder >> callPrimitive: primNumber [

	super callPrimitive: primNumber
]

{ #category : #accessing }
SWDecoder >> classInfo [
	"This is a SWClass"
	^ classInfo
]

{ #category : #accessing }
SWDecoder >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #accessing }
SWDecoder >> code [

	^ code
]

{ #category : #accessing }
SWDecoder >> code: anObject [

	code := anObject.
	method := code payload.
]

{ #category : #api }
SWDecoder >> decode [
	self code isDecodable ifFalse: [ ^ self ].
	self isDecoded ifTrue: [ ^self ].
	self logger log: 'decoding start' withStack: self code slot.
	super decode.
	^ code

]

{ #category : #'instruction decoding' }
SWDecoder >> directedSuperSend: selector numArgs: numberArguments [

	self halt.
	
	super directedSuperSend: selector numArgs: numberArguments 
]

{ #category : #'instruction decoding' }
SWDecoder >> doDup [
	self code slot push: self code slot top.
	super doDup.

]

{ #category : #'instruction decoding' }
SWDecoder >> doPop [
	self pop.
	super doPop.

]

{ #category : #adding }
SWDecoder >> haltAt: selector [
	self haltList add: selector
]

{ #category : #'private - accessing' }
SWDecoder >> haltList [

	^ haltList ifNil: [ haltList := Set newFrom: #( primitiveFailed subclassResponsibility) ]
]

{ #category : #'private - accessing' }
SWDecoder >> haltList: anObject [

	haltList := anObject
]

{ #category : #testing }
SWDecoder >> isDecoded [
	^ oldPC isNotNil
]

{ #category : #'instruction decoding' }
SWDecoder >> jump: offset [

	(self jumperStack nextPeriodIs: scanner pc) ifTrue: [|item|
		item := self jumperStack pop.
		item endPC: scanner pc + offset.
		item route1: self code slot.
		self code slot: item initialStack.
		self jumperStack push: item.
	].
	super jump: offset.
	
]

{ #category : #'instruction decoding' }
SWDecoder >> jump: offset if: condition [

	self jumperStack push: (SWJumperItem new
		startPC: oldPC;
		endPC: scanner pc + offset;
		condition: self pop;
		initialStack: self code slot copy;
		yourself).

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

{ #category : #api }
SWDecoder >> markAsDecoded [
	oldPC := 9999
]

{ #category : #'instruction decoding' }
SWDecoder >> methodReturnConstant: value [
	self code return << value class.
	super methodReturnConstant: value
]

{ #category : #'instruction decoding' }
SWDecoder >> methodReturnReceiver [
	self code return << self code receiver.
	super methodReturnReceiver

]

{ #category : #'instruction decoding' }
SWDecoder >> methodReturnTop [
	self code return << self pop.
	super methodReturnTop.

]

{ #category : #private }
SWDecoder >> newFullClosure: lit numCopied: num [
	self halt; flag: #toImplement.
"
	^ (self class new: lit with: args)
		pool: self pool;
		classInfo: self classInfo;
		logger: self logger;
		haltList: self haltList;
		yourself
"
]

{ #category : #private }
SWDecoder >> newFullClosure: lit with: args [
	self halt; flag: #toImplement.
	^ (self class new: lit with: args)
		pool: self pool;
		classInfo: self classInfo;
		logger: self logger;
		haltList: self haltList;
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

{ #category : #private }
SWDecoder >> pop [
	^ self code slot pop
]

{ #category : #'instruction decoding' }
SWDecoder >> popIntoLiteralVariable: anAssociation [

	self halt.
	
	super popIntoLiteralVariable: anAssociation 
]

{ #category : #'instruction decoding' }
SWDecoder >> popIntoReceiverVariable: offset [
	(self classInfo getVariableInfoAtOffset: offset) << self code pop.
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

	left := self atOffset: offset.
	right := self pop.

	left << right.

	super popIntoTemporaryVariable: offset.

]

{ #category : #private }
SWDecoder >> popSlotForSender: num [
	^ SWSlot newFrom: ((self code slot pop: num + 1) collect: [ :each | each value ])

]

{ #category : #printing }
SWDecoder >> printOn: aStream [
	self putOn: aStream
]

{ #category : #private }
SWDecoder >> push [
	^ self code slot push
]

{ #category : #private }
SWDecoder >> push: anObject [
	^ self code slot push: anObject
]

{ #category : #'instruction decoding' }
SWDecoder >> pushActiveContext [ 
	self code push: Context.
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
	args := self code pop: numElements.
	self flag: #toImplement.
	"There are no type information for each elements in an Array."
	self code push << Array.
	
	super pushConsArrayWithElements: numElements
]

{ #category : #'instruction decoding' }
SWDecoder >> pushConstant: obj [
	self push << obj class.

	super pushConstant: obj.

]

{ #category : #'instruction decoding' }
SWDecoder >> pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore [
	|decoder ret|
	
	self halt; flag: #toImplement.

	rcvr ifTrue: [ self error ].
	ignore ifTrue: [ self error ].

	"I only interest in type information on the stack.
	So, I decode a closure before invoking. it's ok."
	self logger log: 'decode closure' withStack: self code slot.
	decoder := self newFullClosure: lit with: numCopied
	decoder decode.
	ret := (SWContainerType new: BlockClosure)
		elementType: decoder return value;
		yourself.
	lit hasMethodReturn ifTrue: [
		self return << ret
	].
	self senders at: decoder method sourceNode put: decoder.
	self stack push: (SWVariableTypeInfo new: ret).

	super pushFullClosure: lit numCopied: numCopied  receiverOnStack: rcvr ignoreOuterContext: ignore 
]

{ #category : #'instruction decoding' }
SWDecoder >> pushLiteralVariable: anAssociation [
	self push << anAssociation value class.

	super pushLiteralVariable: anAssociation.

]

{ #category : #'instruction decoding' }
SWDecoder >> pushNewArrayOfSize: numElements [

	self code push << Array.
	
	super pushNewArrayOfSize: numElements 
]

{ #category : #'instruction decoding' }
SWDecoder >> pushReceiver [
	self push: self code slot receiver.

	super pushReceiver.

]

{ #category : #'instruction decoding' }
SWDecoder >> pushReceiverVariable: offset [
	self push: (self classInfo getVariableInfoAtOffset: offset).
	super pushReceiverVariable: offset
]

{ #category : #'instruction decoding' }
SWDecoder >> pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [

	self halt.
	super pushRemoteTemp: remoteTempIndex  inVectorAt: tempVectorIndex 
]

{ #category : #'instruction decoding' }
SWDecoder >> pushTemporaryVariable:  offset [
	self push: (self atOffset: offset).
	super pushTemporaryVariable: offset.

]

{ #category : #streaming }
SWDecoder >> putOn: aStream [
	aStream << self code selector
]

{ #category : #'instruction decoding' }
SWDecoder >> send: selector super: supered numArgs: numberArguments [
	|operands sender|
	self logger log: [ 'decode: ', selector ] withStack: self code slot.
	(self haltList includes: selector) ifTrue: [ self halt ].

	operands := self popSlotForSender: numberArguments.
	sender := (self pool newSenderOf: selector super: supered receiver: self code receiver with: operands)
		node: (self method sourceNodeForPC: oldPC);
		yourself.
	self code senders at: sender node put: sender.
	self push: sender return.

	"A special case for user specifying."
	(selector = #declare:as: and: [ operands receiver value = SWType class ]) ifTrue: [|assoc|
		self halt; flag: #toImplement.
		assoc := (self method sourceNodeForPC: oldPC) evaluate.
		(assoc key = #return ifTrue: [
			self code return
		] ifFalse: [
			self code getVariableInfoOf: assoc key
		])
			<<  assoc value
	].
	super send: selector super: supered numArgs: numberArguments.

]

{ #category : #private }
SWDecoder >> solveJumper [
	|item node sender|
	(self jumperStack nextPeriodIs: scanner pc) ifFalse: [ ^ self  ]. 
	"Below evaluates when ifTrue:ifFalse:."

	item := self jumperStack pop.
	node := self method sourceNodeForPC: item startPC.
	(self haltList includes: node selector) ifTrue: [ self halt ].
	item hasRoute1 ifTrue: [
		self code senders at: node arguments first put: (SWPseudoBlock new
			payload: node arguments first;
			numHiddenArgs: self code numHiddenArgs + self code numTemps;
			slot: item route1;
			senders: self code senders;
			return: item route1 top;
			yourself).
		self code senders at: node arguments second put: (SWPseudoBlock new
			payload: node arguments second;
			numHiddenArgs: self code numHiddenArgs + self code numTemps;
			slot: self code slot copy;
			senders: self code senders;
			return: self top;
			yourself).
		self top << item route1 top
	] ifFalse: [
		self code senders at: node arguments first put: (SWPseudoBlock new
			payload: node arguments first;
			numHiddenArgs: self code numHiddenArgs + self code numTemps;
			slot: self code slot;
			senders: self code senders;
			return: self top;
			yourself).
	].

	sender := self pool newSenderOf: node selector super: false receiver: item condition with: (SWSlot newFrom: { self top }).
	sender node: node.
	self code senders at: node put: sender.
	
	self solveJumper
	
]

{ #category : #'instruction decoding' }
SWDecoder >> storeIntoLiteralVariable: anAssociation [
self halt; flag: #toImplement.
	self getVariableInfoOf: anAssociation key ifPresent: [ :vi |
		vi << self code top
	].
	super storeIntoLiteralVariable: anAssociation
]

{ #category : #'instruction decoding' }
SWDecoder >> storeIntoReceiverVariable: offset [
	(self classInfo getVariableInfoAtOffset: offset) << self top.
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
	left := self atOffset: offset.
	right := self top.
	left << right.

	super storeIntoTemporaryVariable: offset
]

{ #category : #private }
SWDecoder >> top [
	^ self code slot top
]

{ #category : #'instruction decoding' }
SWDecoder >> trap [
	self halt.
	super trap
]
