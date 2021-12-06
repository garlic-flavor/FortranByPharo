Class {
	#name : #SWMethodDefinitionTranspiler,
	#superclass : #Object,
	#instVars : [
		'bodyTranspiler',
		'stream'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #decoding }
SWMethodDefinitionTranspiler class >> decode: arg1 types: arg2 [

	| tmp1 |
	tmp1 := self new.
	tmp1 bodyTranspiler:
		((self methodBodyTranspilerClass new: arg1 types: arg2) stream:
			 tmp1 stream).
	^ tmp1
]

{ #category : #'as yet unclassified' }
SWMethodDefinitionTranspiler class >> methodBodyTranspilerClass [

	^ self subclassResponsibility
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> bodyTranspiler [

	^ bodyTranspiler
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> bodyTranspiler: arg1 [

	bodyTranspiler := arg1
]

{ #category : #'public API' }
SWMethodDefinitionTranspiler >> logging: arg1 [

	self stream logging: arg1
]

{ #category : #'code generation' }
SWMethodDefinitionTranspiler >> putFunctionFooter [

	^ self subclassResponsibility
]

{ #category : #'code generation' }
SWMethodDefinitionTranspiler >> putFunctionHeader [

	^ self subclassResponsibility
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> stream [

	^ stream
		  ifNil: [ stream := SWTranspilerStream new ]
		  ifNotNil: [ stream ]
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> stream: arg1 [

	stream := arg1
]

{ #category : #'public API' }
SWMethodDefinitionTranspiler >> transpile [

	self putFunctionHeader.
	self stream incIndent.
	self bodyTranspiler transpile.
	self stream decIndent.
	self putFunctionFooter.
	^ self stream contents
]
