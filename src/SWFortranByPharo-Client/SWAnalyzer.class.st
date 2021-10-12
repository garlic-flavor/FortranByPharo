Class {
	#name : #SWAnalyzer,
	#superclass : #Object,
	#instVars : [
		'variables',
		'methods',
		'returnType'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'as yet unclassified' }
SWAnalyzer class >> mangledNameOf: aClass s: aSelector with: argumentTypes [
	^ aClass class name, '#', aSelector, ('/' join: (argumentTypes collect: [:each | each name]))
]

{ #category : #'as yet unclassified' }
SWAnalyzer >> analyze: aClass s: aMethod with: argumentTypes [
	|method|
	method := aClass class methodDictionary at: aMethod.
	self variables
		at: #self put: aClass.
	method argumentNames with: argumentTypes collect: [ :name :type |
		self variables at: name put: type
	].
	(aClass respondsTo: #returnTypeOf:with:) ifTrue: [
		self returnType: (aClass returnTypeOf: aMethod with: argumentTypes)
	] ifFalse: [ 
		self putSequence: method sourceNode body
	].
	^ SWMethodInfo new
		argumentTypes: argumentTypes;
		mangledName: (self class mangledNameOf: aClass s: aMethod with: argumentTypes);
		name: aMethod;
		owner: aClass;
		returnType: self returnType;
		variables: self variables;
		yourself
]

{ #category : #'code generation' }
SWAnalyzer >> assign: aVariable with: aValue [
	self variables at: aVariable name put: (aValue transpileUsing: self).

]

{ #category : #accessing }
SWAnalyzer >> methods [

	^ methods ifNil: [ methods := Dictionary new ]
]

{ #category : #accessing }
SWAnalyzer >> methods: anObject [

	methods := anObject
]

{ #category : #'as yet unclassified' }
SWAnalyzer >> putInteger: anInteger [
	^ Integer
	
]

{ #category : #'code generation' }
SWAnalyzer >> putMessage: aReceiver call: aSelector with: arguments [
	|receiverClass argumentTypes mangledName methodInfo|
	receiverClass := aReceiver transpileUsing: self.
	argumentTypes := arguments collect: [ :each | each transpileUsing: self ].
	mangledName := self class mangledNameOf: receiverClass s: aSelector with: argumentTypes.
	methodInfo := self methods at: mangledName ifAbsentPut: [
		self class new
			methods: self methods;
			analyze: receiverClass s: aSelector with: argumentTypes
	].
	^ methodInfo returnType

]

{ #category : #'as yet unclassified' }
SWAnalyzer >> putReturn: value [
	self returnType: (value transpileUsing: self).
	^ self returnType
]

{ #category : #'as yet unclassified' }
SWAnalyzer >> putSequence: aRBSequenceNode [
	|expType|
	aRBSequenceNode statements do: [ :each |
		expType := each transpileUsing: self
	].
	^ expType
]

{ #category : #'code generation' }
SWAnalyzer >> putVariable: aVariable [
	^ self variables at: aVariable name ifAbsent: [
		Smalltalk globals at: aVariable name
	]

]

{ #category : #accessing }
SWAnalyzer >> returnType [

	^ returnType
]

{ #category : #accessing }
SWAnalyzer >> returnType: anObject [

	returnType := anObject
]

{ #category : #accessing }
SWAnalyzer >> variables [

	^ variables ifNil: [ variables := Dictionary new ]
]

{ #category : #accessing }
SWAnalyzer >> variables: anObject [

	variables := anObject
]
