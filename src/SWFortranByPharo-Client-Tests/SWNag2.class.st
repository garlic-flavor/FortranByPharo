"
I came from: https://www.nag-j.co.jp/fortran/FI_3.html
"
Class {
	#name : #SWNag2,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-Tests-Uncategorized'
}

{ #category : #'code generation - deprecated' }
SWNag2 class >> mysub: i [
	SWFStd print: i.

]

{ #category : #'code generation - deprecated' }
SWNag2 class >> program [
	|i|
	i := 99.
	self mysub: i.

]

{ #category : #tests }
SWNag2 class >> test [
	Transcript show: 'Hello!'; cr.
	^ (Smalltalk globals at: self name) new
]