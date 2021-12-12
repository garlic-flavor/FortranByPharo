"
I transpile Pharo to ECMAScript.
"
Class {
	#name : #SWMBTofJS,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWMBTofJS >> mangledName [
	^ self class safeSelectorNameOf: (method class = ByteSymbol ifTrue: [ method ] ifFalse: [ self method selector ])
]

{ #category : #'code generation' }
SWMBTofJS >> putSelf [
	self put: (self method methodClass class = Metaclass ifTrue: [ self method methodClass soleInstance name ] ifFalse: [ 'this' ])
]

{ #category : #'code generation' }
SWMBTofJS >> putStatementDelimiter [
	self put: ';'
]

{ #category : #'code generation' }
SWMBTofJS >> putVariableDeclarationOf: aVariableInfo [
	self
		put: 'var ';
		put: aVariableInfo name;
		put: ' = null;';
		cr

		
]

{ #category : #accessing }
SWMBTofJS >> type [
	^ type ifNil: [ type := #js ]
]
