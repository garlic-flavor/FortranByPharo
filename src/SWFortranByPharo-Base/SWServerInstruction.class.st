"
I indicate an instruction code for the SWServer
"
Class {
	#name : #SWServerInstruction,
	#superclass : #Object,
	#instVars : [
		'code',
		'target',
		'options'
	],
	#category : #'SWFortranByPharo-Base'
}

{ #category : #'instance creation' }
SWServerInstruction class >> fromSton: stonReader [
	|dict|
	dict := STON mapClass fromSton: stonReader.
	^ self new
		code: (dict at: #code ifAbsent: [ self headCode ]);
		target: (dict at: #target ifAbsent: [ '' ]);
		options: (dict at: #options ifAbsent: [ STON mapClass new ]) copy;
		yourself
]

{ #category : #'as yet unclassified' }
SWServerInstruction class >> headCode [
	^ #head
]

{ #category : #'as yet unclassified' }
SWServerInstruction class >> postCode [
	^ #post
]

{ #category : #constants }
SWServerInstruction class >> putCode [
	^ #put
]

{ #category : #'as yet unclassified' }
SWServerInstruction class >> validCodes [
	^ { self headCode. self postCode. self putCode }
]

{ #category : #accessing }
SWServerInstruction >> code [

	^ code ifNil: [ self head ]
]

{ #category : #accessing }
SWServerInstruction >> code: anObject [
	self assert: (self class validCodes anySatisfy: [:c | c = anObject]).
	code := anObject
]

{ #category : #accessing }
SWServerInstruction >> head [
	^ code := self class headCode.
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
		at: 'code' put: self code;
		at: 'target' put: self target;
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
