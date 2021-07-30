"
I indicate the status of a server.
"
Class {
	#name : #SWServerStatus,
	#superclass : #Object,
	#instVars : [
		'code',
		'description',
		'toComplete',
		'progress'
	],
	#category : #'SWFortranByPharo-Base'
}

{ #category : #constants }
SWServerStatus class >> failedCode [
	^ #failed
]

{ #category : #'instance creation' }
SWServerStatus class >> fromSton: stonReader [
	|dict|
	dict := STON mapClass fromSton: stonReader.
	^ self new
		code: (dict at: #code ifAbsent: [ self failedCode ]);
		description: (dict at: #description ifAbsent: [ '' ]);
		yourself
	
]

{ #category : #constants }
SWServerStatus class >> okCode [
	^ #ok
]

{ #category : #constants }
SWServerStatus class >> processingCode [
	^ #processing
]

{ #category : #'as yet unclassified' }
SWServerStatus class >> validCodes [
	^ { self waitingCode. self okCode. self failedCode. self processingCode }
]

{ #category : #constants }
SWServerStatus class >> waitingCode [
	^ #waiting
]

{ #category : #accessing }
SWServerStatus >> code [
	^ code ifNil: [ self waiting ]
]

{ #category : #accessing }
SWServerStatus >> code: aCode [
	self assert: (self class validCodes anySatisfy: [:c | c = aCode ]).
	^ code := aCode
]

{ #category : #accessing }
SWServerStatus >> description [

	^ description ifNil: [ description := '' ]
]

{ #category : #accessing }
SWServerStatus >> description: anObject [

	description := anObject
]

{ #category : #accessing }
SWServerStatus >> failed [
	^ code := self class failedCode
]

{ #category : #testing }
SWServerStatus >> isCompleted [
	^ self toComplete <= self progress
]

{ #category : #testing }
SWServerStatus >> isOk [
	^ code ~= self class failedCode
]

{ #category : #accessing }
SWServerStatus >> ok [
	^ code := self class okCode
]

{ #category : #accessing }
SWServerStatus >> processing [
	^ code := self class processingCode

]

{ #category : #accessing }
SWServerStatus >> progress [

	^ progress ifNil: [ progress := 0 ]
]

{ #category : #accessing }
SWServerStatus >> progress: anObject [

	progress := anObject
]

{ #category : #'ston persistence' }
SWServerStatus >> stonOn: stonWriter [
	^ STON mapClass new
		at: 'code' put: self code asString;
		at: 'description' put: self description;
		at: 'toComplete' put: self toComplete;
		at: 'progress' put: self progress;
		stonOn: stonWriter
]

{ #category : #accessing }
SWServerStatus >> toComplete [

	^ toComplete ifNil: [ toComplete := 0 ]
]

{ #category : #accessing }
SWServerStatus >> toComplete: anObject [

	toComplete := anObject
]

{ #category : #accessing }
SWServerStatus >> waiting [
	^ code := self class waitingCode
]
