"
A SWStackAnalyzerTest is a test class for testing the behavior of SWStackAnalyzer
"
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
SWStackAnalyzerTest >> program_02: bbb [
	|aaa|
	aaa := 123.
	^ bbb + aaa
]

{ #category : #'tests - source' }
SWStackAnalyzerTest >> program_03: a [
	^ a = 5 ifTrue: [|b|
		b := 100.
		b + 300
	] ifFalse: [
		200 + 300
	]
]

{ #category : #'tests - source' }
SWStackAnalyzerTest >> program_04: val [
	^ 0 < val ifTrue: [ val + (self program_04: (val-1)) ] ifFalse: [ 0 ]
]

{ #category : #tests }
SWStackAnalyzerTest >> program_05 [
	|v1 v2 v3 v4 v5 v6 v7 v8 v9|
	^ v9 := SWVariableInfo new const: true; yourself.
]

{ #category : #'private - utility' }
SWStackAnalyzerTest >> returnTypeOf: aSelector withArgumentTypes: argTypes equals: rType [
	self assert: (SWStackAnalyzer decode: aSelector types: {self class}, argTypes) return type equals: rType
]

{ #category : #tests }
SWStackAnalyzerTest >> testDecode_01 [
	self returnTypeOf: #program_01 withArgumentTypes: { } equals: SmallInteger.
]

{ #category : #tests }
SWStackAnalyzerTest >> testDecode_02 [
	self returnTypeOf: #program_02: withArgumentTypes: { Integer } equals: Integer.
	self returnTypeOf: #program_02: withArgumentTypes: { Float } equals: Float.
]

{ #category : #tests }
SWStackAnalyzerTest >> testDecode_03 [
	self returnTypeOf: #program_03: withArgumentTypes: { Integer } equals: SmallInteger
]

{ #category : #tests }
SWStackAnalyzerTest >> testDecode_04 [
	self returnTypeOf: #program_04: withArgumentTypes: { SmallInteger } equals: SmallInteger
]

{ #category : #tests }
SWStackAnalyzerTest >> testDecode_05 [
	self returnTypeOf: #program_05 withArgumentTypes: {  } equals: SWVariableInfo
]

{ #category : #tests }
SWStackAnalyzerTest >> testSearchIn [
	self assert: (SWStackAnalyzer search: #= in: Integer) equals: Integer>>#=
]
