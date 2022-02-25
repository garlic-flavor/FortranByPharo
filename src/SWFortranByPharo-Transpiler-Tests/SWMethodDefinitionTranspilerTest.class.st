Class {
	#name : #SWMethodDefinitionTranspilerTest,
	#superclass : #SWTranspilerTestBase,
	#category : #'SWFortranByPharo-Transpiler-Tests-Common'
}

{ #category : #utilities }
SWMethodDefinitionTranspilerTest >> transpile: selector with: args [
	self setUpDecoder: selector with: args.
	transpiler bodyTranspiler: (SWMBTofJS new
		decoder: decoder;
		yourself).
	transpiler stream newline: String cr.
	transpiler transpile
]
