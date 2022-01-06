"
I represent a source file of ECMAScript (for nodejs).
"
Class {
	#name : #SWMTofJS,
	#superclass : #SWModuleTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #constants }
SWMTofJS class >> extension [
	^ #mjs
]

{ #category : #generators }
SWMTofJS class >> mainProgramTranspilerFrom: aClass [
	^ SWMBTofJS new: aClass classSide>>#main with: { aClass classSide }
]
