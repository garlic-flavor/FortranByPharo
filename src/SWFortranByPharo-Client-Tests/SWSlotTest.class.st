"
A SWSlotTest is a test class for testing the behavior of SWSlot
"
Class {
	#name : #SWSlotTest,
	#superclass : #TestCase,
	#instVars : [
		'slot'
	],
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
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

{ #category : #test }
SWSlotTest >> testCopyFromTo [

	|copied|
	copied := slot copyFrom: 3 to: 5.
	self assert: slot size equals: 5.
	self assert: copied size equals: 3.

]
