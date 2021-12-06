Class {
	#name : #SWMethodInfoTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #tests }
SWMethodInfoTest >> testEquals [

	| tmp1 |
	tmp1 := Set new.
	tmp1
		add: (SWMethodInfo new: #= types: { 
						 SWMethodInfo.
						 SWMethodInfo });
		add: (SWMethodInfo new: #= types: { 
						 SWMethodInfo.
						 SWMethodInfo }).
	self assert: tmp1 size equals: 1.
	tmp1 add: (SWMethodInfo new: #= types: { 
				 SWMethodInfo.
				 SmallInteger }).
	self assert: tmp1 size equals: 2
]

{ #category : #test }
SWMethodInfoTest >> testMangledName [

	self
		assert: (SWMethodInfo new: #= types: { 
					 SWMethodInfo.
					 SWMethodInfo }) mangledName
		equals: 'SWMethodInfo_opEqual_swmi'
]
