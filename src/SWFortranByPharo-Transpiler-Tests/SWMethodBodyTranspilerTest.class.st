Class {
	#name : #SWMethodBodyTranspilerTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Transpiler-Tests-Common'
}

{ #category : #utilities }
SWMethodBodyTranspilerTest >> transpile: method withArguments: args [
	|decoder transpiler|
	decoder := SWDecoder new: method sourceNode with: args.
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
SWMethodBodyTranspilerTest >> transpileNo: no withArguments: args [
	^ self transpile: (SWTestProgram getMy: no) withArguments: ({SWTestProgram}, args)
]

{ #category : #accessing }
SWMethodBodyTranspilerTest >> transpilerClass [
	^ self subclassResponsibility
]
