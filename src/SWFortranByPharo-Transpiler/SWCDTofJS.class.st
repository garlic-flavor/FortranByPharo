"
I transpile Pharo class to ECMAScript.
"
Class {
	#name : #SWCDTofJS,
	#superclass : #SWClassDefinitionTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #'as yet unclassified' }
SWCDTofJS >> putMemberDeclarationOf: aVariableTypeInfo [

	self targetClass isClassSide ifTrue: [
		self stream put: 'static '
	].
	self stream
		put: aVariableTypeInfo name asString;
		put: ' = null';
		putDelimiter;
		putLine

]
