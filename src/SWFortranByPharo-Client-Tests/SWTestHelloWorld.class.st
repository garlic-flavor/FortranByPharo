"
I am belong to SWProjectTest
"
Class {
	#name : #SWTestHelloWorld,
	#superclass : #SWStd,
	#category : #'SWFortranByPharo-Client-Tests'
}

{ #category : #grammar }
SWTestHelloWorld >> program [
	self print: 'Hello, World!'
]

{ #category : #'as yet unclassified' }
SWTestHelloWorld >> program2 [
	|a|
	a := 1 + 2.
	self print: a
]

{ #category : #'as yet unclassified' }
SWTestHelloWorld >> program3 [
	|a|
	a := 1 + (2 * 3).
	self print: a
]

{ #category : #'as yet unclassified' }
SWTestHelloWorld >> program4 [
	|a|
	a := 'Hello, world'.
	self print: (a at: 1).
]

{ #category : #'as yet unclassified' }
SWTestHelloWorld >> program5 [
	|a|
	a := { 10. 20. 30. 40. 50 }.
	self print: (a at: 1)
]
