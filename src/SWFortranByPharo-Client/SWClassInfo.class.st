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

{ #category : #accessing }
SWClassInfo >> getVariableInfoAt: offset [
	^ self getVariableInfoOf: (self targetClass slots at: offset + 1) name
]

{ #category : #accessing }
SWClassInfo >> getVariableInfoOf: aName [
	^ ((self targetClass slots collect: [ :each | each name ]) anySatisfy: [ :each | each = aName ]) ifTrue: [
		self members at: aName ifAbsentPut: [
			(self class analyzerClass new: aName asSymbol types: { self targetClass }) return
		]
	] ifFalse: [
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
		sourceHash := SHA256 hashMessage: ((self targetClass methods collect: [
			:each | SHA256 hashMessage: each sourceCode
		]) flatCollect: [ :each | each ])
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
