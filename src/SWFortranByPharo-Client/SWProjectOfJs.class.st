Class {
	#name : #SWProjectOfJs,
	#superclass : #SWProject,
	#category : #'SWFortranByPharo-Client'
}

{ #category : #running }
SWProjectOfJs >> go [
	|aSource socket|
	aSource := self pool get: self moduleName.
	socket := self client exec: 'node' with: ({ aSource filename }, self args).
	^ socket readMessage.

]

{ #category : #accessing }
SWProjectOfJs >> type [

	^ #mjs
]
