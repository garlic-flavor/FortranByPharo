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

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> defineMethod: aName as: rType with: calleeGenerator [
	self generator at: aName put: [ :aCallee |
		(self transpilerClass newFrom: aCallee)
			specifyReturnTypeAs: (rType isBlock ifTrue: [ rType value: aCallee ] ifFalse: [ rType ]);
			calleeGenerator: calleeGenerator;
			markAsDecoded;
			yourself
	]

]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> defineMethod: aName with: calleeGenerator [
	self generator at: aName put: [ :aCallee |
		(self transpilerClass newFrom: aCallee)
			calleeGenerator: calleeGenerator;
			yourself
	]

]

{ #category : #api }
SWClassDefinitionTranspiler >> defineMethodReturnsFirstArgument: aName with: aCalleeGenerator [
	self generator at: aName put: [ :aCallee |
		(self transpilerClass newFrom: aCallee)
			return: (aCallee stack at: 1);
			calleeGenerator: aCalleeGenerator;
			markAsDecoded;
			yourself
	]

]

{ #category : #api }
SWClassDefinitionTranspiler >> defineMethodReturnsFirstOrSecondArgument: aName with: aCalleeGenerator [
	self generator at: aName put: [ :aCallee |
		(self transpilerClass newFrom: aCallee)
			return: ((SWVariableTypeInfo new)
				<< (aCallee stack at: 1);
				<< (aCallee stack at: 2);
				yourself);
			calleeGenerator: aCalleeGenerator;
			markAsDecoded;
			yourself
	]

]

{ #category : #api }
SWClassDefinitionTranspiler >> defineMethodReturnsReceiver: aName with: calleeGenerator [
	self generator at: aName put: [ :aCallee |
		(self transpilerClass newFrom: aCallee)
			return: aCallee stack first;
			calleeGenerator: calleeGenerator;
			markAsDecoded;
			yourself
	]

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
