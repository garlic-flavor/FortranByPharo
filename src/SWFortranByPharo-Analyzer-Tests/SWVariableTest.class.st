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
	v1 := SWVariable new: Number with: SWType userSpecifyingPriority.
	v2 := SWVariable new: String.
	v2 << v1.
	self assert: v2 value equals: Number.
	self assert: v2 priority equals: SWType userSpecifyingPriority.
]

{ #category : #test }
SWVariableTest >> testPutOn [

	|vi|
	vi := (SWVariable new: SmallInteger)
		name: 'hogehoge';
		yourself.
	self putOnOf: vi mustMatchesWith: 'hogehoge <SmallInteger\:exactType>'.
	
	vi := SWVariable new.
	self putOnOf: vi mustMatchesWith: 'nil <nil\:default>'.

]
