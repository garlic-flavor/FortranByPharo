"
A SWSlotTest is a test class for testing the behavior of SWSlot
"
Class {
	#name : #SWSlotTest,
	#superclass : #TestCase,
	#instVars : [
		'slot'
	],
	#category : #'SWFortranByPharo-Analyzer-Tests-Slot'
}

{ #category : #running }
SWSlotTest >> setUp [
	super setUp.
	
	slot := SWSlot new.
]

{ #category : #test }
SWSlotTest >> testAllocate [

	self assert: slot size equals: 0.
	slot allocate: -1.
	self assert: slot size equals: 0.
	slot allocate: 0.
	self assert: slot size equals: 0.

	slot allocate: 5.
	self assert: slot size equals: 5.
]

{ #category : #tests }
SWSlotTest >> testAt [
	(slot at: 1) << Integer.
	self assert: slot size equals: 1.
	self assert: (slot at: 1) value equals: Integer.
	
	(slot at: 3) << Number.
	self assert: slot size equals: 3.
	self assert: (slot at: 2) value equals: UndefinedObject.
]

{ #category : #test }
SWSlotTest >> testCopyFromTo [

	|copied|
	copied := slot copyFrom: 3 to: 5.
	self assert: slot size equals: 5.
	self assert: copied size equals: 3.

]
