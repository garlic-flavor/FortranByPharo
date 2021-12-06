Class {
	#name : #SWProjectOfJs,
	#superclass : #SWProjectOld,
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #running }
SWProjectOfJs >> go [

	| tmp1 |
	tmp1 := self pool get: self moduleName.
	^ self client exec: 'node' with: { tmp1 filename } , self args
]

{ #category : #initialization }
SWProjectOfJs >> initialize [

	super initialize.
	self type: #mjs
]
