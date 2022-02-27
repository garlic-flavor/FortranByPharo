"
payload is SWType
"
Class {
	#name : #SWValue,
	#superclass : #Object,
	#instVars : [
		'type'
	],
	#category : #'SWFortranByPharo-Analyzer-Type'
}

{ #category : #'instance creation' }
SWValue class >> new: aType [
	^ self new: aType with: nil 
]

{ #category : #'instance creation' }
SWValue class >> new: aType with: aPriority [
	^ self new
		<< aType;
		priority: aPriority;
		yourself.

]

{ #category : #'accumulator ops' }
SWValue >> << rightObject [
	(rightObject class includesBehavior: SWVariable) ifTrue: [
		^ self << rightObject payload
	].
	(rightObject class includesBehavior: SWValue) ifTrue: [
		rightObject priority <= self priority ifTrue: [ ^ rightObject ].
		self type: rightObject type.
		^ rightObject
	].

	(rightObject class includesBehavior: SWType) ifTrue: [
		rightObject priority <= self priority ifTrue: [ ^ rightObject ].
		self type: rightObject.
		^ rightObject
	].

	self type << rightObject.
	^ rightObject

]

{ #category : #comparing }
SWValue >> = right [
	^ self value = right value
]

{ #category : #accessing }
SWValue >> elementType [
	^ self type elementType
]

{ #category : #comparing }
SWValue >> hash [
	^ self type hash
]

{ #category : #printing }
SWValue >> printOn: aStream [

	^ self putOn: aStream
]

{ #category : #accessing }
SWValue >> priority [

	^ self type priority

]

{ #category : #accessing }
SWValue >> priority: anObject [

	^ self type priority: anObject.
]

{ #category : #streaming }
SWValue >> putOn: aStream [
	^ self type putOn: aStream
]

{ #category : #accessing }
SWValue >> superclass [
	^ self copy
		type: self type superclass;
		yourself
]

{ #category : #accessing }
SWValue >> type [

	^ type ifNil: [ type := SWType new ]
]

{ #category : #accessing }
SWValue >> type: anObject [

	type := anObject

]

{ #category : #accessing }
SWValue >> value [
	^ self type value
]
