"
I came from: https://www.nag-j.co.jp/fortran/FI_3.html
"
Class {
	#name : #SWNag2,
	#superclass : #Object,
	#instVars : [
		'hoge'
	],
	#category : #'SWFortranByPharo-Client-Tests-Uncategorized'
}

{ #category : #running }
SWNag2 class >> f90_requirements: transpiler [

]

{ #category : #running }
SWNag2 class >> mysub: i [
	SWFStd print: i.

]

{ #category : #running }
SWNag2 class >> program [
	<script>
	|i|
	i := SWVariableInfo new type: Integer.
	i := 99.
	i := 3.14.
	self mysub: i.

]

{ #category : #tests }
SWNag2 class >> test [
	Transcript show: 'Hello!'; cr.
	^ (Smalltalk globals at: self name) new
]

{ #category : #tests }
SWNag2 >> test2 [
	^ hoge ifNil: [ hoge := OrderedCollection  new ]
]
