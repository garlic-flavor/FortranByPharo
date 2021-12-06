"
I have informations about a Project that can be run on the server.
SWProject>>#go runs the project on the server.
SWProject>>#goDomestic runs the project inside this Pharo image.
"
Class {
	#name : #SWProjectOld,
	#superclass : #Object,
	#instVars : [
		'client',
		'pool',
		'moduleName',
		'args',
		'type'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #'instance creation' }
SWProjectOld class >> of: type [
	type = #mjs ifTrue: [ 
		^ SWProjectOfJs new	
	].
	type = #f90 ifTrue: [
		^ SWProjectOfFortran new
	].
	self flag: #ToImplement.
	self halt.
]

{ #category : #accessing }
SWProjectOld >> args [

	^ args ifNil: [ args := {  } ]
]

{ #category : #accessing }
SWProjectOld >> args: anObject [

	args := anObject
]

{ #category : #accessing }
SWProjectOld >> client [

	^ client ifNil: [ client := SWClient new ]
]

{ #category : #accessing }
SWProjectOld >> client: anObject [

	client := anObject
]

{ #category : #running }
SWProjectOld >> go [
	^ self subclassResponsibility.

]

{ #category : #running }
SWProjectOld >> goDomestic [
	|aClass|
	aClass := (Smalltalk globals at: self moduleName) ifNil: [ 
		(self pool get: self moduleName) programClass
	].
	
	^ aClass program

]

{ #category : #initialization }
SWProjectOld >> initialize [
	super initialize.

]

{ #category : #accessing }
SWProjectOld >> moduleName [

	^ moduleName
]

{ #category : #accessing }
SWProjectOld >> moduleName: anObject [

	moduleName := anObject
]

{ #category : #accessing }
SWProjectOld >> pool [

	^ pool ifNil: [
		pool := SWSourcesPool new
			type: self type;
			client: self client;
			yourself
	]
]

{ #category : #accessing }
SWProjectOld >> pool: anObject [

	pool := anObject
]

{ #category : #accessing }
SWProjectOld >> type [

	^ type
]

{ #category : #accessing }
SWProjectOld >> type: aType [
	type := aType
]
