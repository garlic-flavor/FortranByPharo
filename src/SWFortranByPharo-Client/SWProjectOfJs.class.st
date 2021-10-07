"
I have imformations about a Project that can be run with NodeJs.
"
Class {
	#name : #SWProjectOfJs,
	#superclass : #SWProject,
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #running }
SWProjectOfJs >> go [
	|aSource socket|
	aSource := self pool get: self moduleName.
	socket := self client exec: 'node' with: ({ aSource filename }, self args).
	^ socket readMessage.

]

{ #category : #initialization }
SWProjectOfJs >> initialize [
	super initialize.
	self type: #mjs
]
