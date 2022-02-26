"
an implementation of SWTranspilerPool for ECMAScript.
"
Class {
	#name : #SWPoolOfJS,
	#superclass : #SWTranspilerPool,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #accessing }
SWPoolOfJS class >> classInfoClass [
	^ SWCDTofJS
]

{ #category : #'as yet unclassified' }
SWPoolOfJS class >> methodBodyTranspilerClass [
	^ SWMBTofJS
]
