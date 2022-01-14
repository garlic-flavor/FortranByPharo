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
	self error; flag: #toRemove.
	^ #mjs
]

{ #category : #'as yet unclassified' }
SWMTofJS class >> methodBodyTranspilerClass [ 
	^ SWMBTofJS
]
