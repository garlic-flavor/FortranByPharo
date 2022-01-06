"
I represent a project of ECMAScript.
"
Class {
	#name : #SWPTofJS,
	#superclass : #SWProjectTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #protected }
SWPTofJS class >> mainModuleFrom: aClass [
	^ SWMTofJS newMainProgramFrom: aClass
]
