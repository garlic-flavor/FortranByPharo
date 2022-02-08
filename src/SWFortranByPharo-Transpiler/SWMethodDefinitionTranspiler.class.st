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
SWMethodDefinitionTranspiler >> putFunctionFooter [
	^ self subclassResponsibility 
]

{ #category : #'code generation' }
SWMethodDefinitionTranspiler >> putFunctionHeader [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> stream [

	^ stream ifNil: [ stream := self bodyTranspiler stream ]
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> stream: anObject [

	stream := anObject
]

{ #category : #'public API' }
SWMethodDefinitionTranspiler >> transpile [
	self stream putComment: self bodyTranspiler method comment.
	self putFunctionHeader.
	self stream incIndent.
	self bodyTranspiler transpile.
	self stream decIndent.
	self putFunctionFooter.

]
