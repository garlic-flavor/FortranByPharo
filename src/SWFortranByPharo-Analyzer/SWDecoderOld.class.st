"
SWStackAnalyzer forks decode process of SymbolicBytecodeBuilder to emulate stack status.
"
Class {
	#name : #SWDecoderOld,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'code',
		'pool',
		'classInfo',
		'jumperStack',
		'haltList',
		'logger'
	],
	#category : #'SWFortranByPharo-Analyzer-Olds'
}

{ #category : #'instance creation' }
SWDecoderOld class >> classTranspilerClass [
	^ SWClassInfo
]

{ #category : #'instance creation' }
SWDecoderOld class >> new: aCompiledCode [
	^ self new
		code: aCompiledCode;
		yourself
]

{ #category : #'as yet unclassified' }
SWDecoderOld class >> poolClass [
	^ SWGlobal
]

{ #category : #accessing }
SWDecoderOld class >> senderTranspilerClass [
	^ SWSenderOld
]

{ #category : #private }
SWDecoderOld >> addBytecode: description [

	self logger log: [ String streamContents: [ :s |
		s << '[' print: oldPC; << '] '; << description
	] ] withStack: self code slot.
	super addBytecode: description.

	self solveJumper

]

{ #category : #private }
SWDecoderOld >> atOffset: offset [
	^ self code slot atOffset: offset
]

{ #category : #'instruction decoding' }
SWDecoderOld >> blockReturnConstant: cst [
	self halt.
	
	super blockReturnConstant: cst
]

{ #category : #'instruction decoding' }
SWDecoderOld >> blockReturnTop [
	self code return << self code top.
	
	super blockReturnTop
]

{ #category : #'instruction decoding' }
SWDecoderOld >> callPrimitive: primNumber [

	super callPrimitive: primNumber
]

{ #category : #accessing }
SWDecoderOld >> classInfo [
	"This is a SWClass"
	^ classInfo
]

{ #category : #accessing }
SWDecoderOld >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #accessing }
SWDecoderOld >> code [

	^ code
]

{ #category : #accessing }
SWDecoderOld >> code: anObject [

	code := anObject.
	method := code payload.
]

{ #category : #api }
SWDecoderOld >> decode [
	self code isDecodable ifFalse: [ ^ self ].
	self isDecoded ifTrue: [ ^self ].
	self logger log: 'decoding start' withStack: self code slot.
	super decode.
	^ code

]

{ #category : #'instruction decoding' }
SWDecoderOld >> directedSuperSend: selector numArgs: numberArguments [

	self halt.
	
	super directedSuperSend: selector numArgs: numberArguments 
]

{ #category : #'instruction decoding' }
SWDecoderOld >> doDup [
	self code slot push: self code slot top.
	super doDup.

]

{ #category : #'instruction decoding' }
SWDecoderOld >> doPop [
	self pop.
	super doPop.

]

{ #category : #adding }
SWDecoderOld >> haltAt: selector [
	self haltList add: selector
]

{ #category : #'private - accessing' }
SWDecoderOld >> haltList [

	^ haltList ifNil: [ haltList := Set newFrom: #( primitiveFailed subclassResponsibility) ]
]

{ #category : #'private - accessing' }
SWDecoderOld >> haltList: anObject [

	haltList := anObject
]

{ #category : #testing }
SWDecoderOld >> isDecoded [
	^ oldPC isNotNil
]

{ #category : #'instruction decoding' }
SWDecoderOld >> jump: offset [

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
SWDecoderOld >> jump: offset if: condition [

	self jumperStack push: (SWJumperItem new
		startPC: oldPC;
		endPC: scanner pc + offset;
		condition: self pop;
		initialStack: self code slot copy;
		yourself).

	super jump: offset if: condition.

]

{ #category : #'private - accessing' }
SWDecoderOld >> jumperStack [

	^ jumperStack ifNil: [ jumperStack := SWJumperStack new ]
]

{ #category : #'private - accessing' }
SWDecoderOld >> jumperStack: anObject [

	jumperStack := anObject
]

{ #category : #accessing }
SWDecoderOld >> logger [

	^ logger ifNil: [ logger := SWLogger new ]
]

{ #category : #accessing }
SWDecoderOld >> logger: anObject [

	logger := anObject
]

{ #category : #api }
SWDecoderOld >> markAsDecoded [
	oldPC := 9999
]

{ #category : #'instruction decoding' }
SWDecoderOld >> methodReturnConstant: value [
	self code return << value class.
	super methodReturnConstant: value
]

{ #category : #'instruction decoding' }
SWDecoderOld >> methodReturnReceiver [
	self code return << self code receiver.
	super methodReturnReceiver

]

{ #category : #'instruction decoding' }
SWDecoderOld >> methodReturnTop [
	self code return << self pop.
	super methodReturnTop.

]

{ #category : #private }
SWDecoderOld >> newFullClosure: lit numCopied: num [
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
SWDecoderOld >> newFullClosure: lit with: args [
	self halt; flag: #toImplement.
	^ (self class new: lit with: args)
		pool: self pool;
		classInfo: self classInfo;
		logger: self logger;
		haltList: self haltList;
		yourself


]

{ #category : #accessing }
SWDecoderOld >> pool [

	^ pool ifNil: [
		pool := self class poolClass new
			owner: self;
			yourself
	]
]

{ #category : #accessing }
SWDecoderOld >> pool: anObject [

	pool := anObject

]

{ #category : #private }
SWDecoderOld >> pop [
	^ self code slot pop
]

{ #category : #'instruction decoding' }
SWDecoderOld >> popIntoLiteralVariable: anAssociation [

	self halt.
	
	super popIntoLiteralVariable: anAssociation 
]

{ #category : #'instruction decoding' }
SWDecoderOld >> popIntoReceiverVariable: offset [
	(self classInfo getVariableInfoAtOffset: offset) << self code pop.
	super popIntoReceiverVariable: offset
]

{ #category : #'instruction decoding' }
SWDecoderOld >> popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [

	self halt.
	
	super popIntoRemoteTemp: remoteTempIndex  inVectorAt: tempVectorIndex 
]

{ #category : #'instruction decoding' }
SWDecoderOld >> popIntoTemporaryVariable: offset [
	|left right|

	left := self atOffset: offset.
	right := self pop.

	left << right.

	super popIntoTemporaryVariable: offset.

]

{ #category : #private }
SWDecoderOld >> popSlotForSender: num [
	^ SWSlot newFrom: ((self code slot pop: num + 1) collect: [ :each | each value ])

]

{ #category : #printing }
SWDecoderOld >> printOn: aStream [
	self putOn: aStream
]

{ #category : #private }
SWDecoderOld >> push [
	^ self code slot push
]

{ #category : #private }
SWDecoderOld >> push: anObject [
	^ self code slot push: anObject
]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushActiveContext [ 
	self code push: Context.
	super pushActiveContext
]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushActiveProcess [ 
	self halt.
	super pushActiveProcess 
]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize [

	self halt.
	
	super pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize 
]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushClosureTemps: numTemps [

	self halt.
	
	super pushClosureTemps: numTemps
]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushConsArrayWithElements: numElements [

	|args|
	args := self code pop: numElements.
	self flag: #toImplement.
	"There are no type information for each elements in an Array."
	self code push << Array.
	
	super pushConsArrayWithElements: numElements
]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushConstant: obj [
	self push << obj class.

	super pushConstant: obj.

]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore [
	|decoder ret|
	
	self halt; flag: #toImplement.

	rcvr ifTrue: [ self error ].
	ignore ifTrue: [ self error ].

	"I only interest in type information on the stack.
	So, I decode a closure before invoking. it's ok."
	self logger log: 'decode closure' withStack: self code slot.
	decoder := self newFullClosure: lit with: numCopied
	decoder decode.
	ret := (SWContainer new: BlockClosure)
		elementType: decoder return value;
		yourself.
	lit hasMethodReturn ifTrue: [
		self return << ret
	].
	self senders at: decoder method sourceNode put: decoder.
	self stack push: (SWVariable new: ret).

	super pushFullClosure: lit numCopied: numCopied  receiverOnStack: rcvr ignoreOuterContext: ignore 
]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushLiteralVariable: anAssociation [
	self push << anAssociation value class.

	super pushLiteralVariable: anAssociation.

]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushNewArrayOfSize: numElements [

	self code push << Array.
	
	super pushNewArrayOfSize: numElements 
]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushReceiver [
	self push: self code slot receiver.

	super pushReceiver.

]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushReceiverVariable: offset [
	self push: (self classInfo getVariableInfoAtOffset: offset).
	super pushReceiverVariable: offset
]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [

	self halt.
	super pushRemoteTemp: remoteTempIndex  inVectorAt: tempVectorIndex 
]

{ #category : #'instruction decoding' }
SWDecoderOld >> pushTemporaryVariable:  offset [
	self push: (self atOffset: offset).
	super pushTemporaryVariable: offset.

]

{ #category : #streaming }
SWDecoderOld >> putOn: aStream [
	aStream << self code selector
]

{ #category : #'instruction decoding' }
SWDecoderOld >> send: selector super: supered numArgs: numberArguments [
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
SWDecoderOld >> solveJumper [
	|item node sender|
	(self jumperStack nextPeriodIs: scanner pc) ifFalse: [ ^ self  ]. 
	"Below evaluates when ifTrue:ifFalse:."

	item := self jumperStack pop.
	node := self method sourceNodeForPC: item startPC.
	(self haltList includes: node selector) ifTrue: [ self halt ].
	item hasRoute1 ifTrue: [
		self code senders at: node arguments first put: (SWPseudoBlockOld new
			payload: node arguments first;
			numHiddenArgs: self code numHiddenArgs + self code numTemps;
			slot: item route1;
			senders: self code senders;
			return: item route1 top;
			yourself).
		self code senders at: node arguments second put: (SWPseudoBlockOld new
			payload: node arguments second;
			numHiddenArgs: self code numHiddenArgs + self code numTemps;
			slot: self code slot copy;
			senders: self code senders;
			return: self top;
			yourself).
		self top << item route1 top
	] ifFalse: [
		self code senders at: node arguments first put: (SWPseudoBlockOld new
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
SWDecoderOld >> storeIntoLiteralVariable: anAssociation [
self halt; flag: #toImplement.
	self getVariableInfoOf: anAssociation key ifPresent: [ :vi |
		vi << self code top
	].
	super storeIntoLiteralVariable: anAssociation
]

{ #category : #'instruction decoding' }
SWDecoderOld >> storeIntoReceiverVariable: offset [
	(self classInfo getVariableInfoAtOffset: offset) << self top.
	super storeIntoReceiverVariable: offset
]

{ #category : #'instruction decoding' }
SWDecoderOld >> storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	self halt.
	super storeIntoRemoteTemp: remoteTempIndex  inVectorAt: tempVectorIndex 
]

{ #category : #'instruction decoding' }
SWDecoderOld >> storeIntoTemporaryVariable: offset [
	|left right|
	left := self atOffset: offset.
	right := self top.
	left << right.

	super storeIntoTemporaryVariable: offset
]

{ #category : #private }
SWDecoderOld >> top [
	^ self code slot top
]

{ #category : #'instruction decoding' }
SWDecoderOld >> trap [
	self halt.
	super trap
]
