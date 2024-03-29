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
			<< (anExpression messageInfo operands allButFirst collect: [ :v |
				self typeNameOf: v type value
			])
	]
]

{ #category : #'as yet unclassified' }
SWMangleOfF90 class >> transpiledBindCTypeNameOf: aType [
	aType = Integer ifTrue: [
		^ 'Integer'
	].
	aType = SmallInteger ifTrue: [
		^ 'Integer'
	].
	(aType = Float or: [aType = Float class]) ifTrue: [
		^ 'Real(c_double)'
	].
	self error; flag: #toImplement.
]

{ #category : #'as yet unclassified' }
SWMangleOfF90 class >> transpiledTypeNameOf: aType [
	(aType = Integer or: [ aType = Integer class ]) ifTrue: [
		^ 'Integer'
	].
	(aType = SmallInteger or: [ aType = SmallInteger class ]) ifTrue: [
		^ 'Integer'
	].
	(aType = Float or: [aType = Float class]) ifTrue: [
		^ 'double precision'
	].
	self error; flag: #toImplement.
]
