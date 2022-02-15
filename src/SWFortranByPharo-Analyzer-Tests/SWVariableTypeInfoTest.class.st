"
A SWVariableTypeInfoTest is a test class for testing the behavior of SWVariableTypeInfo
"
Class {
	#name : #SWVariableTypeInfoTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Type'
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
	vi := SWVariableTypeInfo new: SmallInteger.
	self assert: vi value equals: SmallInteger.
	self assert: vi priority equals: SWType exactTypePriority.
]

{ #category : #test }
SWVariableTypeInfoTest >> testLessThanLessThan [

	|v1 v2|
	v1 := SWVariableTypeInfo new: [ SmallInteger ].
	v2 := SWVariableTypeInfo new: String.
	v2 << v1.
	self assert: v2 value equals: String.
	self assert: v1 priority equals: SWType unknownMethodPriority.

	v1 << (SWVariableTypeInfo new: Number with: SWType userSpecifyingPriority).
	self assert: v1 value equals: Number.
	self assert: v1 priority equals: SWType userSpecifyingPriority.
]

{ #category : #test }
SWVariableTypeInfoTest >> testPutOn [

	|vi|
	vi := (SWVariableTypeInfo new: SmallInteger)
		name: 'hogehoge';
		yourself.
	self putOnOf: vi mustMatchesWith: 'hogehoge <SmallInteger\:exactType>'.
	
	vi := (SWVariableTypeInfo new: [SmallInteger])
		yourself.
	self putOnOf: vi mustMatchesWith: 'nil <lazy\:unknownMethod>'.
	
	vi := SWVariableTypeInfo new.
	self putOnOf: vi mustMatchesWith: 'nil <nil\:default>'.

]
