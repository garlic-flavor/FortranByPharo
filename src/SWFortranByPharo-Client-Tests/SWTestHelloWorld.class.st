"
I am belong to SWProjectTest
"
Class {
	#name : #SWTestHelloWorld,
	#superclass : #SWProjectSource,
	#category : #'SWFortranByPharo-Client-Tests'
}

{ #category : #grammar }
SWTestHelloWorld >> program [
	self print: 'Hello, World!'
]

{ #category : #accessing }
SWTestHelloWorld >> programName [
	^ 'HelloWorld'
]
