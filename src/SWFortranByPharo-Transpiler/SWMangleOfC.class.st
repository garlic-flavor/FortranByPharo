Class {
	#name : #SWMangleOfC,
	#superclass : #SWMangle,
	#category : #'SWFortranByPharo-Transpiler'
}

{ #category : #'as yet unclassified' }
SWMangleOfC class >> transpiledTypeNameOf: aType [
	aType = Integer ifTrue: [
		^ 'int'
	].
	aType = SmallInteger ifTrue: [
		^ 'char'
	].
	(aType = Float or: [aType = Float class]) ifTrue: [
		^ 'double'
	].
	self error; flag: #toImplement.
]
