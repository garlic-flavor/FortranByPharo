"
I transpile CompiledMethod to ECMAScript.
"
Class {
	#name : #SWMDTofJS,
	#superclass : #SWMethodDefinitionTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'as yet unclassified' }
SWMDTofJS class >> methodBodyTranspilerClass [
	^ SWMBTofJS
]

{ #category : #'code generation' }
SWMDTofJS >> putFunctionFooter [
	self stream putLine: '}'.

]

{ #category : #'code generation' }
SWMDTofJS >> putFunctionHeader [
	self stream
		put: 'function ';
		put: self bodyTranspiler method selector;
		put: '('.

	self bodyTranspiler method tempNames do: [ :vi |
		self stream put: vi
	] separatedBy: [
		self stream put: ', '
	].
	self stream putLine: '){'.

]

{ #category : #'public API' }
SWMDTofJS >> transpile [
	self stream
		put: 'function ';
		put: self bodyTranspiler method selector;
		put: '('.

	self bodyTranspiler method tempNames do: [ :vi |
		self stream put: vi
	] separatedBy: [
		self stream put: ', '
	].
	self stream
		putLine: '){';
		incIndent.
	self bodyTranspiler transpile.
	self stream
		decIndent;
		putLine: '}'.
	^ self stream contents
]
