"
I use SWClient to upload SWProject and run it.
"
Class {
	#name : #SWProjectRunner,
	#superclass : #Object,
	#instVars : [
		'client',
		'project'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #accessing }
SWProjectRunner >> client [

	^ client ifNil: [ client := SWClient new ]
]

{ #category : #accessing }
SWProjectRunner >> client: anObject [

	client := anObject
]

{ #category : #api }
SWProjectRunner >> go: arguments [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWProjectRunner >> project [

	^ project
]

{ #category : #accessing }
SWProjectRunner >> project: anObject [

	project := anObject
]
