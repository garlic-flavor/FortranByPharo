"
A SWVariableTypeInfoTest is a test class for testing the behavior of SWVariableTypeInfo
"
Class {
	#name : #SWVariableTypeInfoTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests-Analyzer'
}

{ #category : #test }
SWVariableTypeInfoTest >> testPutOn [

	|vi matcher|
	vi := (SWVariableTypeInfo newAs: SmallInteger)
		name: 'hogehoge';
		stackPos: 3
		yourself.
	matcher := RxMatcher forString: '\[3\] hogehoge <SmallInteger\:unknown#\d{9}> << nil'.
		
	self assert: (matcher search: (String streamContents: [:s | vi putOn: s ]))
]
