"
I generate mangled name for ECMAScript.
"
Class {
	#name : #SWMangleOfJS,
	#superclass : #SWMangle,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #api }
SWMangleOfJS class >> methodNameOf: selector with: args [
	^ self safeSelectorNameOf: selector

]
