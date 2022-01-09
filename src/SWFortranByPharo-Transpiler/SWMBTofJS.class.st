"
I transpile Pharo to ECMAScript.
"
Class {
	#name : #SWMBTofJS,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #accessing }
SWMBTofJS class >> classTranspilerClass [
	^ SWCDTofJS
]

{ #category : #constants }
SWMBTofJS class >> mangleClass [
	^ SWMangleOfJS 
]

{ #category : #accessing }
SWMBTofJS >> mangledName [
	^ self class mangleClass safeSelectorNameOf: (method class = ByteSymbol ifTrue: [ method ] ifFalse: [ self method selector ])
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfTrue: aNode [
	self stream log.
	
	aNode lastIsReturn ifTrue: [
		self
			put: 'if(';
			<< aNode receiver;
			put: ')';
			<< (aNode arguments at: 1)
	] ifFalse: [
		self
			put: '(';
			<< aNode receiver;
			put: ') ? (function()';
			<< (aNode arguments at: 1);
			put: ')() : null'
	]
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putIfTrueIfFalse: aNode [
	self stream log.
	
	aNode lastIsReturn ifTrue: [
		self
			put: 'if(';
			<< aNode receiver;
			put: ')';
			<< (aNode arguments at: 1);
			put: 'else ';
			<< (aNode arguments at: 2)
	] ifFalse: [
		self
			put: '(';
			<< aNode receiver;
			put: ') ? (function()';
			<< (aNode arguments at: 1);
			put: ')() : (function() { ';
			<< (aNode arguments at: 2);
			put: ')()'
	]
]

{ #category : #'code generation' }
SWMBTofJS >> putSelf [
	self put: (self method methodClass class = Metaclass ifTrue: [ self method methodClass soleInstance name ] ifFalse: [ 'this' ])
]

{ #category : #'code generation' }
SWMBTofJS >> putStatementDelimiter [
	self put: ';'
]

{ #category : #'as yet unclassified' }
SWMBTofJS >> putStdOut: arguments [
	self stream log.
	self
		put: 'console.log';
		putArguments: arguments
]

{ #category : #'code generation' }
SWMBTofJS >> putVariableDeclarationOf: aVariableInfo [
	self
		put: 'var ';
		put: aVariableInfo name;
		put: ' = null;';
		cr

		
]

{ #category : #accessing }
SWMBTofJS >> type [
	^ type ifNil: [ type := #js ]
]
