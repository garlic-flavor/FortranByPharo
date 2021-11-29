"
A SWMethodInfoTest is a test class for testing the behavior of SWMethodInfo
"
Class {
	#name : #SWMethodInfoTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #tests }
SWMethodInfoTest >> testEquals [
	|set|
	set := Set new.
	set add: (SWMethodInfo new: #= types: { SWMethodInfo. SWMethodInfo }).
	set add: (SWMethodInfo new: #= types: { SWMethodInfo. SWMethodInfo }).
	self assert: set size equals: 1.

	set add: (SWMethodInfo new: #= types: { SWMethodInfo. SmallInteger }).
	self assert: set size equals: 2.	

]

{ #category : #test }
SWMethodInfoTest >> testMangledName [

	self assert: (SWMethodInfo new: #= types: { SWMethodInfo. SWMethodInfo }) mangledName equals: 'SWMethodInfo_opEqual_swmi'

]
