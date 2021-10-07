"
I am belong to SWProjectTest
"
Class {
	#name : #SWTestHelloWorld,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-Tests'
}

{ #category : #'code generation' }
SWTestHelloWorld class >> mjs_requirements [
	^ { 
		SWStd.
	}
]

{ #category : #running }
SWTestHelloWorld class >> program [
	SWFStd print: 'Hello, World!'
]

{ #category : #accessing }
SWTestHelloWorld >> main: args [
	self print: 'Hello, World!'
]

{ #category : #'code generation - deprecated' }
SWTestHelloWorld >> program [
	self print: 'Hello, World!'
]

{ #category : #'code generation - deprecated' }
SWTestHelloWorld >> program2 [
	|a|
	a := 1 + 2.
	self print: a
]

{ #category : #'code generation - deprecated' }
SWTestHelloWorld >> program3 [
	|a|
	a := 1 + (2 * 3).
	self print: a
]

{ #category : #'code generation - deprecated' }
SWTestHelloWorld >> program4 [
	|a|
	a := 'Hello, world'.
	self print: (a at: 1).
]

{ #category : #'code generation - deprecated' }
SWTestHelloWorld >> program5 [
	|a|
	a := { 10. 20. 30. 40. 50 }.
	self print: (a at: 1)
]
