Class {
	#name : #SWProject,
	#superclass : #Object,
	#instVars : [
		'type',
		'client',
		'pool',
		'moduleName'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

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
	^ self goDomestic: {  }
]

{ #category : #running }
SWProject >> goDomestic: args [
	|aClass|
	aClass := (Smalltalk globals at: self moduleName) ifNil: [
		(self pool get: self moduleName) mainClass
	].
	^ aClass new main: args.

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
SWProject >> type: anObject [

	type := anObject
]
