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
		add: (SWCompiledCodeInfo new: #= with: { 
						 SWCompiledCodeInfo.
						 SWCompiledCodeInfo });
		add: (SWCompiledCodeInfo new: #= with: { 
						 SWCompiledCodeInfo.
						 SWCompiledCodeInfo }).
	self assert: tmp1 size equals: 1.
	tmp1 add: (SWCompiledCodeInfo new: #= with: { 
				 SWCompiledCodeInfo.
				 SmallInteger }).
	self assert: tmp1 size equals: 2
]

{ #category : #test }
SWMethodInfoTest >> testMangledName [

	self
		assert: (SWCompiledCodeInfo new: #= with: { 
					 SWCompiledCodeInfo.
					 SWCompiledCodeInfo }) mangledName
		equals: 'SWMethodInfo_opEqual_swmi'
]
