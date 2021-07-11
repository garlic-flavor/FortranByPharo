"
This express a result of SWShell execution.
"
Class {
	#name : #SWShellResult,
	#superclass : #Object,
	#instVars : [
		'isSuccess',
		'message'
	],
	#category : #'SWFortranByPharo-Server-Shell'
}

{ #category : #accessing }
SWShellResult >> isSuccess [

	^ isSuccess
]

{ #category : #accessing }
SWShellResult >> isSuccess: anObject [

	isSuccess := anObject
]

{ #category : #accessing }
SWShellResult >> message [

	^ message
]

{ #category : #accessing }
SWShellResult >> message: anObject [

	message := anObject
]

{ #category : #printing }
SWShellResult >> toString [
	^ String streamContents: [ :s |
		s
			<< (self isSuccess ifTrue: [ 'Succeeded' ] ifFalse: [ 'Failed' ]); cr;
			<< self message; cr.
	]
]
