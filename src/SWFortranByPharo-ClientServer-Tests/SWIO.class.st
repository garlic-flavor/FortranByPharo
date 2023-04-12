Class {
	#name : #SWIO,
	#superclass : #Object,
	#instVars : [
		'toLeft',
		'toRight',
		'err'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #'instance creation' }
SWIO class >> newSelfSupplied [
	|inst|
	inst := self new.
	inst toRightStream: inst toLeftStream.
	^ inst
		
]

{ #category : #accessing }
SWIO >> errStream [
	^ err ifNil: [ err := SWStream new ]
	
]

{ #category : #'as yet unclassified' }
SWIO >> errStream: aStream [
	err := aStream
]

{ #category : #accessing }
SWIO >> toLeftStream [
	^ toLeft ifNil: [ toLeft := SWStream new ]
	
]

{ #category : #accessing }
SWIO >> toLeftStream: aStream [
	toLeft := aStream
	
]

{ #category : #accessing }
SWIO >> toRightStream [
	^ toRight ifNil: [ toRight := SWStream new ]
	
]

{ #category : #accessing }
SWIO >> toRightStream: aStream [
	toRight := aStream
	
]
