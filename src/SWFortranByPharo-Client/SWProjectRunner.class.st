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

{ #category : #'instance creation' }
SWProjectRunner class >> newFrom: aProject [
	^ self new
		project: aProject;
		yourself
]

{ #category : #accessing }
SWProjectRunner >> client [

	^ client ifNil: [ client := SWClient new ]
]

{ #category : #accessing }
SWProjectRunner >> client: anObject [

	client := anObject
]

{ #category : #execution }
SWProjectRunner >> execute [
	^ self subclassResponsibility 
]

{ #category : #api }
SWProjectRunner >> go [
	^ self
		putAll;
		execute
]

{ #category : #accessing }
SWProjectRunner >> project [

	^ project
]

{ #category : #accessing }
SWProjectRunner >> project: anObject [

	project := anObject
]

{ #category : #'code generation' }
SWProjectRunner >> put: aModule [
	(self client head: aModule filename) ifNil: [
		aModule transpile.
		self client put: aModule filename contents: aModule contents
	]
]

{ #category : #execution }
SWProjectRunner >> putAll [
	self project modules do: [ :aModule |
		self put: aModule
	]
]
