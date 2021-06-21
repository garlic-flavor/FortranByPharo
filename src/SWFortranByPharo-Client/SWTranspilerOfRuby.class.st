"
I translate pharo code to Ruby.
"
Class {
	#name : #SWTranspilerOfRuby,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation' }
SWTranspilerOfRuby >> putArgumentsOf: selector with: arguments [
	self putArray: arguments.
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putArray: anArray [
	self put: (', ' join: (anArray collect: [:each |
		self duplicate transpiledOf: each
	]))
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putFunctionCallFooterOf: selector [
	self put: ')'
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putFunctionCallHeaderOf: selector [
	self put: selector; put: '('.
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putMainProgramFooterOf: project [
	indentShifter := 0
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putMainProgramHeaderOf: project [
	self putLine: '#!/usr/bin/ruby'.
	indentShifter := -1
]
