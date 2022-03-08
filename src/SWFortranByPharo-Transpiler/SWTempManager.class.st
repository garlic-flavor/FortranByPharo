"
temporary variable name manager.
"
Class {
	#name : #SWTempManager,
	#superclass : #Object,
	#instVars : [
		'header',
		'counter'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #accessing }
SWTempManager >> counter [

	^ counter ifNil: [ counter := 0 ]
]

{ #category : #accessing }
SWTempManager >> counter: anObject [

	counter := anObject
]

{ #category : #accessing }
SWTempManager >> header [

	^ header ifNil: [ header := 't_' ]
]

{ #category : #accessing }
SWTempManager >> header: anObject [

	header := anObject
]

{ #category : #'as yet unclassified' }
SWTempManager >> nextName [
	|name|
	name := String streamContents: [ :s | s << self header; << self counter asString ].
	self counter: self counter + 1.
	^ name
]
