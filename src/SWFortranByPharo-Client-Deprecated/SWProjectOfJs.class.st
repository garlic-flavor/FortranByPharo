"
I have imformations about a Project that can be run with NodeJs.
"
Class {
	#name : #SWProjectOfJs,
	#superclass : #SWProjectOld,
	#category : #'SWFortranByPharo-Client-Deprecated-Client-Deprecated'
}

{ #category : #running }
SWProjectOfJs >> go [
	|aSource|
	aSource := self pool get: self moduleName.
	^ self client exec: 'node' with: ({ aSource filename }, self args).

]

{ #category : #initialization }
SWProjectOfJs >> initialize [
	super initialize.
	self type: #mjs
]
