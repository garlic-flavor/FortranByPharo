Class {
	#name : #SWMethodBodyTranspilerTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Transpiler-Tests-Common'
}

{ #category : #utilities }
SWMethodBodyTranspilerTest >> transpile: method withArguments: args [
	|transpiler|
	transpiler := self transpilerClass new: method with: args.
	transpiler logger enabled: true.
	transpiler stream newline: String cr.
"
	transpiler classInfo: (transpiler pool getClassTranspiler: method methodClass).
"
	transpiler decode; transpile.
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
