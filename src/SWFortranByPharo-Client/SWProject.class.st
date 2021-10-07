"
I have informations about a Project that can be run on the server.
SWProject>>#go runs the project on the server.
SWProject>>#goDomestic runs the project inside this Pharo image.
"
Class {
	#name : #SWProject,
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
SWProject class >> of: type [
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
SWProject >> args [

	^ args ifNil: [ args := {  } ]
]

{ #category : #accessing }
SWProject >> args: anObject [

	args := anObject
]

{ #category : #accessing }
SWProject >> client [

	^ client ifNil: [ client := SWClient new ]
]

{ #category : #accessing }
SWProject >> client: anObject [

	client := anObject
]

{ #category : #running }
SWProject >> go [
	^ self subclassResponsibility.

]

{ #category : #running }
SWProject >> goDomestic [
	|aClass|
	aClass := (Smalltalk globals at: self moduleName) ifNil: [ 
		(self pool get: self moduleName) programClass
	].
	
	^ aClass program

]

{ #category : #initialization }
SWProject >> initialize [
	super initialize.

]

{ #category : #accessing }
SWProject >> moduleName [

	^ moduleName
]

{ #category : #accessing }
SWProject >> moduleName: anObject [

	moduleName := anObject
]

{ #category : #accessing }
SWProject >> pool [

	^ pool ifNil: [
		pool := SWSourcesPool new
			type: self type;
			client: self client;
			yourself
	]
]

{ #category : #accessing }
SWProject >> pool: anObject [

	pool := anObject
]

{ #category : #accessing }
SWProject >> type [

	^ type
]

{ #category : #accessing }
SWProject >> type: aType [
	type := aType
]
