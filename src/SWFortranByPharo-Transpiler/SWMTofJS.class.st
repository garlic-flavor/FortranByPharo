"
I represent a source file of ECMAScript (for nodejs).
"
Class {
	#name : #SWMTofJS,
	#superclass : #SWModuleTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #'as yet unclassified' }
SWMTofJS class >> poolClass [
	^ SWPoolOfJS
]

{ #category : #streaming }
SWMTofJS >> putFilenameOn: aStream [
	aStream << 'cache/'.
	super putFilenameOn: aStream.
	aStream << '.mjs'
]
