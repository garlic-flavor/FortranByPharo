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
SWClassDefinitionTranspiler >> putClassFooter [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putClassHeader [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler >> putMemberVariable: aVariableInfo [
	^ self subclassResponsibility 
]

{ #category : #'public API' }
SWClassDefinitionTranspiler >> putMethod: aMethodInfo [

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
]
