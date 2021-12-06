Class {
	#name : #SWFortranTranspilerTest,
	#superclass : #TestCase,
	#instVars : [
		'transpiler'
	],
	#category : #'SWFortranByPharo-Client-Tests-Transpiler'
}

{ #category : #private }
SWFortranTranspilerTest >> joinWithLf: arg1 [

	^ Character lf asString join: arg1
]

{ #category : #running }
SWFortranTranspilerTest >> setUp [

	super setUp.
	transpiler := SWTranspilerOfFortran new
]

{ #category : #tests }
SWFortranTranspilerTest >> testHelloworldClass [

	self
		assert: (transpiler transpile: SWTestHelloWorld)
		equals: (self joinWithLf:
				 { 'program helloworld'. '    print *, ''Hello, world!'''.
				 'end program helloworld'. '' })
]
