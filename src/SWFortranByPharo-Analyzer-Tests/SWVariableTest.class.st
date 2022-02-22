"
A SWVariableTypeInfoTest is a test class for testing the behavior of SWVariableTypeInfo
"
Class {
	#name : #SWVariableTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Type'
}

{ #category : #utilities }
SWVariableTest >> putOnOf: anObject mustMatchesWith: exp [

	|matcher str|
	matcher := RxMatcher forString: exp.
	str := String streamContents: [ :s | anObject putOn: s ].
	self assert: (matcher search: str).

]

{ #category : #tests }
SWVariableTest >> testBasics [

	|vi|
	vi := SWVariable new: SmallInteger.
	self assert: vi value equals: SmallInteger.
	self assert: vi priority equals: SWType exactTypePriority.
]

{ #category : #test }
SWVariableTest >> testLessThanLessThan [

	|v1 v2|
	v1 := SWVariable new: [ SmallInteger ].
	v2 := SWVariable new: String.
	v2 << v1.
	self assert: v2 value equals: String.
	self assert: v1 priority equals: SWType unknownMethodPriority.

	v1 << (SWVariable new: Number with: SWType userSpecifyingPriority).
	self assert: v1 value equals: Number.
	self assert: v1 priority equals: SWType userSpecifyingPriority.
]

{ #category : #test }
SWVariableTest >> testPutOn [

	|vi|
	vi := (SWVariable new: SmallInteger)
		name: 'hogehoge';
		yourself.
	self putOnOf: vi mustMatchesWith: 'hogehoge <SmallInteger\:exactType>'.
	
	vi := (SWVariable new: [SmallInteger])
		yourself.
	self putOnOf: vi mustMatchesWith: 'nil <lazy\:unknownMethod>'.
	
	vi := SWVariable new.
	self putOnOf: vi mustMatchesWith: 'nil <nil\:default>'.

]
