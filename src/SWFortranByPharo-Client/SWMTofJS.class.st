"
I represent a source file of ECMAScript (for nodejs).
"
Class {
	#name : #SWMTofJS,
	#superclass : #SWModuleTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation - protected' }
SWMTofJS >> putRequireLine: aClass [
	self stream
		<< 'import ';
		<< aClass name;
		<< ';'
]
