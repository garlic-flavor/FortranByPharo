"
I transpile Pharo class to ECMAScript.
"
Class {
	#name : #SWCDTofJS,
	#superclass : #SWClassDefinitionTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #initialization }
SWCDTofJS >> initialize_SWStdClass [
	super initialize_SWStdClass.
	self defineMethodSender: #print: as: [ :transpiler :node |
		transpiler
			put: 'console.log';
			putArguments: node arguments
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
