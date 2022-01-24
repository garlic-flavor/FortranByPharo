"
I am an implementation of SWProjectRunner for ECMAScript (for nodejs).
"
Class {
	#name : #SWPRofJS,
	#superclass : #SWProjectRunner,
	#category : #'SWFortranByPharo-ClientServer-Client'
}

{ #category : #execution }
SWPRofJS >> execute: aModule [
	^ self exec: 'node' with: { aModule filename }
]
