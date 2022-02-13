"
SWMangleOfF90 is an implementation of SWMangle for Fortran 90.
"
Class {
	#name : #SWMangleOfF90,
	#superclass : #SWMangle,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #api }
SWMangleOfF90 class >> mangle: selector [

	^ String streamContents: [ :s ||owner|
		owner := (selector method methodClass).
		owner isClassSide ifTrue: [ 
			s << owner soleInstance name; << 'C'
		] ifFalse: [
			s << owner name; << '_'
		].
		s
			<< (self safeSelectorNameOf: selector method selector);
			<< (selector operands collect: [ :v |
				self typeNameOf: v type value
			])
	]
]
