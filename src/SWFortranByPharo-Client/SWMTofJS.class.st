"
I represent a source file of ECMAScript (for nodejs).
"
Class {
	#name : #SWMTofJS,
	#superclass : #SWModuleTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #constants }
SWMTofJS class >> extension [
	^ #mjs
]

{ #category : #generators }
SWMTofJS class >> mainProgramTranspilerFrom: aClass [
	^ SWMBTofJS new: #main types: { aClass classSide }
]
