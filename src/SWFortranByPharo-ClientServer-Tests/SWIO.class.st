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

{ #category : #accessing }
SWIO >> errStream [
	^ err ifNil: [ err := SWStream new ]
	
]

{ #category : #accessing }
SWIO >> toLeftStream [
	^ toLeft ifNil: [ toLeft := SWStream new ]
	
]

{ #category : #accessing }
SWIO >> toRightStream [
	^ toRight ifNil: [ toRight := SWStream new ]
	
]
