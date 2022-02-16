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
	
	slot := SWSlotOld new.
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

{ #category : #test }
SWSlotTest >> testEqualsSign [
	|s1 s2|
	s1 := SWSlotOld new.
	(s1 at: 1)
		<< Integer.
	(s1 at: 2)
		<< String;
		priority: SWType userSpecifyingPriority.

	s2 := SWSlotOld new.
	(s2 at: 1)	
		<< Integer.
	(s2 at: 2)
		<< String.
	self assert: s1 equals:  s2

]
