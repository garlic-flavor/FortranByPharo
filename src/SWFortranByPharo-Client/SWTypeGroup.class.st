"
I am in a SWVariableTypeInfo.
I am a same type group chained by assignment.
"
Class {
	#name : #SWTypeGroup,
	#superclass : #SWType,
	#instVars : [
		'group'
	],
	#category : #'SWFortranByPharo-Client-Analyzer'
}

{ #category : #'instance creation' }
SWTypeGroup class >> newFor: aVariableInfo [
	^ self newFor: aVariableInfo as: nil with: nil
		
]

{ #category : #'instance creation' }
SWTypeGroup class >> newFor: aVariableInfo as: aType with: aPriority [
	^ (self new: aType with: aPriority)
		addContainer: aVariableInfo;
		yourself
		
]

{ #category : #adding }
SWTypeGroup >> << rightGroup [
	super << rightGroup.
	(rightGroup class includesBehavior: SWTypeGroup) ifFalse: [ ^ self ].
	self group addAll: rightGroup group.
	rightGroup group do: [ :vi |
		vi type: self
	]

]

{ #category : #adding }
SWTypeGroup >> addContainer: aVariableInfo [
	self group add: aVariableInfo
]

{ #category : #accessing }
SWTypeGroup >> group [

	^ group ifNil: [ group := Set new ]
]

{ #category : #accessing }
SWTypeGroup >> group: anObject [

	group := anObject
]

{ #category : #printing }
SWTypeGroup >> putOn: aStream [
	super putOn: aStream.
	aStream
		<< $#;
		<< (self hash % 16rFFFF)  printStringHex
]
