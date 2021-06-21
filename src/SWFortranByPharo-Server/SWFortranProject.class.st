"
This contains informations to compile a project.
"
Class {
	#name : #SWFortranProject,
	#superclass : #Object,
	#instVars : [
		'name',
		'sources',
		'libraries',
		'description'
	],
	#category : #'SWFortranByPharo-Server-Builder'
}

{ #category : #accessing }
SWFortranProject >> description [

	^ description
]

{ #category : #accessing }
SWFortranProject >> description: anObject [

	description := anObject
]

{ #category : #accessing }
SWFortranProject >> libraries [

	^ libraries ifNil: [ libraries := {} ]
]

{ #category : #accessing }
SWFortranProject >> libraries: anObject [

	libraries := anObject
]

{ #category : #accessing }
SWFortranProject >> name [

	^ name
]

{ #category : #accessing }
SWFortranProject >> name: anObject [

	name := anObject
]

{ #category : #accessing }
SWFortranProject >> sources [

	^ sources
]

{ #category : #accessing }
SWFortranProject >> sources: anObject [

	sources := anObject
]
