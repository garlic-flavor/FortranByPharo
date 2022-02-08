"
I transpile CompiledMethod to ECMAScript.
"
Class {
	#name : #SWMDTofJS,
	#superclass : #SWMethodDefinitionTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #'code generation' }
SWMDTofJS >> putFunctionFooter [
	self stream putLine: '}'.

]

{ #category : #'code generation' }
SWMDTofJS >> putFunctionHeader [
	self bodyTranspiler method methodClass isClassSide ifTrue: [
		self stream put: 'static '
	].
	self stream
		put: self bodyTranspiler mangledName;
		put: '('.

	self bodyTranspiler arguments do: [ :vi |
		self stream put: vi name
	] separatedBy: [
		self stream put: ', '
	].
	self stream putLine: '){'.

]
