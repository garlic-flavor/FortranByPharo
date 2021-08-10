"
I indicate an instruction code for the SWServer
"
Class {
	#name : #SWServerInstruction,
	#superclass : #SWStd,
	#instVars : [
		'code',
		'target',
		'length',
		'options'
	],
	#category : #'SWFortranByPharo-Base'
}

{ #category : #constants }
SWServerInstruction class >> executeCode [
	^ #execute
]

{ #category : #'instance creation' }
SWServerInstruction class >> fromSton: stonReader [
	|dict|
	dict := STON mapClass fromSton: stonReader.
	^ self new
		code: (dict at: #code ifAbsent: [ self headCode ]) asSymbol;
		target: (dict at: #target ifAbsent: [ '' ]);
		length: (dict at: #length ifAbsent: [ 0 ]);
		options: (dict at: #options ifAbsent: [ STON mapClass new ]) copy;
		yourself
]

{ #category : #constants }
SWServerInstruction class >> headCode [
	^ #head
]

{ #category : #constants }
SWServerInstruction class >> postCode [
	^ #post
]

{ #category : #constants }
SWServerInstruction class >> putCode [
	^ #put
]

{ #category : #'code generation' }
SWServerInstruction class >> rb_requirements [
	^ #('require ''STON.rb''')
]

{ #category : #constants }
SWServerInstruction class >> validCodes [
	^ { self headCode. self postCode. self putCode. self executeCode }
]

{ #category : #accessing }
SWServerInstruction >> code [

	^ code
]

{ #category : #accessing }
SWServerInstruction >> code: anObject [
	self assert: [self class validCodes anySatisfy: [:c | c = anObject]].
	^ code := anObject
]

{ #category : #execution }
SWServerInstruction >> execute [
	^ code := self class executeCode
]

{ #category : #accessing }
SWServerInstruction >> head [
	^ code := self class headCode.
]

{ #category : #testing }
SWServerInstruction >> isExecute [
	^ self code = self class executeCode
]

{ #category : #testing }
SWServerInstruction >> isHead [
	^ self code = self class headCode
]

{ #category : #testing }
SWServerInstruction >> isPost [
	^ self code = self class postCode
]

{ #category : #testing }
SWServerInstruction >> isPut [
	^ self code = self class putCode
]

{ #category : #accessing }
SWServerInstruction >> length [

	^ length ifNil: [ length := 0 ]
]

{ #category : #accessing }
SWServerInstruction >> length: anObject [

	length := anObject
]

{ #category : #accessing }
SWServerInstruction >> options [

	^ options ifNil: [ options := STON mapClass new ]
]

{ #category : #accessing }
SWServerInstruction >> options: anObject [

	options := anObject
]

{ #category : #accessing }
SWServerInstruction >> post [
	^ code := self class postCode
]

{ #category : #accessing }
SWServerInstruction >> put [
	^ code := self class putCode
]

{ #category : #'ston persistence' }
SWServerInstruction >> stonOn: aStream [
	^ STON mapClass new
		at: 'code' put: self code asString;
		at: 'target' put: self target;
		at: 'length' put: self length;
		at: 'options' put: self options;
		stonOn: aStream
]

{ #category : #accessing }
SWServerInstruction >> target [

	^ target
]

{ #category : #accessing }
SWServerInstruction >> target: anObject [

	target := anObject
]

{ #category : #printing }
SWServerInstruction >> toString [
	^ String streamContents: [ :s |
		STON writer
			on: s;
			nextPut: self
	]
]
