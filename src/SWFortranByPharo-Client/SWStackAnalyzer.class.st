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

	^ [ :arg1 :arg2 | 
	  | tmp2 tmp4 |
	  tmp2 := SWMethodInfo new.
	  tmp2
		  method: (self search: arg1 in: arg2 first);
		  types: arg2.
	  tmp4 := SWVariableInfo new.
	  tmp4
		  type: (arg2 at: 1);
		  priority: SWVariableInfo wellknownMethodPriority.
	  tmp2
		  return: tmp4 yourself;
		  yourself ]
]

{ #category : #initialization }
SWStackAnalyzer class >> initialize [

	self installMethods
]

{ #category : #initialization }
SWStackAnalyzer class >> installMethods [

	definedMethods := Dictionary newFrom: (self class methods
			                   select: [ :arg1 | 
			                   arg1 selector beginsWith: 'install_' ]
			                   thenCollect: [ :arg2 | 
			                   arg2 valueWithReceiver: self arguments: #(  ) ])
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

{ #category : #initialization }
SWStackAnalyzer class >> install_mul [

	^ #* -> self binaryOpInfo
]

{ #category : #'instance creation' }
SWStackAnalyzer class >> install_new [

	^ #new -> [ :arg1 :arg2 | 
	  | tmp2 tmp4 |
	  tmp2 := SWMethodInfo new.
	  tmp4 := SWVariableInfo new.
	  tmp4
		  type: (arg2 at: 1);
		  priority: SWVariableInfo wellknownMethodPriority.
	  tmp2
		  return: tmp4 yourself;
		  yourself ]
]

{ #category : #initialization }
SWStackAnalyzer class >> install_sub [

	^ #- -> self binaryOpInfo
]

{ #category : #'instance creation' }
SWStackAnalyzer class >> install_yourself [

	^ #yourself -> [ :arg1 :arg2 | 
	  | tmp2 tmp4 |
	  tmp2 := SWMethodInfo new.
	  tmp2 method: Object >> #yourself.
	  tmp4 := SWVariableInfo new.
	  tmp4
		  type: (arg2 at: 1);
		  priority: SWVariableInfo wellknownMethodPriority.
	  tmp2
		  return: tmp4 yourself;
		  yourself ]
]

{ #category : #'instance creation' }
SWStackAnalyzer class >> new: arg1 types: arg2 [

	^ self new: arg1 types: arg2 sendStack: nil
]

{ #category : #'instance creation' }
SWStackAnalyzer class >> new: arg1 types: arg2 sendStack: arg3 [

	^ definedMethods
		  at: arg1
		  ifPresent: [ :arg4 | arg4 value: arg1 value: arg2 ]
		  ifAbsent: [ 
			  | tmp2 |
			  tmp2 := super new: arg1 types: arg2.
			  tmp2
				  sendStack: arg3;
				  yourself ]
]

{ #category : #private }
SWStackAnalyzer >> addBytecode: arg1 [

	super addBytecode: arg1.
	(self jumperStack nextPeriodIs: scanner pc) ifFalse: [ ^ self ].
	self jumperStack pop.
	self mergeStackTopAndSecond
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> blockReturnConstant: arg1 [

	self halt.
	super blockReturnConstant: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> blockReturnTop [

	self halt.
	super blockReturnTop
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> directedSuperSend: arg1 numArgs: arg2 [

	self halt.
	super directedSuperSend: arg1 numArgs: arg2
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> doDup [

	| tmp1 |
	tmp1 := self stack top.
	self stack push: tmp1.
	(self tempStore push: tmp1) ifTrue: [ self addLocalVariable: tmp1 ].
	super doDup
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> doPop [

	self stack pop.
	super doPop
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> jump: arg1 [

	self jumperStack pushAt: scanner pc period: scanner pc + arg1.
	super jump: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> jump: arg1 if: arg2 [

	self jumperStack pushAt: scanner pc period: scanner pc + arg1.
	super jump: arg1 if: arg2
]

{ #category : #'private - accessing' }
SWStackAnalyzer >> jumperStack [

	^ jumperStack
		  ifNil: [ jumperStack := SWJumperStack new ]
		  ifNotNil: [ jumperStack ]
]

{ #category : #'private - accessing' }
SWStackAnalyzer >> jumperStack: arg1 [

	jumperStack := arg1
]

{ #category : #private }
SWStackAnalyzer >> mergeStackTopAndSecond [

	| tmp1 |
	tmp1 := SWVariableInfo new.
	tmp1
		<< self stack pop;
		<< self stack pop.
	self stack push: tmp1
]

{ #category : #protected }
SWStackAnalyzer >> methodInfoOf: arg1 super: arg2 args: arg3 [

	| tmp1 |
	tmp1 := arg3 collect: [ :arg4 | arg4 type ].
	arg2 ifTrue: [ tmp1 first: tmp1 first superclass ].
	^ self class new: arg1 types: tmp1 sendStack: self sendStack
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnConstant: arg1 [

	self halt.
	super methodReturnConstant: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnReceiver [

	self return << (self stack at: 0).
	super methodReturnReceiver
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnTop [

	self return << self stack top.
	super methodReturnTop
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoLiteralVariable: arg1 [

	self halt.
	super popIntoLiteralVariable: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoReceiverVariable: arg1 [

	self halt.
	super popIntoReceiverVariable: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoRemoteTemp: arg1 inVectorAt: arg2 [

	self halt.
	super popIntoRemoteTemp: arg1 inVectorAt: arg2
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoTemporaryVariable: arg1 [

	| tmp1 tmp2 |
	tmp1 := self stack atOffset: arg1.
	tmp2 := self stack pop.
	self halt.
	tmp1 << tmp2.
	super popIntoTemporaryVariable: arg1
]

{ #category : #private }
SWStackAnalyzer >> popSendStack: arg1 [

	arg1 = self sendStack pop ifFalse: [ 
		Exception signal: 'A stacking mismatch was detected: ' , arg1 ]
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
SWStackAnalyzer >> pushClosureCopyNumCopiedValues: arg1 numArgs: arg2 blockSize: arg3 [

	self halt.
	super
		pushClosureCopyNumCopiedValues: arg1
		numArgs: arg2
		blockSize: arg3
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushClosureTemps: arg1 [

	self halt.
	super pushClosureTemps: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushConsArrayWithElements: arg1 [

	self halt.
	super pushConsArrayWithElements: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushConstant: arg1 [

	| tmp2 |
	tmp2 := SWVariableInfo new.
	tmp2 type: arg1 class.
	self stack push: tmp2 yourself.
	super pushConstant: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushFullClosure: arg1 numCopies: arg2 receiverOnStack: arg3 ignoreOuterContext: arg4 [

	self halt.
	super
		pushFullClosure: arg1
		numCopied: arg2
		receiverOnStack: arg3
		ignoreOuterContext: arg4
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushLiteralVariable: arg1 [

	| tmp2 |
	tmp2 := SWVariableInfo new.
	tmp2 type: arg1 value class.
	self stack push: tmp2 yourself.
	super pushLiteralVariable: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushNewArrayOfSize: arg1 [

	self halt.
	super pushNewArrayOfSize: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushReceiver [

	self stack push: (self stack at: 0).
	super pushReceiver
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushReceiverVariable: arg1 [

	| tmp2 |
	tmp2 := SWVariableInfo new.
	tmp2
		initializer: [ (self classInfo getVariableInfoAt: arg1) type ];
		priority: 10.
	self stack push: tmp2 yourself.
	super pushReceiverVariable: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushRemoteTemp: arg1 inVectorAt: arg2 [

	self halt.
	super pushRemoteTemp: arg1 inVectorAt: arg2
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushTemporaryVariable: arg1 [

	self stack push: (self stack atOffset: arg1).
	super pushTemporaryVariable: arg1
]

{ #category : #private }
SWStackAnalyzer >> pushToSendStack: arg1 [

	(self sendStack anySatisfy: [ :arg2 | arg2 = arg1 ]) ifTrue: [ 
		Exception signal: 'A circular referencing detected: ' ].
	self sendStack push: arg1
]

{ #category : #accessing }
SWStackAnalyzer >> return [

	^ return
		  ifNil: [ 
			  | tmp2 |
			  tmp2 := SWVariableInfo new.
			  tmp2
				  initializer: [ 
					  self
						  pushToSendStack: self method;
						  decode;
						  popSendStack: self method.
					  return type ];
				  priority: SWVariableInfo defaultReturnTypePriority.
			  return := tmp2 yourself ]
		  ifNotNil: [ return ]
]

{ #category : #protected }
SWStackAnalyzer >> returnInfoOf: arg1 super: arg2 args: arg3 [

	^ definedMethods
		  at: arg1
		  ifPresent: [ :arg4 | 
			  | tmp2 |
			  tmp2 := SWVariableInfo new.
			  tmp2
				  initializer: [ 
					  arg4
						  value: arg1
						  value: (arg3 collect: [ :arg5 | arg5 type ]) return type ];
				  priority: { 
						  SWVariableInfo wellknownMethodPriority.
						  (arg3 collect: [ :arg6 | arg6 priority ]) } flattened min;
				  yourself ]
		  ifAbsent: [ 
			  | tmp4 |
			  tmp4 := SWVariableInfo new.
			  tmp4
				  initializer: [ 
					  | tmp5 tmp7 |
					  tmp5 := arg3 collect: [ :arg7 | arg7 type ].
					  arg2 ifTrue: [ tmp5 first: tmp5 first superclass ].
					  tmp7 := self class new.
					  tmp7
						  method: (self class search: arg1 in: tmp5 first);
						  types: tmp5;
						  sendStack: self sendStack.
					  tmp7 yourself return type ];
				  priority: { 
						  SWVariableInfo unknownMethodPriority.
						  (arg3 collect: [ :arg8 | arg8 priority ]) } flattened min;
				  yourself ]
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> send: arg1 super: arg2 numArgs: arg3 [

	| tmp1 |
	tmp1 := self stack pop: arg3 + 1.
	self stack push: (self returnInfoOf: arg1 super: arg2 args: tmp1).
	super send: arg1 super: arg2 numArgs: arg3
]

{ #category : #'private - accessing' }
SWStackAnalyzer >> sendStack [

	^ sendStack ifNil: [ sendStack := Stack new ] ifNotNil: [ sendStack ]
]

{ #category : #'private - accessing' }
SWStackAnalyzer >> sendStack: arg1 [

	sendStack := arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> storeIntoLiteralVariable: arg1 [

	self halt.
	super storeIntoLiteralVariable: arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> storeIntoRemoteTemp: arg1 inVectorAt: arg2 [

	self halt.
	super storeIntoRemoteTemp: arg1 inVectorAt: arg2
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> storeIntoTemporaryVariable: arg1 [

	| tmp1 tmp2 |
	tmp1 := self stack atOffset: arg1.
	tmp2 := self stack top.
	tmp1 << tmp2.
	super storeIntoTemporaryVariable: arg1
]

{ #category : #accessing }
SWStackAnalyzer >> tempStore [

	^ tempStore
		  ifNil: [ 
			  | tmp2 |
			  tmp2 := SWTempStore new.
			  tmp2 method: self method.
			  tempStore := tmp2 yourself ]
		  ifNotNil: [ tempStore ]
]

{ #category : #accessing }
SWStackAnalyzer >> tempStore: arg1 [

	tempStore := arg1
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> trap [

	self halt.
	super trap
]
