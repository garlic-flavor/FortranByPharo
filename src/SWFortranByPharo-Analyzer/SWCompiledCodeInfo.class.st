"
SWCompiledCodeInfo has informations about Pharo's method to transpile.


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
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
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
	self error; flag: #toRemove.
	self stack push: aVariableInfo afterIndex: self numTemps.
	self numTemps: self numTemps + 1.
	aVariableInfo stackPos: self numTemps.
]

{ #category : #accessing }
SWCompiledCodeInfo >> allTemps [
	self error; flag: #toRemove.
	^ self stack copyFrom: 1 to: self method numTemps
]

{ #category : #accessing }
SWCompiledCodeInfo >> classInfo [
	"This is a SWClass"
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

{ #category : #accessing }
SWCompiledCodeInfo >> locals [
	"This returns local variables excluding its arguments."
	^ self stack copyFrom: self method numArgs + 1 to: self method numTemps
]

{ #category : #accessing }
SWCompiledCodeInfo >> messages [
	"messages is used to 2 deferent purpose.
	The one is to store transpilers to transpile the contents of the method.
	Another is to store transpilers to transpile its arguments when transpiling it as a callee.
	In latter case, messages correspond to these of outer transpiler."
	^ messages ifNil: [ messages := OrderedDictionary new ]
]

{ #category : #accessing }
SWCompiledCodeInfo >> messages: anObject [

	messages := anObject
]

{ #category : #accessing }
SWCompiledCodeInfo >> name [
	self error; flag: #toRemove.
	^ self method selector asString
]

{ #category : #accessing }
SWCompiledCodeInfo >> numTemps [
	self error; flag: #toRemove.

	^ numTemps ifNil: [ numTemps := self method numTemps ]
]

{ #category : #accessing }
SWCompiledCodeInfo >> numTemps: anObject [
	self error; flag: #toRemove.
	numTemps := anObject
]

{ #category : #accessing }
SWCompiledCodeInfo >> return [
	"The return type of this method."
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
	"This searches a SWVariableTypeInfo by its name."
	^ self stack detect: [ :vi |
		vi name = aName
	] ifNone: [
		self classInfo getVariableInfoOf: aName
	]
]
