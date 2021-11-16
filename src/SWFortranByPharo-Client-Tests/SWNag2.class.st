"
I came from: https://www.nag-j.co.jp/fortran/FI_3.html
"
Class {
	#name : #SWNag2,
	#superclass : #Object,
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
SWNag2 class >> test2 [
	^ 345
]

{ #category : #tests }
SWNag2 class >> test3: bbb [
	|aaa|
	aaa := 123.
	^ aaa + bbb
]

{ #category : #tests }
SWNag2 class >> test4 [
	^ 'hoge'
]

{ #category : #tests }
SWNag2 class >> test4: val [
	^ 0 < val ifTrue: [ val + (self test4: (val-1)) ] ifFalse: [ 0 ]
]

{ #category : #tests }
SWNag2 class >> test5 [
	|v1 v2 v3 v4 v5 v6 v7 v8 v9|
	v9 := SWVariableInfo new const: true; yourself.
]

{ #category : #tests }
SWNag2 class >> test6: a [
	^ a = 5 ifTrue: [|b|
		b := 100.
		b
	] ifFalse: [
		200
	]
]
