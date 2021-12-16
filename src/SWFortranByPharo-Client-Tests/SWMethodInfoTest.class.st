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
		add: (SWMethodInfo new: #= with: { 
						 SWMethodInfo.
						 SWMethodInfo });
		add: (SWMethodInfo new: #= with: { 
						 SWMethodInfo.
						 SWMethodInfo }).
	self assert: tmp1 size equals: 1.
	tmp1 add: (SWMethodInfo new: #= with: { 
				 SWMethodInfo.
				 SmallInteger }).
	self assert: tmp1 size equals: 2
]

{ #category : #test }
SWMethodInfoTest >> testMangledName [

	self
		assert: (SWMethodInfo new: #= with: { 
					 SWMethodInfo.
					 SWMethodInfo }) mangledName
		equals: 'SWMethodInfo_opEqual_swmi'
]
