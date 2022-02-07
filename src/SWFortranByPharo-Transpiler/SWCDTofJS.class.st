"
I transpile Pharo class to ECMAScript.
"
Class {
	#name : #SWCDTofJS,
	#superclass : #SWClassDefinitionTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #initialization }
SWCDTofJS >> initialize_BlockClosure [
	super initialize_BlockClosure.
	self
		defineMethodSender: #on:do: as: [ :transpiler :aNode |
			aNode isExpression ifTrue: [
				transpiler put: '(function(){'
			].
			transpiler
				put: 'try {'; cr;
				incIndent.
			aNode isExpression ifTrue: [
				transpiler putSequenceWithReturn: aNode receiver
			] ifFalse: [
				transpiler putSequence: aNode receiver
			].
			transpiler
				decIndent;
				put: '} catch'.
			(aNode arguments at: 2) arguments ifNotEmpty: [
				transpiler putArguments: (aNode arguments at: 2) arguments
			].
			transpiler
				put: ' {'; cr;
				incIndent.
			aNode isExpression ifTrue: [
				transpiler putSequenceWithReturn: (aNode arguments at: 2)
			] ifFalse: [
				transpiler putSequence: (aNode arguments at: 2)
			].
			transpiler
				decIndent;
				put: '}'.
			aNode isExpression ifTrue: [
				transpiler put: '})()'
			]
		]
]

{ #category : #initialization }
SWCDTofJS >> initialize_Boolean [
	super initialize_Boolean.
	self defineMethodSender: #ifTrue:ifFalse: as: [ :transpiler :aNode|
		aNode lastIsReturn ifTrue: [
			transpiler
				put: 'if(';
				<< aNode receiver;
				put: ')';
				<< (aNode arguments at: 1);
				put: 'else ';
				<< (aNode arguments at: 2)
		] ifFalse: [
			transpiler
				put: '(';
				<< aNode receiver;
				put: ' ? ';
	 			putBlockAsExpression: (aNode arguments at: 1);
				put: ' : ';
				putBlockAsExpression: (aNode arguments at: 2);
				put: ')'
		]
	].
	self defineMethodSender: #ifTrue: as: [ :transpiler :aNode |
		aNode isExpression ifTrue: [
			transpiler
				put: '(';
				<< aNode receiver;
				put: ' ? ';
				putBlockAsExpression: (aNode arguments at: 1);
				put: ' : null)'
		] ifFalse: [
			transpiler
				put: 'if(';
				<< aNode receiver;
				put: ')';
				putBlock: (aNode arguments at: 1)
		]
	]

]

{ #category : #initialization }
SWCDTofJS >> initialize_Object [
	super initialize_Object.
	self
		defineMethodSender: #yourself as: [ :transpiler :aNode |
			transpiler << aNode receiver
		]
]

{ #category : #initialization }
SWCDTofJS >> initialize_SWStdClass [
	super initialize_SWStdClass.
	self
		defineMethodSender: #print: as: [ :transpiler :node |
			transpiler
				put: 'console.log';
				putArguments: node arguments
		];
		defineMethodSender: #import:from: as: [ :transpiler :node |
			transpiler put: 'import {'.
			node arguments first value do: [ :each |
				transpiler put: each asString
			] separatedBy: [
				transpiler put: ', '
			].
			transpiler
				put: '} from ';
				putString: (String streamContents: [:s |
					s << '../script/'; << node arguments second value; << '.mjs'
				])
		]
]

{ #category : #'as yet unclassified' }
SWCDTofJS >> putClassHeader [
	self stream
		put: 'class ';
		put: self targetClass name;
		put: ' extends ';
		put: (self targetClass superclass = Object ifTrue: [ 'PharoObject' ] ifFalse: [ self targetClass superclass name ]);
		put: ' {';
		putLine
]

{ #category : #'as yet unclassified' }
SWCDTofJS >> putMemberDeclarationOf: aVariableTypeInfo [

	self targetClass isClassSide ifTrue: [
		self stream put: 'static '
	].
	self stream
		put: '_';
		put: aVariableTypeInfo name asString;
		put: ' = null';
		putDelimiter;
		putLine

]
