"
I manage sources on server side.
"
Class {
	#name : #SWSourceManager,
	#superclass : #Object,
	#instVars : [
		'dict',
		'type'
	],
	#classVars : [
		'fortran',
		'ruby'
	],
	#category : #'SWFortranByPharo-SourceManager'
}

{ #category : #accessing }
SWSourceManager class >> default: type [
	type = #rb ifTrue: [ ^ self ruby ].
	self error: 'no implementation'
]

{ #category : #accessing }
SWSourceManager class >> reset [
	ruby := nil.
	fortran := nil.
]

{ #category : #'as yet unclassified' }
SWSourceManager class >> ruby [
	^ ruby ifNil: [
		ruby := self new type: #rb; yourself. 
	]
]

{ #category : #accessing }
SWSourceManager >> dict [

	^ dict ifNil: [ dict := Dictionary new ]
]

{ #category : #accessing }
SWSourceManager >> dict: anObject [

	dict := anObject
]

{ #category : #'as yet unclassified' }
SWSourceManager >> sourceOf: aClass [
	|current|
	current := SWSource new
		type: self type;
		classes: { aClass };
		yourself.
	self dict at: aClass name ifPresent: [ :source |
		source contentsHash ~= current contentsHash ifTrue: [ self update: current ]
	] ifAbsent: [
		self update: current
	].
	^ current
]

{ #category : #accessing }
SWSourceManager >> type [

	^ type
]

{ #category : #accessing }
SWSourceManager >> type: anObject [

	type := anObject
]

{ #category : #updating }
SWSourceManager >> update: aSource [
	|client|
	SWServer start.
	client := SWClientView new.
	[
		aSource putTo: client.
		self dict at: aSource mainClass name put: aSource
	] ensure: [
		client socket close.
		SWServer stop.
	]
]
