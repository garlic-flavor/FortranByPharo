"
I transpile CompiledMethod.
"
Class {
	#name : #SWMethodDefinitionTranspiler,
	#superclass : #Object,
	#instVars : [
		'bodyTranspiler',
		'stream'
	],
	#category : #'SWFortranByPharo-Transpiler-Common'
}

{ #category : #accessing }
SWMethodDefinitionTranspiler >> bodyTranspiler [

	^ bodyTranspiler
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> bodyTranspiler: anObject [

	bodyTranspiler := anObject
]

{ #category : #'code generation' }
SWMethodDefinitionTranspiler >> putMethodFooter [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodDefinitionTranspiler >> putMethodHeader [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> stream [

	^ stream ifNil: [ stream := bodyTranspiler stream ]
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> stream: anObject [

	stream := anObject
]

{ #category : #'public API' }
SWMethodDefinitionTranspiler >> transpile [
	self stream putComment: self bodyTranspiler method comment.
	self putMethodHeader.
	self stream incIndent.
	self bodyTranspiler transpile.
	self stream decIndent.
	self putMethodFooter.

]
