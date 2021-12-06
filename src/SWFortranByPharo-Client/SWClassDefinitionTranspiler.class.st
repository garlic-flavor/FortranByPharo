Class {
	#name : #SWClassDefinitionTranspiler,
	#superclass : #SWClassInfo,
	#instVars : [
		'stream'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'as yet unclassified' }
SWClassDefinitionTranspiler class >> methodDefinitionTranspilerClass [

	^ self subclassResponsibility
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
SWClassDefinitionTranspiler >> putMemberVariable: arg1 [

	^ self subclassResponsibility
]

{ #category : #'public API' }
SWClassDefinitionTranspiler >> putMethod: arg1 [

	
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream [

	^ stream
		  ifNil: [ stream := SWTranspilerStream new ]
		  ifNotNil: [ stream ]
]

{ #category : #accessing }
SWClassDefinitionTranspiler >> stream: arg1 [

	stream := arg1
]

{ #category : #'public API' }
SWClassDefinitionTranspiler >> transpile [

	
]
