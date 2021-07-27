"
I translate pharo code to Ruby.
"
Class {
	#name : #SWTranspilerOfRuby,
	#superclass : #SWTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWTranspilerOfRuby >> at_ifAbsent_for: receiver with: arguments [
	self
		put: '(';
		transpile: receiver;
		put: '[';
		transpile: (arguments at: 1);
		put: '] || ';
		transpile: (arguments at: 2);
		put: ')'

]

{ #category : #accessing }
SWTranspilerOfRuby >> at_put_for: receiver with: arguments [
	self
		transpile: receiver;
		pushMessageNest;
		put: '[';
		transpile: (arguments at: 1);
		put: '] = ';
		transpile: (arguments at: 2);
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifNotNil_for: receiver with: arguments [
	self
		pushMessageNest;
		put: '(';
		transpile: receiver;
		putLine: ').present? ? (';
		transpile: (arguments at: 1) body;
		put: '): nil';
		popMessageNest
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifTrue_for: receiver with: arguments [
	self
		pushMessageNest;
		put: 'if(';
		transpile: receiver;
		putLine: '){';
		transpile: (arguments at: 1) body;
		put: '}'

]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> ifTrue_ifFalse_for: receiver with: arguments [
	self
		pushMessageNest;
		put: 'if(';
		transpile: receiver;
		putLine: '){';
		transpile: (arguments at: 1) body;
		putLine: '} else {';
		transpile: (arguments at: 2) body;
		put: '}';
		popMessageNest
]

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
	self popMessageNest.
	selector asString first isLetter ifTrue: [
		self put: ')'
	]
]

{ #category : #'code generation' }
SWTranspilerOfRuby >> putFunctionCallHeaderOf: selector [
	self pushMessageNest.
	selector asString first isLetter ifTrue: [
		self put: selector; put: '('
	] ifFalse: [
		self put: ' '; put: selector; put: ' '
	]
	
]

{ #category : #tests }
SWTranspilerOfRuby >> putMainProgram [
	self putCode: '\
		(%mainClass%.new).main_(ARGV)
	\' with: { '%mainClass%' -> self mainClass }

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
	sel := self transpiledNameOf: aMethod.
	(aClass respondsTo: sel) ifTrue: [
		self incIndent.
		aClass perform: sel with: self.
		self decIndent.
	] ifFalse: [
		aMethod transpileUsing: self.
	].
	self putLine: 'end'.
]

{ #category : #'as yet unclassified' }
SWTranspilerOfRuby >> putSymbol: aSymbol [
	self
		put: ':';
		put: aSymbol
]
