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
	^ SWVariableType
]

{ #category : #adding }
SWSlot >> addAll: anArray [
	anArray do: [ :each |
		self push << each
	]
]

{ #category : #'instance creation' }
SWSlot >> allocate: size [
	[ self size < size ] whileTrue: [
		self push
	]
]

{ #category : #accessing }
SWSlot >> at: index [
	self allocate: index.
	^ super at: index
]

{ #category : #accessing }
SWSlot >> atOffset: offset [
	^ self at: offset + 1
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

{ #category : #accessing }
SWSlot >> top [
	^ self last
]
