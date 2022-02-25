Class {
	#name : #SWMethodBodyTranspilerTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Transpiler-Tests-Common'
}

{ #category : #'as yet unclassified' }
SWMethodBodyTranspilerTest >> noFromSelector: selector [
	^ ((selector copyAfter: $_) copyUpTo: $_) asInteger.

]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspilerTest >> resultWith: arguments [
	|transpiler result|
	transpiler := self transpileNo: (self noFromSelector: thisContext sender selector) with: arguments.
	result := transpiler stream contents.
	result inspect.
	self halt.
]

{ #category : #'as yet unclassified' }
SWMethodBodyTranspilerTest >> resultWith: arguments equals: expected [
	|transpiler result|
	transpiler := self transpileNo: (self noFromSelector: thisContext sender selector) with: arguments.
	result := transpiler stream contents.
	self assert: result equals: expected
]

{ #category : #utilities }
SWMethodBodyTranspilerTest >> transpile: method with: args [
	|decoder transpiler|
	decoder := SWDecoder new: method with: args.
	decoder enableLogging.
	decoder decode.
	
	transpiler := self transpilerClass new: decoder.
	transpiler stream newline: String cr.
"
	transpiler classInfo: (transpiler pool getClassTranspiler: method methodClass).
"
	transpiler transpile.
	^ transpiler

]

{ #category : #utilities }
SWMethodBodyTranspilerTest >> transpileNo: no with: args [
	^ self transpile: (SWTestProgram getMy: no) with: ({SWTestProgram}, args)
]

{ #category : #accessing }
SWMethodBodyTranspilerTest >> transpilerClass [
	^ self subclassResponsibility
]
