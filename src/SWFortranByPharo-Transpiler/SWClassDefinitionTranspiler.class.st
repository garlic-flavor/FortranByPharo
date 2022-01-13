"
I transpile a Pharo class.
"
Class {
	#name : #SWClassDefinitionTranspiler,
	#superclass : #SWClass,
	#instVars : [
		'stream'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler class >> methodDefinitionTranspilerClass [
	^ self subclassResponsibility 
]

{ #category : #api }
SWClassDefinitionTranspiler >> newTranspilerAsBinaryOperatorOf: aCallee [
	^ (super newTranspilerAsBinaryOperatorOf: aCallee)
		calleeGenerator: [ :t :node | t putOpBinary: node ];
		yourself


]

{ #category : #'instance creation' }
SWClassDefinitionTranspiler >> newTranspilerOf: aCallee as: rType with: aCalleeGenerator [
	^ (self newTranspilerOf: aCallee as: rType)
		calleeGenerator: aCalleeGenerator;
		yourself
]

{ #category : #'instance creation' }
SWClassDefinitionTranspiler >> newTranspilerOf: aCallee with: aCalleeGenerator [
	^ (self transpilerClass newFrom: aCallee)
		calleeGenerator: aCalleeGenerator;
		yourself
]

{ #category : #api }
SWClassDefinitionTranspiler >> newTranspilerReturnsFirstArgumentOf: aCallee with: aCalleeGenerator [
	^ (self newTranspilerReturnsFirstArgumentOf: aCallee)
		calleeGenerator: aCalleeGenerator;
		yourself


]

{ #category : #api }
SWClassDefinitionTranspiler >> newTranspilerReturnsFirstOrSecondArgumentOf: aCallee with: aCalleeGenerator [
	^ (self newTranspilerReturnsFirstOrSecondArgumentOf: aCallee)
		calleeGenerator: aCalleeGenerator;
		yourself

]

{ #category : #api }
SWClassDefinitionTranspiler >> newTranspilerReturnsReceiverOf: aCallee with: aCalleeGenerator [
	^ (self newTranspilerReturnsReceiverOf: aCallee)
		calleeGenerator: aCalleeGenerator;
		yourself

]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putClassFooter [
	self stream
		put: '}';
		putLine
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putClassHeader [
	self stream
		put: 'class ';
		put: targetClass name;
		put: '{';
		putLine
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putMemberVariable: aVariableInfo [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putMethodDefinition: aMBT [
	aMBT class methodDefinitionTranspilerClass new
		stream: self stream;
		bodyTranspiler: aMBT;
		transpile

]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream [

	^ stream ifNil: [ stream := SWTranspilerStream new ]
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream: anObject [

	stream := anObject
]

{ #category : #'public API' }
SWClassDefinitionTranspiler >> transpile [
	self targetClass isInstanceSide ifTrue: [
		self transpileAsInstanceSide
	] ifFalse: [
		self transpileAsClassSide
	]
	

]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> transpileAsClassSide [
	self methods do: [ :each | self putMethodDefinition: each ]
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> transpileAsInstanceSide [
	self putClassHeader.
	self stream incIndent.
	classSide ifNotNil: [
		classSide
			stream: self stream;
			transpileAsClassSide
	].
	
	self methods do: [ :each | self putMethodDefinition: each ].

	self stream decIndent.
	self putClassFooter.
]
