"
A SWTranspilerBaseTest is a test class for testing the behavior of SWTranspilerBase
"
Class {
	#name : #SWTranspilerBaseTest,
	#superclass : #TestCase,
	#instVars : [
		't'
	],
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #running }
SWTranspilerBaseTest >> setUp [
	super setUp.
	t := SWTranspilerBaseOld new
		type: #f90;
		yourself.

]

{ #category : #tests }
SWTranspilerBaseTest >> testDomainSpecificMessageTranspilerOf [
	self assert: (t class domainSpecificMessageTranspilerOf: #hoge:) equals: 'hoge_For:With:'.
	self assert: (t class domainSpecificMessageTranspilerOf: #=) equals: 'opEqual_For:With:'.
]

{ #category : #tests }
SWTranspilerBaseTest >> testHasDomainSpecificTranspilerOfifTrue [
	t hasDomainSpecificTranspilerOf: #hoge: ifTrue: [ :dst |
		Exception signal: 'never evaluated.'
	].
]

{ #category : #tests }
SWTranspilerBaseTest >> testMethodBodyGeneratorNameOf [
	self assert: (t methodBodyGeneratorNameOf: self class>>#testMethodBodyGeneratorNameOf)
		equals: 'f90_testMethodBodyGeneratorNameOfUsing:'
]

{ #category : #tests }
SWTranspilerBaseTest >> testUniqueMessageTranspilerOf [
	self assert: (t uniqueMessageTranspilerOf: #hoge:) equals: 'f90_hoge_With:Using:'
]
