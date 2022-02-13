"
I generate mangled name for ECMAScript.
"
Class {
	#name : #SWMangleOfJS,
	#superclass : #SWMangle,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #'private - code generation' }
SWMangleOfJS class >> mangle: sender [
	^ self safeSelectorNameOf: sender selector

]
