"
I represent a module (equals to a file).
"
Class {
	#name : #SWModuleTranspiler,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #streaming }
SWModuleTranspiler >> << aObject [
	(aObject class inheritsFrom: SWMethodBodyTranspiler) ifTrue: [
		^ self putMainProgram: aObject
	].

	(aObject class inheritsFrom: SWMethodDefinitionTranspiler) ifTrue: [
		^ self putMethod: aObject
	].

	(aObject class inheritsFrom: SWClassDefinitionTranspiler) ifTrue: [
		^ self putClass: aObject
	].

	self error: 'not implemented yet.'
]

{ #category : #accessing }
SWModuleTranspiler >> contents [
	^ self stream contents
]

{ #category : #'code generation - protected' }
SWModuleTranspiler >> putClass: aClassInfo [
]

{ #category : #'code generation - protected' }
SWModuleTranspiler >> putMainProgram: aMethodBodyTranspiler [
	aMethodBodyTranspiler ready ifFalse: [ self error: 'something go wrong.' ].
	self putRequirements: aMethodBodyTranspiler sends values.
	aMethodBodyTranspiler stream: self stream.
	aMethodBodyTranspiler transpile.
]

{ #category : #'code generation - protected' }
SWModuleTranspiler >> putMethod: aMethodDefinitionTranspiler [
]

{ #category : #'code generation - protected' }
SWModuleTranspiler >> putRequireLine: aClass [
	self subclassResponsibility 
]

{ #category : #'code generation - protected' }
SWModuleTranspiler >> putRequirements: anArrayOfTranspiler [
	(anArrayOfTranspiler collect: [ :each | each method methodClass ]) asSet do: [ :each |
		self putRequireLine: each
	]
]

{ #category : #accessing }
SWModuleTranspiler >> stream [

	^ stream ifNil: [ stream := SWTranspilerStream new ]
]

{ #category : #accessing }
SWModuleTranspiler >> stream: anObject [

	stream := anObject
]
