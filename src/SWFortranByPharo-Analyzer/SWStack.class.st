"
I emulate a stack like of one used in Context class.
index 0 indicates the recevier.
index 1 indicates the first argument of the method.
"
Class {
	#name : #SWStack,
	#superclass : #SWSlot,
	#category : #'SWFortranByPharo-Analyzer-Slot'
}

{ #category : #accessing }
SWStack >> at: index [
	"index is 1 based.".
	"index 0 responds special to receiver."
	^ super at: index + 1

]

{ #category : #accessing }
SWStack >> atOffset: offset [
	"offset is  0 based.".
	"offset 0 responds to the first argument."
	^ super atOffset: offset + 1

]

{ #category : #copying }
SWStack >> copyFrom: start to: end [
	^ super copyFrom: start + 1 to: end + 1

]

{ #category : #removing }
SWStack >> pop [
	^ self payload removeLast.
]

{ #category : #removing }
SWStack >> pop: itemsCount [
	|arr|
	arr := self payload copyFrom: self payload size - itemsCount + 1 to: self payload size.
	itemsCount timesRepeat: [ self pop ].
	^ arr
]

{ #category : #adding }
SWStack >> push: anObject [
	^ self payload addLast: anObject.
]

{ #category : #adding }
SWStack >> push: anObject afterIndex: idx [
	self error; flag: #toRemove.
	^ self payload add: anObject afterIndex: (idx + 1)
]
