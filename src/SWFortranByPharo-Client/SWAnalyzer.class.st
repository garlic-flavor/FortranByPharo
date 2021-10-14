"
I analyze Pharo code.
"
Class {
	#name : #SWAnalyzer,
	#superclass : #Object,
	#instVars : [
		'variables',
		'methods'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'as yet unclassified' }
SWAnalyzer class >> mangledNameOf: aClass s: aSelector with: argumentTypes [
	^ aClass name, '#', aSelector, ('/' join: (argumentTypes collect: [:each | each name]))
]

{ #category : #'as yet unclassified' }
SWAnalyzer class >> search: aClass s: aMethodName [
	^ aClass methodDict at: aMethodName ifAbsent: [
		self search: aClass superclass s: aMethodName
	]
]

{ #category : #'code generation - protected' }
SWAnalyzer >> addArgumentsOf: method with: argumentTypes [
	method argumentNames with: argumentTypes collect: [ :name :type |
		self addVariable: name as: type
	].

]

{ #category : #'code generation - protected' }
SWAnalyzer >> addVariable: aName as: aType [
	self variables at: aName put:  (SWVariableInfo new
		name: aName;
		type: aType;
		yourself)
]

{ #category : #'public API' }
SWAnalyzer >> analyze: aClass s: aMethod with: argumentTypes [
	|method explicitReturnType|
	method := self class search: aClass s: aMethod.
	explicitReturnType := self
		addVariable: #self as: aClass;
		addArgumentsOf: method with: argumentTypes;
		solveTypesOfLocalVariablesOf: method;
		gatherDependenciesOf: method;
		explicitReturnTypeOf: method.

	^ SWMethodInfo new
		argumentTypes: argumentTypes;
		mangledName: (self class mangledNameOf: aClass s: aMethod with: argumentTypes);
		name: aMethod;
		owner: aClass;
		explicitReturnType: explicitReturnType;
		variables: self variables;
		yourself
]

{ #category : #'code generation' }
SWAnalyzer >> assign: aVariable with: aValue [
	^ (self variables at: aVariable name ifAbsentPut: [
		SWVariableInfo new
			name: aVariable name;
			type: (aValue transpileUsing: self);
			yourself
	]) type

]

{ #category : #'as yet unclassified' }
SWAnalyzer >> classFilter: aClass [
	^ aClass name beginsWith: 'SW'
]

{ #category : #'code generation - protected' }
SWAnalyzer >> explicitReturnTypeOf: method [
	^ method sourceNode allStatements detect: [ :aNode |
		aNode class = RBReturnNode
	] ifFound: [:aNode |
		aNode transpileUsing: self
	] ifNone: [
		nil
	].

]

{ #category : #'code generation - protected' }
SWAnalyzer >> gatherDependenciesOf: method [
	method sendNodes do: [ :aNode |
		aNode transpileUsing: self
	].

]

{ #category : #accessing }
SWAnalyzer >> methods [

	^ methods ifNil: [ methods := Dictionary new ]
]

{ #category : #accessing }
SWAnalyzer >> methods: anObject [

	methods := anObject
]

{ #category : #'code generation' }
SWAnalyzer >> putBlock: aBlock [
	^ self putSequence: aBlock body
]

{ #category : #'code generation' }
SWAnalyzer >> putCascade: aCascadeNode [
	|expType|
	aCascadeNode messages do: [ :aNode |
		expType := aNode transpileUsing: self
	].
	^ expType
]

{ #category : #'code generation' }
SWAnalyzer >> putInteger: anInteger [
	^ Integer
	
]

{ #category : #'code generation' }
SWAnalyzer >> putMessage: aReceiver call: aSelector with: arguments [
	|receiverClass argumentTypes mangledName methodInfo|
	receiverClass := aReceiver transpileUsing: self.
	(self classFilter: receiverClass) ifFalse: [ ^ Object ].

	argumentTypes := arguments collect: [ :each | each transpileUsing: self ].
	mangledName := self class mangledNameOf: receiverClass s: aSelector with: argumentTypes.
	methodInfo := self methods at: mangledName ifAbsentPut: [
		self subAnalyzer analyze: receiverClass s: aSelector with: argumentTypes
	].
	^ methodInfo returnType

]

{ #category : #'code generation' }
SWAnalyzer >> putReturn: value [
	^ (value transpileUsing: self).

]

{ #category : #'code generation' }
SWAnalyzer >> putSequence: aRBSequenceNode [
	|expType|
	aRBSequenceNode statements do: [ :each |
		expType := each transpileUsing: self
	].
	^ expType
]

{ #category : #'code generation' }
SWAnalyzer >> putVariable: aVariable [
	^ self variables at: aVariable name ifPresent: [ :vi |
		vi type
	]ifAbsent: [
		(Smalltalk globals at: aVariable name ifAbsent: [Object]) class
	]

]

{ #category : #'code generation - protected' }
SWAnalyzer >> solveTypesOfLocalVariablesOf: method [
	method assignmentNodes do: [ :aNode |
		aNode transpileUsing: self
	].

]

{ #category : #'public API' }
SWAnalyzer >> subAnalyzer [
	^ self class new
		methods: self methods
		yourself
]

{ #category : #accessing }
SWAnalyzer >> variables [

	^ variables ifNil: [ variables := Dictionary new ]
]

{ #category : #accessing }
SWAnalyzer >> variables: anObject [

	variables := anObject
]