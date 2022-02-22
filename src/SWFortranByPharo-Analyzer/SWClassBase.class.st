"
a baseclass of SWClass and SWClassDefinitionTranspiler
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
	"A SWPool object"
	^ pool
]

{ #category : #accessing }
SWClassBase >> pool: anObject [

	pool := anObject
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
