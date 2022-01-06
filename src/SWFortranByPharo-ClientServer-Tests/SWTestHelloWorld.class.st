Class {
	#name : #SWTestHelloWorld,
	#superclass : #Object,
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #'code generation' }
SWTestHelloWorld class >> mjs_requirements [

	^ { SWStd }
]

{ #category : #running }
SWTestHelloWorld class >> program [

	SWStd print: 'Hello, World!'
]

{ #category : #accessing }
SWTestHelloWorld >> main: arg1 [

	self print: 'Hello, World!'
]

{ #category : #'code generation - deprecated' }
SWTestHelloWorld >> program [

	self print: 'Hello, World!'
]

{ #category : #'code generation - deprecated' }
SWTestHelloWorld >> program2 [

	| tmp1 |
	tmp1 := 1 + 2.
	self print: tmp1
]

{ #category : #'code generation - deprecated' }
SWTestHelloWorld >> program3 [

	| tmp1 |
	tmp1 := 1 + (2 * 3).
	self print: tmp1
]

{ #category : #'code generation - deprecated' }
SWTestHelloWorld >> program4 [

	| tmp1 |
	tmp1 := 'Hello, world'.
	self print: (tmp1 at: 1)
]

{ #category : #'code generation - deprecated' }
SWTestHelloWorld >> program5 [

	| tmp1 |
	tmp1 := { 10. 20. 30. 40. 50 }.
	self print: (tmp1 at: 1)
]
