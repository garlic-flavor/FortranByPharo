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

	self stream putLine: '}'
]

{ #category : #'code generation' }
SWMDTofJS >> putFunctionHeader [

	| tmp2 |
	tmp2 := self stream.
	tmp2
		put: 'function ';
		put: self bodyTranspiler method selector;
		put: '('.
	self bodyTranspiler method tempNames
		do: [ :arg1 | self stream put: arg1 ]
		separatedBy: [ self stream put: ', ' ].
	self stream putLine: '){'
]

{ #category : #'public API' }
SWMDTofJS >> transpile [

	| tmp2 tmp4 tmp6 |
	tmp2 := self stream.
	tmp2
		put: 'function ';
		put: self bodyTranspiler method selector;
		put: '('.
	self bodyTranspiler method tempNames
		do: [ :arg1 | self stream put: arg1 ]
		separatedBy: [ self stream put: ', ' ].
	tmp4 := self stream.
	tmp4
		putLine: '){';
		incIndent.
	self bodyTranspiler transpile.
	tmp6 := self stream.
	tmp6
		decIndent;
		putLine: '}'.
	^ self stream contents
]
