"
I fork decode process of SymbolicBytecodeBuilder to emulate stack status.
"
Class {
	#name : #SWStackAnalyzer,
	#superclass : #SWCompiledCodeInfo,
	#instVars : [
		'jumperStack',
		'tempStore'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

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
	self return << self stack pop.
	
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
	"For a cascade node, create new variable."
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

{ #category : #accessing }
SWStackAnalyzer >> return [

	^ return ifNil: [
		return := SWVariableTypeInfo new: [
			self decode.
			return value
		] with: SWType defaultPriority owner: self pc: oldPC
	]
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> send: selector super: supered numArgs: numberArguments [
	|args methodInfo|

	args := self stack pop: numberArguments + 1.
	args at: 1 put: (supered ifTrue: [ args first copyAsSuper ] ifFalse: [ args first copy ]).

	methodInfo := self pool newMethodTranspiler: selector with: args.
	self messages at: (self method sourceNodeForPC: oldPC) put: methodInfo.
	self stack push: methodInfo return.
self flag: #toRemove.
"
		self stack push: (SWVariableTypeInfo new: [|methodInfo|
			methodInfo := self pool newMethodTranspiler: selector with: args.
			methodInfo return value
		] owner: self pc: oldPC)
	].
"
	"A special case for user specifying."
	(selector = #declare:as: and: [ args first easyValue = SWType class ]) ifTrue: [|assoc|
		assoc := (((self method sourceNodeForPC: oldPC) evaluate)
			owner: self;
			pc: oldPC;
			yourself).
		(self variableInfoOf: assoc key) << assoc value
	].
	super send: selector super: supered numArgs: numberArguments.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> storeIntoLiteralVariable: anAssociation [

	self halt.
	
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
