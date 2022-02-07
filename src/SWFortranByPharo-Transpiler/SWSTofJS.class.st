"
SWSTofJS is an implementation of SWSenderTranspiler for ECMAScript.
"
Class {
	#name : #SWSTofJS,
	#superclass : #SWSenderTranspiler,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #constants }
SWSTofJS class >> mangleClass [
	^ SWMangleOfJS
]
