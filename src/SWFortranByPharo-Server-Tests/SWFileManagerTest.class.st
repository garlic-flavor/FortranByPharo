Class {
	#name : #SWFileManagerTest,
	#superclass : #TestCase,
	#instVars : [
		'fm',
		'base'
	],
	#category : #'SWFortranByPharo-Server-Tests-Shell'
}

{ #category : #running }
SWFileManagerTest >> setUp [
	super setUp.
	fm := SWFileManager new.
	base := FileLocator imageDirectory.

]

{ #category : #tests }
SWFileManagerTest >> testGetReferenceOf [
	fm add: 'src' withRuleOf: [ :file | (Path * file) extension asLowercase beginsWith: 'f' ].
	fm add: 'obj' withRuleOf: [ :file | #('o' 'obj') includes: (Path * file) extension asLowercase ].
	fm add: 'exe' withRuleOf: [ :file | #('' 'out' 'exe') includes: (Path * file) extension asLowercase ].
	fm add: '' withRuleOf: [ :file | true ].
	self assert: (fm dispatch: 'test.f08') equals: (base / 'src' / 'test.f08').
	self assert: (fm dispatch: 'hoge.o') equals: (base / 'obj' / 'hoge.o').
	self assert: (fm dispatch: 'fuga') equals: (base / 'exe' / 'fuga').
	self assert: (fm dispatch: 'moge.c') equals: (base / 'moge.c').
]
