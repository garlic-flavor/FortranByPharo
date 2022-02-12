"
I indicate the status of a WebSocket server.
I can be convert to/from JSON using STON.
"
Class {
	#name : #SWServerStatus,
	#superclass : #Object,
	#instVars : [
		'code',
		'message',
		'toComplete',
		'completed',
		'uri',
		'entity',
		'socket'
	],
	#category : #'SWFortranByPharo-ClientServer-Common'
}

{ #category : #constants }
SWServerStatus class >> failed [
	^ self new failed; yourself
]

{ #category : #constants }
SWServerStatus class >> failedCode [
	^ #failed
]

{ #category : #'instance creation' }
SWServerStatus class >> fromSton: stonReader [
	|dict|
	dict := STON mapClass fromSton: stonReader.
	^ self new
		code: (dict at: #code ifAbsent: [ self failedCode ]) asSymbol;
		message: (dict at: #message ifAbsent: [ '' ]);
		entity: (dict at: #entity ifAbsent: [ nil ]);
		toComplete: (dict at: #toComplete ifAbsent: [ 0 ]);
		completed: (dict at: #completed ifAbsent: [ 0 ]);
		uri: (dict at: #uri ifAbsent: [ '' ]);
		yourself
	
]

{ #category : #constants }
SWServerStatus class >> ok [
	^ self new ok; yourself
]

{ #category : #constants }
SWServerStatus class >> okCode [
	^ #ok
]

{ #category : #'instance creation' }
SWServerStatus class >> readFrom: aSocket [
	|res ret|
	res := aSocket readMessage.
	ret := self fromSton: (STON reader on:  res readStream; yourself).
	ret socket: aSocket.
	^ ret
]

{ #category : #'code generation' }
SWServerStatus class >> solveDependenciesUsing: transpiler [
	transpiler
		import: #(SequenceableCollection) from: 'Pharo';
		import: #( STON ) from: 'STON'
]

{ #category : #constants }
SWServerStatus class >> validCodes [
	^ { self okCode. self failedCode }
]

{ #category : #accessing }
SWServerStatus >> code [
	^ code ifNil: [ self ok ]
]

{ #category : #accessing }
SWServerStatus >> code: aCode [
	self assert: [self class validCodes anySatisfy: [:c | c = aCode ]].
	^ code := aCode
]

{ #category : #'changing suspended state' }
SWServerStatus >> complete: aSize [
	^ self completed: (self completed + aSize)
]

{ #category : #accessing }
SWServerStatus >> completed [

	^ completed ifNil: [ completed := 0 ]
]

{ #category : #accessing }
SWServerStatus >> completed: anObject [

	completed := anObject
]

{ #category : #accessing }
SWServerStatus >> entity [

	^ entity ifNil: [ entity := STON mapClass new ]
]

{ #category : #accessing }
SWServerStatus >> entity: anObject [

	entity := anObject
]

{ #category : #constants }
SWServerStatus >> failed [
	^ code := self class failedCode
]

{ #category : #testing }
SWServerStatus >> isFailed [
	^ self code = self class failedCode
]

{ #category : #testing }
SWServerStatus >> isGood [
	^ self code ~= self class failedCode
]

{ #category : #testing }
SWServerStatus >> isOk [
	^ self code = self class okCode and: [ self toComplete <= self completed ]
]

{ #category : #testing }
SWServerStatus >> isProcessing [
	^ self code = self class okCode and: [ self completed < self toComplete ]
]

{ #category : #accessing }
SWServerStatus >> message [

	^ message ifNil: [ message := '' ]
]

{ #category : #accessing }
SWServerStatus >> message: anObject [

	message := anObject
]

{ #category : #constants }
SWServerStatus >> ok [
	^ code := self class okCode
]

{ #category : #accessing }
SWServerStatus >> progress [
	^ (0 < self toComplete) ifTrue: [
		self completed / self toComplete
	] ifFalse: [ 0 ]

]

{ #category : #accessing }
SWServerStatus >> socket [

	^ socket
]

{ #category : #accessing }
SWServerStatus >> socket: anObject [

	socket := anObject
]

{ #category : #'ston persistence' }
SWServerStatus >> stonOn: stonWriter [
	self flag: #toFix.
	^ STON mapClass new
		at: 'code' put: self code asString;
		at: 'message' put: self message;
		at: 'toComplete' put: self toComplete;
		at: 'completed' put: self completed;
		at: 'entity' put: self entity;
		at: 'uri' put: (self uri ifNil: ['']);
		stonOn: stonWriter
]

{ #category : #accessing }
SWServerStatus >> toComplete [

	^ toComplete ifNil: [ toComplete := 0 ]
]

{ #category : #accessing }
SWServerStatus >> toComplete: anObject [
	toComplete := anObject.

]

{ #category : #printing }
SWServerStatus >> toString [
	^ String streamContents: [ :s |
		STON jsonWriter
			on: s;
			nextPut: self
	]
]

{ #category : #accessing }
SWServerStatus >> uri [

	^ uri
]

{ #category : #accessing }
SWServerStatus >> uri: anObject [

	uri := anObject
]
