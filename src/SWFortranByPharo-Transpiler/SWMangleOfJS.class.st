"
I generate mangled name for ECMAScript.
"
Class {
	#name : #SWMangleOfJS,
	#superclass : #SWMangle,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #api }
SWMangleOfJS class >> methodNameOf: method with: args [
	^ self safeSelectorNameOf: method selector

]
