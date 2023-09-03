"
an information to send a message
"
Class {
	#name : #SWSenderInfo,
	#superclass : #Object,
	#instVars : [
		'method',
		'operands'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #'instance creation' }
SWSenderInfo class >> newFrom: anObject [
	anObject class = SWSenderInfo ifTrue: [
		^ self new
			method: anObject method;
			operands: anObject operands;
			yourself.
	].
	self error.
]

{ #category : #comparing }
SWSenderInfo >> = right [
	^ self method = right method and: [ self operands = right operands ]
]

{ #category : #accessing }
SWSenderInfo >> expression [
	^ nil
]

{ #category : #comparing }
SWSenderInfo >> hash [
	^ (operands copyWith: method) hash
]

{ #category : #accessing }
SWSenderInfo >> messageInfo [
	^ nil
]

{ #category : #accessing }
SWSenderInfo >> method [

	^ method
]

{ #category : #accessing }
SWSenderInfo >> method: anObject [

	method := anObject
]

{ #category : #accessing }
SWSenderInfo >> name [
	^ self method selector
]

{ #category : #accessing }
SWSenderInfo >> operands [

	^ operands
]

{ #category : #accessing }
SWSenderInfo >> operands: anObject [

	operands := anObject
]

{ #category : #streaming }
SWSenderInfo >> printOn: aStream [
	self putOn: aStream
]

{ #category : #'as yet unclassified' }
SWSenderInfo >> putBasenameOn: aStream [
	aStream
		<< self receiverClass instanceSide name;
		<< self method selector asCamelCase
]

{ #category : #streaming }
SWSenderInfo >> putOn: aStream [
	method ifNil: [
		aStream << 'nil'
	] ifNotNil: [
		aStream << method selector
	]
]

{ #category : #accessing }
SWSenderInfo >> receiverClass [
	self operands isEmptyOrNil ifTrue: [ ^ nil ].
	^ self operands first value
]

{ #category : #accessing }
SWSenderInfo >> senderInfo [
	^ self
]
