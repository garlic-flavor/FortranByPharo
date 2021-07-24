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
SWTranspilerOfRuby >> putClassDefinition: aClass [
	self putComment: aClass comment.
	self put: 'class '.
	self put: aClass name.
	(aClass superclass = Object) ifFalse: [
		self put: ' < '; put: aClass superclass name
	].
	self putLine.
	self incIndent.
	
	aClass methods do: [ :aMethod |
		(aClass declarations anySatisfy: [:each | each = aMethod selector]) ifTrue: [
			self putMethod: aMethod ofClass: aClass
		]
	].

	self flag: #toImplement.

	self decIndent.
	self putLine: 'end'.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putComment: comment [
	comment ifNotNil: [
		comment linesDo: [ :aLine |
			self
				put: '# ';
				putLine: aLine
		]
	]
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

{ #category : #tests }
SWTranspilerOfRuby >> putMainProgram [
	self putCode: '\
		(%mainClass%.new).main_(ARGV)
	\' with: { '%mainClass%' -> self mainClass }

]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putMainProgramFooterOf: project [
	indentShifter := 0
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putMainProgramHeaderOf: project [
	indentShifter := -1
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putMethod: aMethod ofClass: aClass [
	|sel|
	self
		putComment: aMethod comment;
		put: 'def ';
		put: (self class transpiledNameOf: aMethod selector);
		put: '('.
	aMethod argumentNames do: [ :aName |
		self put: aName asString
	] separatedBy: [
		self put: ', '
	].
	self putLine: ')'.
	sel := self transpilerNameFor: aMethod.
	(aClass respondsTo: sel) ifTrue: [
		self incIndent.
		aClass perform: sel with: self.
		self decIndent.
	] ifFalse: [
		aMethod transpileUsing: self.
	].
	self putLine: 'end'.
]

{ #category : #'public API' }
SWTranspilerOfRuby >> transpileProgram [
	self indentShifter: -1.
	^ super transpileProgram.
	
]
