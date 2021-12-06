Class {
	#name : #SWMBTofJS,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWMBTofJS >> mangledName [

	^ self class safeSelectorNameOf: self method selector
]

{ #category : #'code generation' }
SWMBTofJS >> putStatementDelimiter [

	self put: ';'
]

{ #category : #'code generation' }
SWMBTofJS >> putVariableDeclarationOf: arg1 [

	self
		put: 'var ';
		put: arg1 name;
		put: ' = null;';
		cr
]

{ #category : #accessing }
SWMBTofJS >> type [

	^ type ifNil: [ type := #js ] ifNotNil: [ type ]
]
