Class {
	#name : #SWServerJSTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-ClientServer-Tests'
}

{ #category : #tests }
SWServerJSTest >> testPut [
	|client result|
	client := SWClient new.
	result := client put: 'test.txt' contents: ('hello, world!', String crlf).
	result inspect
]
