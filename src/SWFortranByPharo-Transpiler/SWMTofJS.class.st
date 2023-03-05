"
I represent a source file of ECMAScript (for nodejs).
"
Class {
	#name : #SWMTofJS,
	#superclass : #SWModuleTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #accessing }
SWMTofJS class >> poolClass [
	^ SWPoolOfJS
]

{ #category : #streaming }
SWMTofJS >> putFilenameOn: aStream [
	aStream << 'cache/'.
	self putBasenameOn: aStream.
	aStream << '.mjs'
]
