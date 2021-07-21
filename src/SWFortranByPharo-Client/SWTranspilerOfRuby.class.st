"
I translate pharo code to Ruby.
"
Class {
	#name : #SWTranspilerOfRuby,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #initialization }
SWTranspilerOfRuby >> initialize [
	super initialize.
	self type: #rb.
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putArgumentsOf: selector with: arguments [
	self putArray: arguments.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putFileHeaderOf: filename [
	self putLine: '#!/usr/bin/ruby'.

]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putFunctionCallFooterOf: selector [
	self put: ')'
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putFunctionCallHeaderOf: selector [
	self put: selector; put: '('.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putFunctionDefinitionFooterOf: aMethodName [
	self putLine: 'end'
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putFunctionDefinitionHeaderOf: aMethodName [
	self
		put: 'def ';
		put: (self class selectorNameOf: aMethodName);
		put: '(';
		putParameters: (self source class >>aMethodName) argumentNames;
		put: ')';
		putLine.
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putMainProgramFooterOf: project [
	indentShifter := 0
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putMainProgramHeaderOf: project [
	indentShifter := -1
]

{ #category : #tests }
SWTranspilerOfRuby >> transpile [
	^ self
		putFileHeaderOf: self programName;
		transpileDeclaredFunctions;
		transpileProgram;
		yourself
		
]

{ #category : #'public API' }
SWTranspilerOfRuby >> transpileProgram [
	self indentShifter: -1.
	^ super transpileProgram.
	
]
