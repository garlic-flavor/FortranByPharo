"
I came from: https://www.nag-j.co.jp/fortran/FI_4.html
"
Class {
	#name : #SWNag3Point,
	#superclass : #SWType,
	#instVars : [
		'x',
		'y'
	],
	#category : #'SWFortranByPharo-Client-Tests'
}

{ #category : #'instance creation' }
SWNag3Point class >> newWith: arguments [
	^ self new
		x: (arguments at: 1);
		y: (arguments at: 2);
		yourself
]

{ #category : #initialization }
SWNag3Point >> initialize [
	super initialize.
	x := SWVariableInfo new type: Float.
	y := SWVariableInfo new type: Float.
]

{ #category : #accessing }
SWNag3Point >> x [

	^ x
]

{ #category : #accessing }
SWNag3Point >> x: anObject [

	x := anObject
]

{ #category : #accessing }
SWNag3Point >> y [

	^ y
]

{ #category : #accessing }
SWNag3Point >> y: anObject [

	y := anObject
]
