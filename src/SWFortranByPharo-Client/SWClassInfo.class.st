"
I hold type informatino about a class.
"
Class {
	#name : #SWClassInfo,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'members',
		'sourceHash'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #accessing }
SWClassInfo class >> analyzerClass [
	^ SWStackAnalyzer
]

{ #category : #adding }
SWClassInfo >> addMember: aMethodInfo [
	self members at: aMethodInfo mangledName put: aMethodInfo
]

{ #category : #accessing }
SWClassInfo >> getVariableInfoAt: offset [
	^ self getVariableInfoOf: (self targetClass slots at: offset + 1) name
]

{ #category : #accessing }
SWClassInfo >> getVariableInfoOf: aName [
	^ self targetClass slots detect: [ :each | each name = aName ] ifFound: [ :detected |
		self members at: aName ifAbsentPut: [
			(self class analyzerClass new: aName asSymbol types: { self targetClass }) return
		]
	] ifNone: [
		nil
	]

]

{ #category : #accessing }
SWClassInfo >> members [

	^ members ifNil: [ members := Dictionary new ]
]

{ #category : #accessing }
SWClassInfo >> members: anObject [

	members := anObject
]

{ #category : #accessing }
SWClassInfo >> sourceHash [
	^ sourceHash ifNil: [
		sourceHash := SHA256 hashMessage: ((self members collect: [:each |
			SHA256 hashMessage: each method sourceCode
		]) flattened)
	]
]

{ #category : #accessing }
SWClassInfo >> targetClass [

	^ targetClass
]

{ #category : #accessing }
SWClassInfo >> targetClass: anObject [

	targetClass := anObject
]
