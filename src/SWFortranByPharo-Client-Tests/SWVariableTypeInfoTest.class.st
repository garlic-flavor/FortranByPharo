"
A SWVariableTypeInfoTest is a test class for testing the behavior of SWVariableTypeInfo
"
Class {
	#name : #SWVariableTypeInfoTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #utilities }
SWVariableTypeInfoTest >> putOnOf: anObject mustMatchesWith: exp [

	|matcher str|
	matcher := RxMatcher forString: exp.
	str := String streamContents: [ :s | anObject putOn: s ].
	self assert: (matcher search: str).

]

{ #category : #tests }
SWVariableTypeInfoTest >> testBasics [

	|vi|
	vi := SWVariableTypeInfo new: [ SmallInteger ].
	self assert: vi easyValue equals: nil.
	self assert: vi value equals: SmallInteger.
	self assert: vi easyValue equals: SmallInteger.
	self assert: vi priority equals: SWType exactTypePriority.
]

{ #category : #test }
SWVariableTypeInfoTest >> testLessThanLessThan [

	|v1 v2|
	v1 := SWVariableTypeInfo new: [ SmallInteger ].
	v2 := SWVariableTypeInfo new: String.
	v2 << v1.
	self assert: v2 value equals: String.
	self assert: v1 value equals: String.
	self assert: v1 priority equals: SWType exactTypePriority.
	v1 << (SWVariableTypeInfo new: Number with: SWType userSpecifyingPriority).
	self assert: v1 value equals: Number.
	self assert: v2 value equals: Number.
	self assert: v2 priority equals: SWType userSpecifyingPriority.
]

{ #category : #tests }
SWVariableTypeInfoTest >> testNextTemporalVariableNameOf [

	| tmp1 tmp3 |
	tmp1 := Set new.
	tmp3 := nil.
	256 timesRepeat: [ 
		tmp3 := SWVariableTypeInfo nextTemporalVariableNameOf: tmp3.
		self deny: (tmp1 includes: tmp3).
		tmp1 add: tmp3 ]
]

{ #category : #test }
SWVariableTypeInfoTest >> testPutOn [

	|vi|
	vi := (SWVariableTypeInfo new: SmallInteger)
		name: 'hogehoge';
		stackPos: 3
		yourself.
	self putOnOf: vi mustMatchesWith: '\[3\] hogehoge <SmallInteger\:exactTypePriority#.{4}> << 0'.
	
	vi := (SWVariableTypeInfo new: [SmallInteger])
		yourself.
	self putOnOf: vi mustMatchesWith: '\[-\] nil <lazy\:unknownMethodPriority#.{4}> << 0'.
	
	vi := SWVariableTypeInfo new.
	self putOnOf: vi mustMatchesWith: '\[-\] nil <nil\:defaultPriority#.{4}> << 0'.

]
