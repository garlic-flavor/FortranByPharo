Class {
	#name : #SWStackAnalyzerTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #'tests - source' }
SWStackAnalyzerTest >> program_01 [

	^ 345
]

{ #category : #'tests - source' }
SWStackAnalyzerTest >> program_02: arg1 [

	| tmp1 |
	tmp1 := 123.
	^ arg1 + tmp1
]

{ #category : #'tests - source' }
SWStackAnalyzerTest >> program_03: arg1 [

	| tmp1 |
	^ arg1 = 5
		  ifTrue: [ 
			  tmp1 := 100.
			  tmp1 + 300 ]
		  ifFalse: [ 200 + 300 ]
]

{ #category : #'tests - source' }
SWStackAnalyzerTest >> program_04: arg1 [

	^ 0 < arg1
		  ifTrue: [ arg1 + (self program_04: arg1 - 1) ]
		  ifFalse: [ 0 ]
]

{ #category : #tests }
SWStackAnalyzerTest >> program_05 [

	| tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7 tmp8 tmp9 |

	^ tmp9 := SWVariableInfo new
		addProperty: #mutable;
		yourself

]

{ #category : #'private - utility' }
SWStackAnalyzerTest >> returnTypeOf: arg1 withArgumentTypes: arg2 equals: arg3 [

	self
		assert:
		(SWStackAnalyzer new: arg1 with: { self class } , arg2) return type
		equals: arg3
]

{ #category : #tests }
SWStackAnalyzerTest >> testDecode_01 [

	self
		returnTypeOf: #program_01
		withArgumentTypes: {  }
		equals: SmallInteger
]

{ #category : #tests }
SWStackAnalyzerTest >> testDecode_02 [

	self
		returnTypeOf: #program_02:
		withArgumentTypes: { Integer }
		equals: Integer;
		returnTypeOf: #program_02:
		withArgumentTypes: { Float }
		equals: Float
]

{ #category : #tests }
SWStackAnalyzerTest >> testDecode_03 [

	self
		returnTypeOf: #program_03:
		withArgumentTypes: { Integer }
		equals: SmallInteger
]

{ #category : #tests }
SWStackAnalyzerTest >> testDecode_04 [

	self
		returnTypeOf: #program_04:
		withArgumentTypes: { SmallInteger }
		equals: SmallInteger
]

{ #category : #tests }
SWStackAnalyzerTest >> testDecode_05 [

	self
		returnTypeOf: #program_05
		withArgumentTypes: {  }
		equals: SWVariableInfo
]

{ #category : #tests }
SWStackAnalyzerTest >> testSearchIn [

	self
		assert: (SWStackAnalyzer search: #= in: Integer)
		equals: Integer >> #=
]
