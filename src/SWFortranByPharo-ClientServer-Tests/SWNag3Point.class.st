Class {
	#name : #SWNag3Point,
	#superclass : #SWTypeOld,
	#instVars : [
		'x',
		'y'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #'instance creation' }
SWNag3Point class >> newWith: arg1 [

	| tmp2 |
	tmp2 := self new.
	tmp2
		x: (arg1 at: 1);
		y: (arg1 at: 2).
	^ tmp2 yourself
]

{ #category : #initialization }
SWNag3Point >> initialize [

	super initialize.
	x := SWVariableTypeInfo new type: Float.
	y := SWVariableTypeInfo new type: Float
]

{ #category : #accessing }
SWNag3Point >> x [

	^ x
]

{ #category : #accessing }
SWNag3Point >> x: arg1 [

	x := arg1
]

{ #category : #accessing }
SWNag3Point >> y [

	^ y
]

{ #category : #accessing }
SWNag3Point >> y: arg1 [

	y := arg1
]
