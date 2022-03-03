"
baseclass of SWClassInfo and SWClassDefinitionTranspiler
"
Class {
	#name : #SWClassBase,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'pool'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #accessing }
SWClassBase >> pool [
	"A SWPoolBase object"
	^ pool
]

{ #category : #accessing }
SWClassBase >> pool: anObject [

	pool := anObject
]

{ #category : #printing }
SWClassBase >> printOn: aStream [
	self putOn: aStream
]

{ #category : #streaming }
SWClassBase >> putOn: aStream [
	aStream << self targetClass name
]

{ #category : #accessing }
SWClassBase >> targetClass [

	^ targetClass
]

{ #category : #accessing }
SWClassBase >> targetClass: anObject [
	targetClass := anObject.

]
