"
I transpile Pharo class to ECMAScript.
"
Class {
	#name : #SWCDTofJS,
	#superclass : #SWClassDefinitionTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #accessing }
SWCDTofJS class >> methodDefinitionTranspilerClass [
	^ SWMDTofJS
]

{ #category : #initialization }
SWCDTofJS >> initialize_Behavior [
	super initialize_Behavior.
	self
		defineMethodSender: #new as: [ :transpiler :aNode |
			transpiler
				put: '(new ';
				<< aNode receiver;
				putArguments: aNode arguments;
				put: ')'
		]
]

{ #category : #initialization }
SWCDTofJS >> initialize_BlockClosure [
	super initialize_BlockClosure.
	self
		defineMethodSender: #on:do: as: [ :transpiler :aNode | self put_on_do_: transpiler with: aNode ];
		defineMethodSender: #ensure: as: [ :transpiler :aNode | self put_ensure_: transpiler with: aNode  ]
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
SWCDTofJS >> initialize_Collection [
	super initialize_Collection.
	self
		defineMethodSender: #inject:into: as: [ :transpiler :aNode |
			transpiler
				<< aNode receiver;
				putClassAccessor;
				put: 'reduce(';
				<< (aNode arguments at: 2);
				put: ', ';
				<< (aNode arguments at: 1);
				put: ')'
		]
]

{ #category : #initialization }
SWCDTofJS >> initialize_Object [
	super initialize_Object.
	self
		defineMethodSender: #yourself as: [ :transpiler :aNode |
			transpiler << aNode receiver
		];
		defineMethodSender: #asString as: [ :transpiler :aNode |
			transpiler
				<< aNode receiver;
				putClassAccessor;
				put: 'toString()'
		]
]

{ #category : #initialization }
SWCDTofJS >> initialize_PositionableStream [
	self
		defineMethodSender:  #upToEnd as: [ :transpiler :aNode |
			transpiler
				<< aNode receiver;
				putClassAccessor;
				put: 'read()'
		]
]

{ #category : #initialization }
SWCDTofJS >> initialize_ProtoObject [
	super initialize_ProtoObject.
	self
		defineMethodSender: #ifNotNil: as: [ :transpiler :aNode |
			transpiler
				put: '((';
				<< aNode receiver;
				put: ' === null) ? null : ';
				putBlockAsExpression: aNode arguments first;
				put: ')'
		];
		defineMethodSender: #ifNil: as: [ :transpiler :aNode |
			transpiler
				put: '(function(_receiver_){ return (_receiver_ === null ) ? ';
				putBlockAsExpression: aNode arguments first;
				put: ' : _receiver_; })(';
				<< aNode receiver;
				put: ')'
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

{ #category : #initialization }
SWCDTofJS >> initialize_String [
	super initialize_String.
	self
		defineMethodSender: #beginsWith: as: [ :transpiler :aNode |
			transpiler putSender: aNode with: 'startsWith'
		];
		defineMethodSender: #endsWith: as: [ :transpiler :aNode |
			transpiler  putSender: aNode with: 'endsWith'
		]

]

{ #category : #'code generation' }
SWCDTofJS >> putClassHeader [
	self stream
		put: 'class ';
		put: self targetClass name;
		put: ' extends ';
		put: (self targetClass superclass = Object ifTrue: [ 'PharoObject' ] ifFalse: [ self targetClass superclass name ]);
		put: ' {';
		putLine
]

{ #category : #'code generation' }
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

{ #category : #'as yet unclassified' }
SWCDTofJS >> put_ensure_: transpiler with: aNode [
	transpiler
		put: '(function(){ try {';
		cr;
		incIndent;
		putSequenceWithReturn: aNode receiver;
		decIndent;
		put: '} finally';
		putBlock: aNode arguments first;
		put: '})()'
]

{ #category : #'as yet unclassified' }
SWCDTofJS >> put_on_do_: transpiler with: aNode [ 
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
