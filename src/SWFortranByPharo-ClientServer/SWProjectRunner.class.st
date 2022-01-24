"
I use SWClient to upload SWProject and run it.
"
Class {
	#name : #SWProjectRunner,
	#superclass : #SWClient,
	#category : #'SWFortranByPharo-ClientServer-Client'
}

{ #category : #api }
SWProjectRunner class >> go: aModule [
	^ self new go: aModule
]

{ #category : #'instance creation' }
SWProjectRunner class >> newFrom: aProject [
	self error; flag: #toRemove.
	^ self new
		project: aProject;
		yourself
]

{ #category : #execution }
SWProjectRunner >> execute: aModule [
	^ self subclassResponsibility 
]

{ #category : #api }
SWProjectRunner >> go: aModule [
	^ self
		put: aModule;
		execute: aModule

]

{ #category : #'code generation' }
SWProjectRunner >> put: aModule [
	self put: aModule filename contents: aModule contents

]
