"
a Stack of SWVariableTypeInfo.
"
Class {
	#name : #SWSlot,
	#superclass : #OrderedCollection,
	#category : #'SWFortranByPharo-Analyzer-Slot'
}

{ #category : #accessing }
SWSlot class >> elementClass [
	^ SWVariableTypeInfo
]

{ #category : #adding }
SWSlot >> addAll: anArray [
	anArray do: [ :each |
		self push: each
	]
]

{ #category : #'instance creation' }
SWSlot >> allocate: size [
	[ self size < size ] whileTrue: [
		self addLast: self class elementClass new
	]
]

{ #category : #accessing }
SWSlot >> at: index [
	self allocate: index.
	^ super at: index
]

{ #category : #copying }
SWSlot >> copyFrom: from to: to [
	self allocate: to.
	^ super copyFrom: from to: to
]

{ #category : #removing }
SWSlot >> pop [
	^ self removeLast
]

{ #category : #affecting }
SWSlot >> pop: itemsCount [
	^ self removeLast: itemsCount
]

{ #category : #adding }
SWSlot >> push [
	^ self addLast: self class elementClass new

]

{ #category : #adding }
SWSlot >> push: anObject [
	^ self addLast: anObject

]

{ #category : #streaming }
SWSlot >> putOn: aStream [
	aStream << '('.
	self do: [ :each |
		aStream << each value asString
	] separatedBy: [
		aStream << ', '
	].
	aStream << ')'
]

{ #category : #accessing }
SWSlot >> receiver [
	^ self at: 1
]

{ #category : #accessing }
SWSlot >> top [
	^ self last
]
