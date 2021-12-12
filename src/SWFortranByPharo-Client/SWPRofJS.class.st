"
I am an implementation of SWProjectRunner for ECMAScript (for nodejs).
"
Class {
	#name : #SWPRofJS,
	#superclass : #SWProjectRunner,
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #execution }
SWPRofJS >> execute [
	^ self client exec: 'node' with: { self project main filename }
]
