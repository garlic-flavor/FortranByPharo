Class {
	#name : #SWTestP2,
	#superclass : #SWFProgram,
	#category : #'SWFortranByPharo-Tests'
}

{ #category : #accessing }
SWTestP2 >> main [
	|i|
	SWType declare: #i as: Integer.
	i := 99.
	self mysub: i.
]

{ #category : #'as yet unclassified' }
SWTestP2 >> mysub: a [
	io ln: a
]
