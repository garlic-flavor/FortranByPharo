Class {
	#name : #SWIO,
	#superclass : #Object,
	#instVars : [
		'input',
		'output',
		'err'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #streaming }
SWIO >> << anObject [
	self outputStream << anObject
]

{ #category : #'bit manipulation' }
SWIO >> >> aBlock [
	^ self inputStream onEachLineDo: aBlock

]

{ #category : #accessing }
SWIO >> err: anObject [
	self errStream << anObject
]

{ #category : #accessing }
SWIO >> errStream [
	^ err ifNil: [ err := SWStream new ]
	
]

{ #category : #'as yet unclassified' }
SWIO >> errStream: aStream [
	err := aStream
]

{ #category : #'instance creation' }
SWIO >> inputStream [
	^ input ifNil: [ input := SWStream new ]
	
]

{ #category : #'as yet unclassified' }
SWIO >> inputStream: anObject [
	input := anObject
]

{ #category : #accessing }
SWIO >> nextPut: anObject [
	self outputStream nextPut: anObject
]

{ #category : #accessing }
SWIO >> outputStream [
	^ output ifNil: [ output := SWStream new ]
	
]

{ #category : #accessing }
SWIO >> outputStream: aStream [
	output := aStream
	
]

{ #category : #'as yet unclassified' }
SWIO >> pipeTo: right [
	|pipe|
	pipe := SWStream new.
	self outputStream: pipe.
	right inputStream: pipe.
	^ right
]

{ #category : #'as yet unclassified' }
SWIO >> redirect2to1 [
	self errStream: self outputStream
]
