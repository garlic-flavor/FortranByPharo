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
		'sendStack'
	],
	#classVars : [
		'definedMethods'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'as yet unclassified' }
SWStackAnalyzer class >> binaryOpInfo [
	^ [ :method :types |
		SWMethodInfo new
			method: method;
			variables: (SWVariableInfo newFrom: types);
			return: (SWVariableInfo new
				type: (types at: 1);
				yourself);
			yourself
	]
]

{ #category : #decoding }
SWStackAnalyzer class >> decode: aMethod types: types [
	^ self decode: aMethod types: types sendStack: nil
]

{ #category : #decoding }
SWStackAnalyzer class >> decode: aMethod types: types sendStack: ss [

	^ self definedMethods at: aMethod selector ifPresent: [ :dm |
		dm value: aMethod value: types
	] ifAbsent: [ 	|builder|
		builder := self new
			method: aMethod;
			types: types;
			sendStack: ss;
			decode;
			yourself.
		^ SWMethodInfo new
			method: aMethod;
			variables: builder stack asOrderedCollection;
			return: builder return;
			yourself
	]

]

{ #category : #'as yet unclassified' }
SWStackAnalyzer class >> definedMethods [
	^ definedMethods
]

{ #category : #initialization }
SWStackAnalyzer class >> initialize [
	self installMethods
]

{ #category : #'as yet unclassified' }
SWStackAnalyzer class >> installMethods [
	definedMethods := Dictionary newFrom: (self class methods select: [ :method |
		method selector beginsWith: 'install_'
	] thenCollect: [ :method |
		method valueWithReceiver: self arguments: #().
	])
]

{ #category : #'as yet unclassified' }
SWStackAnalyzer class >> install_eq [
	^ #= -> self binaryOpInfo
]

{ #category : #'as yet unclassified' }
SWStackAnalyzer class >> install_lt [
	^ #< -> self binaryOpInfo
]

{ #category : #'as yet unclassified' }
SWStackAnalyzer class >> install_plus [
	^ #+ -> self binaryOpInfo
]

{ #category : #'as yet unclassified' }
SWStackAnalyzer class >> search: selector in: aClass [
	^ aClass ifNil: [
		nil
	] ifNotNil: [
		aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
		]
	]
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> doDup [
	super doDup.
	self stack push: self stack top

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> doPop [
	super doPop.
	self stack pop.
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnReceiver [
	super methodReturnReceiver.
	self return ifNil: [
		self return: (self stack at: -1)
	]
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> methodReturnTop [
	super methodReturnTop.
	self return ifNil: [
		self return: self stack top
	]
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> popIntoTemporaryVariable: offset [
	|left right|
	super popIntoTemporaryVariable: offset.
	left := self stack at: offset.
	right := self stack pop.
	left << right

]

{ #category : #'private - accessing' }
SWStackAnalyzer >> popSendStack: selector [
	selector = self sendStack pop ifFalse: [
		Exception signal: ('A stacking mismatch was detected: ', selector)
	].
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushConstant: obj [
	super pushConstant: obj.
	self stack push: (SWVariableInfo new
		type: obj class;
		yourself)

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushLiteralVariable: anAssociation [
	super pushLiteralVariable: anAssociation.
	self stack push: (SWVariableInfo new
		type: (anAssociation key
			ifNil: [ anAssociation value class ]
			ifNotNil: [anAssociation key class ]);
		yourself)

]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushReceiver [
	super pushReceiver.
	self stack push: (self stack at: -1)
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> pushTemporaryVariable:  offset [
	super pushTemporaryVariable: offset.
	self stack push: (self stack at: offset)
]

{ #category : #'private - accessing' }
SWStackAnalyzer >> pushToSendStack: selector [
	(self sendStack anySatisfy: [ :each | each = selector ]) ifTrue: [
		Exception signal: ('A circular referencing was detected: ', selector)
	].
	self sendStack push: selector.
]

{ #category : #accessing }
SWStackAnalyzer >> return [

	^ return
]

{ #category : #accessing }
SWStackAnalyzer >> return: anObject [

	return := anObject
]

{ #category : #'instruction decoding' }
SWStackAnalyzer >> send: selector super: supered numArgs: numberArguments [
	|args aTypes targetMethod methodInfo|
	super send: selector super: supered numArgs: numberArguments.
	self pushToSendStack: selector.

	args := self stack pop: numberArguments + 1.
	aTypes := args collect: [ :each | each type ].
	targetMethod := self class search: selector in: (supered ifTrue: [ aTypes first superclass ] ifFalse: [ aTypes first ]).
	targetMethod ifNil: [ self halt ].
	methodInfo := self class decode: targetMethod types: aTypes sendStack: self sendStack.
	args with: (methodInfo variables copyFrom: 1 to: 1 + numberArguments) do: [ :left :right |
		left properties addAll: right properties
	].

	self stack push: (SWVariableInfo new 
		type: methodInfo return type;
		yourself).

	self popSendStack: selector.
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
		self method numTemps + 1 timesRepeat: [
			stack push: SWVariableInfo new
		].

		self types doWithIndex: [ :type :idx |
			(stack at: idx - 2)
				type: type
		].

		(stack at: -1) stackPos: -1.
			
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
