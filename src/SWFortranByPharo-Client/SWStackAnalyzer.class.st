"
I analyze bytecodes of a method. See also, SymbolicBytecodeBuilder.
"
Class {
	#name : #SWStackAnalyzer,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'stack',
		'return',
		'types',
		'sendStack',
		'jumperStack'
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
			variables: (SWVariableInfo newFrom: types);
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
	^ self definedMethods at: selector ifPresent: [ :dm |
		dm value: selector value: types
	] ifAbsent: [
		self new
			method: (self search: selector in: types first);
			types: types;
			sendStack: ss;
			decode
	]

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
			method: nil;
			variables: (SWVariableInfo newFrom: types);
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

{ #category : #utils }
SWStackAnalyzer class >> search: selector in: aClass [
	^ aClass ifNil: [
		nil
	] ifNotNil: [
		aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
		]
	]
]

{ #category : #adding }
SWStackAnalyzer >> addBytecode: description [
	super addBytecode: description.
	(self jumperStack nextPeriodIs: scanner pc) ifTrue: [
		self mergeStackAbove: self jumperStack pop
	]
]

{ #category : #api }
SWStackAnalyzer >> decode [
	self pushToSendStack: self method.
	super decode.
	self popSendStack: self method.
	^ SWMethodInfo new
		method: self method;
		variables: self stack asOrderedCollection;
		return: self return;
		yourself
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> doDup [
	self stack push: self stack top.
	super doDup.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> doPop [
	self stack pop.
	super doPop.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> jump: offset [
	self jumperStack pushAt: scanner pc period: scanner pc + offset stackSize: self stack size.
	super jump: offset.
	
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> jump: offset if: condition [
	self stack pop.
	self jumperStack pushAt: scanner pc period: scanner pc + offset stackSize: self stack size.
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

{ #category : #'private utils' }
SWStackAnalyzer >> mergeStackAbove: size [
	[
		size + 1 < self stack size ifTrue: [ | right |
			right := self stack pop.
			self stack top << right.
		] ifFalse: [ false ]
	] whileTrue.
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnReceiver [
	self return << (self stack at: -1).
	super methodReturnReceiver

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnTop [
	self return << self stack top.
	super methodReturnTop.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoTemporaryVariable: offset [
	|left right|
	left := self stack at: offset.
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
SWStackAnalyzer >> pushConstant: obj [
	self stack push: (SWVariableInfo new
		type: obj class;
		yourself).

	super pushConstant: obj.

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
SWStackAnalyzer >> pushReceiver [
	self stack push: (self stack at: -1).

	super pushReceiver.

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushTemporaryVariable:  offset [
	self stack push: (self stack at: offset).
	super pushTemporaryVariable: offset.

]

{ #category : #'private - accessing' }
SWStackAnalyzer >> pushToSendStack: aMethod [
	(self sendStack anySatisfy: [ :each | each = aMethod ]) ifTrue: [
		Exception signal: 'A circular referencing detected: '. aMethod
	].
	self sendStack push: aMethod.

]

{ #category : #accessing }
SWStackAnalyzer >> return [

	^ return ifNil: [
		return := SWVariableInfo new
	]
]

{ #category : #accessing }
SWStackAnalyzer >> return: anObject [

	return := anObject
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

{ #category : #accessing }
SWStackAnalyzer >> stack [
	"stack holds indices of  referred temporary values or nil."
	"At index -1 on the stack indicates the VariableInfor for receiver"
	^ stack ifNil: [|vars|
		vars := self method temporaryVariables.
		stack := SWStack new.
		"Reserve slots."
		self method numTemps + 1 timesRepeat: [
			stack push: SWVariableInfo new
		].

		"Set types of the receiver and arguments."
		self types doWithIndex: [ :type :idx |
			(stack at: idx - 2)
				type: type
		].

		"Set stack position of the receiver."
		(stack at: -1) stackPos: -1.
			
		"Set stack positions of arguments"
		self method temporaryVariables doWithIndex: [ :var :idx |
			(stack at: idx -1)
				name: var name;
				stackPos: idx - 1
		].

		stack
	]
]

{ #category : #accessing }
SWStackAnalyzer >> stack: anObject [

	stack := anObject
]

{ #category : #accessing }
SWStackAnalyzer >> types [

	^ types
]

{ #category : #accessing }
SWStackAnalyzer >> types: anObject [

	types := anObject
]
