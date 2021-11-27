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
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #decoding }
SWMethodDefinitionTranspiler class >> decode: selector types: types [
	|mdt|
	mdt := self new.
	mdt bodyTranspiler: ((self methodBodyTranspilerClass
		decode: selector types: types)
		stream: mdt stream).
	^ mdt

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
SWMethodDefinitionTranspiler >> bodyTranspiler: anObject [

	bodyTranspiler := anObject
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> logging: trueOrFalse [
	self stream logging: trueOrFalse
]

{ #category : #'as yet unclassified' }
SWMethodDefinitionTranspiler >> putFunctionFooter [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SWMethodDefinitionTranspiler >> putFunctionHeader [
	^ self subclassResponsibility 
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> stream [

	^ stream ifNil: [ stream := SWTranspilerStream new ]
]

{ #category : #accessing }
SWMethodDefinitionTranspiler >> stream: anObject [

	stream := anObject
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
