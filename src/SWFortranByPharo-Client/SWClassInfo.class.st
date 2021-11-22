"
I hold type informatino about a class.
"
Class {
	#name : #SWClassInfo,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'members'
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

{ #category : #'as yet unclassified' }
SWClassInfo >> getVariableInfoOf: aName [
	^ self members at: aName ifAbsentPut: [
		(self class analyzerClass decode: aName asSymbol types: { self targetClass }) return
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
SWClassInfo >> targetClass [

	^ targetClass
]

{ #category : #accessing }
SWClassInfo >> targetClass: anObject [

	targetClass := anObject
]
