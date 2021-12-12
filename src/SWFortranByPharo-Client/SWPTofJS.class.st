"
I represent a project of ECMAScript.
"
Class {
	#name : #SWPTofJS,
	#superclass : #SWProjectTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #protected }
SWPTofJS class >> mainModuleFrom: aClass [
	^ SWMTofJS newMainProgramFrom: aClass
]
