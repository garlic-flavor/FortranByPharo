"
I have informations about Pharo's method to transpile.
I'm designed as very lazy to avoid problems like circular referencing of methods.

"
Class {
	#name : #SWCompiledCodeInfo,
	#superclass : #SWCalleeInfo,
	#instVars : [
		'return',
		'classInfo',
		'numTemps',
		'messages'
	],
	#category : #'SWFortranByPharo-Analyzer-Method'
}

{ #category : #accessing }
SWCompiledCodeInfo class >> classTranspilerClass [
	^ SWClass
]

{ #category : #'instance creation' }
SWCompiledCodeInfo class >> newDefaultPool [
	^ SWPool new
		transpilerClass: self;
		yourself
]

{ #category : #adding }
SWCompiledCodeInfo >> addLocalVariable: aVariableInfo [
	self stack push: aVariableInfo afterIndex: self numTemps.
	self numTemps: self numTemps + 1.
	aVariableInfo stackPos: self numTemps.
]

{ #category : #accessing }
SWCompiledCodeInfo >> allTemps [
	^ self stack copyFrom: 1 to: self numTemps
]

{ #category : #accessing }
SWCompiledCodeInfo >> classInfo [

	^ classInfo
]

{ #category : #accessing }
SWCompiledCodeInfo >> classInfo: anObject [

	classInfo := anObject
]

{ #category : #api }
SWCompiledCodeInfo >> decode [
	self isDecoded ifTrue: [ ^self ].
	super decode.

]

{ #category : #testing }
SWCompiledCodeInfo >> isToTranspile [
	^ self classInfo isNil or: [ self classInfo isToTranspile ]
]

{ #category : #accessing }
SWCompiledCodeInfo >> locals [
	^ self stack copyFrom: self method numArgs + 1 to: self numTemps
]

{ #category : #accessing }
SWCompiledCodeInfo >> messages [

	^ messages ifNil: [ messages := OrderedDictionary new ]
]

{ #category : #accessing }
SWCompiledCodeInfo >> messages: anObject [

	messages := anObject
]

{ #category : #accessing }
SWCompiledCodeInfo >> name [

	^ self method selector asString
]

{ #category : #accessing }
SWCompiledCodeInfo >> numTemps [

	^ numTemps ifNil: [ numTemps := self method numTemps ]
]

{ #category : #accessing }
SWCompiledCodeInfo >> numTemps: anObject [

	numTemps := anObject
]

{ #category : #accessing }
SWCompiledCodeInfo >> return [

	^ return ifNil: [
		return := (SWVariableTypeInfo new)
			owner: self;
			pc: 0;
			yourself
	]
]

{ #category : #accessing }
SWCompiledCodeInfo >> return: anObject [

	return := anObject
]

{ #category : #accessing }
SWCompiledCodeInfo >> specifyReturnTypeAs: aType [

	self return
		<< aType;
		priority: SWType userSpecifyingPriority
]

{ #category : #accessing }
SWCompiledCodeInfo >> variableInfoOf: aName [

	^ self stack detect: [ :vi |
		vi name = aName
	] ifNone: [
		self classInfo getVariableInfoOf: aName
	]
]
