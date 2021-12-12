"
I have informations about Pharo's method to transpile.
I'm designed as very lazy to avoid problems like circular referencing of methods.

"
Class {
	#name : #SWMethodInfo,
	#superclass : #SymbolicBytecodeBuilder,
	#instVars : [
		'mangledName',
		'stack',
		'return',
		'sourceHash',
		'classInfo',
		'numTemps'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'instance creation' }
SWMethodInfo class >> new: selector types: types [
	^ self new
		method: selector;
		types: types;
		yourself

]

{ #category : #utils }
SWMethodInfo class >> safeSelectorNameOf: selector [
	selector = '=' ifTrue: [ ^ 'opEqual_' ].
	selector = '~=' ifTrue: [ ^ 'opNotEqual_' ].
	selector = ',' ifTrue: [ ^ 'opCamma_' ].
	selector = '->' ifTrue: [ ^ 'opArrow_' ].
	selector = '/' ifTrue: [ ^ 'opDiv_' ].
	selector = '<<' ifTrue: [ ^ 'opWrite_' ].
	selector = '+' ifTrue: [ ^ 'opPlus_' ].
	^ selector collect: [:c | (#' >#:/' anySatisfy: [ :each | each = c]) ifTrue: [ $_ ] ifFalse: [ c ] ]

]

{ #category : #utils }
SWMethodInfo class >> search: selector in: aClass [
	^ aClass ifNil: [
		nil
	] ifNotNil: [
		aClass methodDict at: selector ifAbsent: [
			self search: selector in: aClass superclass
		]
	]
]

{ #category : #comparing }
SWMethodInfo >> = right [
	self method = right method ifFalse: [ ^ false ].
	self arguments with: right arguments do: [ :l :r | l type = r type ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #adding }
SWMethodInfo >> addLocalVariable: aVariableInfo [
	self stack push: aVariableInfo afterIndex: self numTemps.
	self numTemps: self numTemps + 1.
	aVariableInfo stackPos: self numTemps.
]

{ #category : #accessing }
SWMethodInfo >> allTemps [
	^ self stack copyFrom: 1 to: self numTemps
]

{ #category : #accessing }
SWMethodInfo >> arguments [
	^ self stack copyFrom: 1 to: self method numArgs
]

{ #category : #accessing }
SWMethodInfo >> classInfo [

	^ classInfo
]

{ #category : #accessing }
SWMethodInfo >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #api }
SWMethodInfo >> decode [
	(stack at: 0)
		name: 'self';
		stackPos: 0.
	self method class = CompiledMethod ifFalse: [ self error: 'something go wrong.' ].
	self method temporaryVariables doWithIndex: [ :var :idx |
		(stack at: idx)
			name: var name;
			stackPos: idx
	].
	super decode.

]

{ #category : #testing }
SWMethodInfo >> hasExplicitReturn [
	^ self  return stackPos ~= -1
]

{ #category : #comparing }
SWMethodInfo >> hash [
	^ SHA256 hashStream: (
		(ReadWriteStream with: '')
			<< self mangledName;
			cr;
			<< self method sourceCode;
			reset;
			yourself
	)

]

{ #category : #accessing }
SWMethodInfo >> locals [
	^ self stack copyFrom: self method numArgs + 1 to: self numTemps
]

{ #category : #accessing }
SWMethodInfo >> mangledName [
	^ mangledName ifNil: [ mangledName := String streamContents: [ :s ||owner|
		owner := self method methodClass.
		owner class = Metaclass ifTrue: [ 
			s << owner soleInstance name; << 'C'
		] ifFalse: [
			s << owner name; << '_'
		].
"
		(self const ifTrue: ['C'] ifFalse: ['_']).
"
		s
			<< (self class safeSelectorNameOf: self method selector);
			<< (self arguments collect: [ :v |
				v mangledTypeName
			])
	] ]
]

{ #category : #accessing }
SWMethodInfo >> mangledName: anObject [

	mangledName := anObject
]

{ #category : #accessing }
SWMethodInfo >> method [
	^ method class = ByteSymbol ifTrue: [
		method := (self class search: method in: self stack first type).
	] ifFalse: [ method ].

]

{ #category : #accessing }
SWMethodInfo >> name [

	^ self method selector asString
]

{ #category : #accessing }
SWMethodInfo >> numTemps [

	^ numTemps ifNil: [ numTemps := self method numTemps ]
]

{ #category : #accessing }
SWMethodInfo >> numTemps: anObject [

	numTemps := anObject
]

{ #category : #accessing }
SWMethodInfo >> return [

	^ return ifNil: [
		return := SWVariableInfo new
	]
]

{ #category : #accessing }
SWMethodInfo >> return: anObject [

	return := anObject
]

{ #category : #accessing }
SWMethodInfo >> sourceHash [
	^ sourceHash ifNil: [ sourceHash := SHA256 hashMessage: self method sourceCode ]
]

{ #category : #accessing }
SWMethodInfo >> stack [

	^ stack ifNil: [ stack := SWStack new ]
]

{ #category : #accessing }
SWMethodInfo >> stack: anObject [

	stack := anObject
]

{ #category : #accessing }
SWMethodInfo >> types: anObject [

	anObject doWithIndex: [ :type :idx |
		type class = SWVariableInfo ifTrue: [
			(self stack at: idx - 1) << type
		] ifFalse: [
			(self stack at: idx - 1)
				type: type
		]
	]
]

{ #category : #accessing }
SWMethodInfo >> variableInfoOf: aName [
	^ self stack detect: [ :vi |
		vi name = aName
	] ifNone: [
		self classInfo variableInfoOf: aName
	]
]
