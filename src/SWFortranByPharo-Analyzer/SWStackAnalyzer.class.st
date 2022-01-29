"
SWStackAnalyzer forks decode process of SymbolicBytecodeBuilder to emulate stack status.
"
Class {
	#name : #SWStackAnalyzer,
	#superclass : #SWCompiledCode,
	#instVars : [
		'jumperStack',
		'tempStore',
		'pool',
		'logger',
		'debugMode'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #initialization }
SWStackAnalyzer class >> initializeDefaultClassTranspiler: transpiler [
	self error; flag: #toRemove.
"
	transpiler
		defineMethod: #= as: Boolean;
		defineMethod: #== as: Boolean;
		defineMethod: #~= as: Boolean;
		defineMethod: #< as: Boolean;
		defineMethod: #> as: Boolean;
		defineMethod: #>= as: Boolean;
		defineMethod: #<= as: Boolean;
		defineMethodAsBinaryOperator: #+;
		defineMethodReturnsReceiver: #* with: [:t :node | t putOpBinary: node ];
		defineMethodReturnsReceiver: #-;
		defineMethodReturnsReceiver: #error:;
		defineMethodReturnsReceiversInstance: #basicNew;
		defineMethodReturnsReceiversInstance: #basicNew:;
		defineMethodReturnsSecondArgument: #at:put:;
		defineMethodReturnsSecondArgument: #at:ifAbsent:;
		defineMethod: #asInteger as: Integer;
		defineMethod: #asString as: String
"
]

{ #category : #'as yet unclassified' }
SWStackAnalyzer class >> poolClass [
	^ SWPool
]

{ #category : #private }
SWStackAnalyzer >> addBytecode: description [
	|item node operands sender beforeSize|
	super addBytecode: description.

	(self jumperStack nextPeriodIs: scanner pc) ifFalse: [ ^ self  ]. 

	"Below evaluates when ifTrue:ifFalse:."
	item := self jumperStack pop.
	node := self method sourceNodeForPC: item startPC.
	operands := self stack pop: self stack size - item stackSize + 1.
	sender := self pool newSenderOf: node selector super: false with: operands.
	self senders at: node put: sender.
	self stack push: sender return.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> blockReturnConstant: cst [
	self halt.
	
	super blockReturnConstant: cst
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> blockReturnTop [
	self return << self stack pop.
	
	super blockReturnTop
]

{ #category : #accessing }
SWStackAnalyzer >> bodyGenerator: aBodyGenerator [
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> callPrimitive: primNumber [

	super callPrimitive: primNumber
]

{ #category : #accessing }
SWStackAnalyzer >> debugMode [

	^ debugMode
]

{ #category : #accessing }
SWStackAnalyzer >> debugMode: trueOrFalse [

	debugMode := trueOrFalse.
	self logger enabled: trueOrFalse
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
	"For a cascade node, create new variable."
	self flag: #toRemove.
"
	(self tempStore push: top) ifTrue: [
		self addLocalVariable: top
	].
"
	super doDup.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> doPop [
	self stack pop.
	super doPop.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> jump: offset [
	self jumperStack update: scanner pc + offset.
	super jump: offset.
	
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> jump: offset if: condition [

	self jumperStack pushAt: oldPC period: scanner pc + offset size: self stack size.

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

{ #category : #accessing }
SWStackAnalyzer >> logger [

	^ logger ifNil: [ logger := SWLogger new ]
]

{ #category : #accessing }
SWStackAnalyzer >> logger: anObject [

	logger := anObject
]

{ #category : #private }
SWStackAnalyzer >> mergeStackTopAndSecond [
	|right|
	right := self stack pop.
	self stack top << right.


]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnConstant: value [
	self return << (SWVariableTypeInfo new: value class owner: self pc: oldPC).
	super methodReturnConstant: value
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnReceiver [
	self return << (self stack at: 0).
	super methodReturnReceiver

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnTop [
	self return << self stack pop.
	super methodReturnTop.

]

{ #category : #'instance creation' }
SWStackAnalyzer >> newFullClosure: lit with: args [
	^ (self class new: lit with: args)
		pool: self pool;
		classInfo: self classInfo;
		yourself


]

{ #category : #accessing }
SWStackAnalyzer >> pool [

	^ pool ifNil: [
		pool := self class poolClass new
			owner: self;
			yourself
	]
]

{ #category : #accessing }
SWStackAnalyzer >> pool: anObject [

	pool := anObject

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoLiteralVariable: anAssociation [

	self halt.
	
	super popIntoLiteralVariable: anAssociation 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoReceiverVariable: offset [
	(self classInfo getVariableInfoAtOffset: offset) << self stack pop.
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

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushActiveContext [ 
	self stack push: (SWVariableTypeInfo new: Context owner: self pc: oldPC).
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

	|args|
	args := self stack pop: numElements.
	self flag: #toImplement.
	"There are no type information for each elements in an Array."
	self stack push: (SWVariableTypeInfo new: Array).
	
	super pushConsArrayWithElements: numElements
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushConstant: obj [
	self stack push: (SWVariableTypeInfo new: obj class owner: self pc: oldPC).

	super pushConstant: obj.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushFullClosure: lit numCopied: numCopied receiverOnStack: rcvr ignoreOuterContext: ignore [
	|args mi|

	rcvr ifTrue: [ self error ].
	ignore ifTrue: [ self error ].
	args := OrderedCollection new: numCopied + 1.
	args add: self stack first.
	args addAll: (self stack pop: numCopied).
	
	"I only interest in type information on the stack.
	So, I decode a closure before invoking. it's ok."
	mi := self newFullClosure: lit with: args.
	mi decode.
	lit hasMethodReturn ifTrue: [
		self return << mi return
	].
	self messages addAll: mi messages.
	self stack push: mi return.

	super pushFullClosure: lit numCopied: numCopied  receiverOnStack: rcvr ignoreOuterContext: ignore 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushLiteralVariable: anAssociation [
	self stack push: (SWVariableTypeInfo new: anAssociation value class owner: self pc: oldPC).

	super pushLiteralVariable: anAssociation.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushNewArrayOfSize: numElements [

	self stack push: (SWVariableTypeInfo new: Array owner: self pc: oldPC).
	
	super pushNewArrayOfSize: numElements 
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushReceiver [
	self stack push: (self stack at: 0).

	super pushReceiver.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushReceiverVariable: offset [
	self stack push: (self classInfo getVariableInfoAtOffset: offset).
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

{ #category : #'instruction decoding' }
SWStackAnalyzer >> send: selector super: supered numArgs: numberArguments [
	|operands sender|
	self logger log: [ 'decode: ', selector ] withStack: self stack.

	operands := self stack pop: numberArguments + 1.
	sender := self pool newSenderOf: selector super: supered with: operands.

	self senders at: (self method sourceNodeForPC: oldPC) put: sender.
	self stack push: sender return.
"
	self error; flag: #toRewrite.
	methodInfo := self pool getMethodTranspiler: selector supered: supered with: args.

	self messages at: (self method sourceNodeForPC: oldPC) put: methodInfo.
	self stack push: methodInfo return.
"
	"A special case for user specifying."
	(selector = #declare:as: and: [ operands first value = SWType class ]) ifTrue: [|assoc|
		assoc := (self method sourceNodeForPC: oldPC) evaluate.
		(assoc value)
			owner: self;
			pc: oldPC.
		(self getVariableInfoOf: assoc key) << assoc value
	].
	super send: selector super: supered numArgs: numberArguments.

]

{ #category : #accessing }
SWStackAnalyzer >> senderGenerator: aCalleeGenerator [
	self error; flag: #toRemove.
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> storeIntoLiteralVariable: anAssociation [
self halt.
	(self getVariableInfoOf: anAssociation key) << self stack top.
	super storeIntoLiteralVariable: anAssociation
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> storeIntoReceiverVariable: offset [
	(self classInfo getVariableInfoAtOffset: offset) << self stack top.
	super storeIntoReceiverVariable: offset
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
	self error; flag: #toRemove.

	^ tempStore ifNil: [
		tempStore := SWTempStore new
			method: self method;
			yourself
	]
]

{ #category : #accessing }
SWStackAnalyzer >> tempStore: anObject [
	self error; flag: #toRemove.
	tempStore := anObject
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> trap [
	self halt.
	super trap
]
