"
I store a Collection of SWMethodInfo.
"
Class {
	#name : #SWDependenciesStore,
	#superclass : #Object,
	#instVars : [
		'payload'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWDependenciesStore >> payload [

	^ payload ifNil: [ payload := Set new ]
]

{ #category : #accessing }
SWDependenciesStore >> payload: anObject [

	payload := anObject
]
