Class {
	#name : #SWFProgramCaller,
	#superclass : #SWFCaller,
	#instVars : [
		'io'
	],
	#category : #'SWFortranByPharo-FFCaller'
}

{ #category : #api }
SWFProgramCaller >> call: args [
	self io args: args.
	self referenceMode ifTrue: [
		self script value: self io.
		io out flush.
		io out done.
	] ifFalse: [
		self halt.
	]
]

{ #category : #accessing }
SWFProgramCaller >> io [

	^ io ifNil: [ io := SWIO new ]
]

{ #category : #accessing }
SWFProgramCaller >> io: anObject [

	io := anObject
]
