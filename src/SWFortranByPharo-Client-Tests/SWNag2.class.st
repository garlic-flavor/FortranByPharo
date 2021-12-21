Class {
	#name : #SWNag2,
	#superclass : #Object,
	#instVars : [
		'hoge'
	],
	#category : #'SWFortranByPharo-Client-Tests'
}

{ #category : #running }
SWNag2 class >> f90_requirements: arg1 [

	
]

{ #category : #running }
SWNag2 class >> mysub: arg1 [

	SWStd print: arg1
]

{ #category : #running }
SWNag2 class >> program [

	<script>
	| tmp1 |
	tmp1 := SWVariableTypeInfo new type: Integer.
	tmp1 := 99.
	tmp1 := 3.14.
	self mysub: tmp1
]

{ #category : #tests }
SWNag2 class >> test [

	Transcript
		show: 'Hello!';
		cr.
	^ (Smalltalk globals at: self name) new
]

{ #category : #tests }
SWNag2 >> test2 [

	^ hoge ifNil: [ hoge := OrderedCollection new ] ifNotNil: [ hoge ]
]
