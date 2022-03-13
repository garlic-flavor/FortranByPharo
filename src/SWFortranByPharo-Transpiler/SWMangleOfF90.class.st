"
SWMangleOfF90 is an implementation of SWMangle for Fortran 90.
"
Class {
	#name : #SWMangleOfF90,
	#superclass : #SWMangle,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #api }
SWMangleOfF90 class >> mangle: anExpression [

	^ String streamContents: [ :s ||owner|
		owner := (anExpression method methodClass).
		owner isClassSide ifTrue: [ 
			s << owner soleInstance name; << 'C'
		] ifFalse: [
			s << owner name; << '_'
		].
		s
			<< (self safeSelectorNameOf: anExpression method selector);
			<< (anExpression messageInfo operands collect: [ :v |
				self typeNameOf: v type value
			])
	]
]
