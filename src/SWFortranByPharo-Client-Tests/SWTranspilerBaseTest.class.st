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

	| tmp2 |
	super setUp.
	tmp2 := SWTranspilerBaseOld new.
	tmp2 type: #f90.
	t := tmp2 yourself
]

{ #category : #tests }
SWTranspilerBaseTest >> testDomainSpecificMessageTranspilerOf [

	self
		assert: (t class domainSpecificMessageTranspilerOf: #hoge:)
		equals: 'hoge_For:With:';
		assert: (t class domainSpecificMessageTranspilerOf: #=)
		equals: 'opEqual_For:With:'
]

{ #category : #tests }
SWTranspilerBaseTest >> testHasDomainSpecificTranspilerOfifTrue [

	t
		hasDomainSpecificTranspilerOf: #hoge:
		ifTrue: [ :arg1 | Exception signal: 'never evaluated.' ]
]

{ #category : #tests }
SWTranspilerBaseTest >> testMethodBodyGeneratorNameOf [

	self
		assert: (t methodBodyGeneratorNameOf:
				 self class >> #testMethodBodyGeneratorNameOf)
		equals: 'f90_testMethodBodyGeneratorNameOfUsing:'
]

{ #category : #tests }
SWTranspilerBaseTest >> testUniqueMessageTranspilerOf [

	self
		assert: (t uniqueMessageTranspilerOf: #hoge:)
		equals: 'f90_hoge_With:Using:'
]
