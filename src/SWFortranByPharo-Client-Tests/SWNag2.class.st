"
This is from: https://www.nag-j.co.jp/fortran/FI_3.html
"
Class {
	#name : #SWNag2,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-Tests'
}

{ #category : #'as yet unclassified' }
SWNag2 class >> my2ndSub: a [
	SWFStd declare: #a as: #integer.
	SWFStd print: a * 2.
]

{ #category : #'as yet unclassified' }
SWNag2 class >> mysub: a [
	SWFStd declare: #a as: #integer.
	SWFStd print: a
]

{ #category : #'code generation - deprecated' }
SWNag2 class >> program [
	|i|
	SWFStd declare: #i as: #integer.
	i := 99.
	SWNag2 mysub: i.
]
