Class {
	#name : #SWTerminalMorphTest,
	#superclass : #TestCase,
	#instVars : [
		'terminal'
	],
	#category : #'SWFortranByPharo-ClientServer-Tests-Shell'
}

{ #category : #initialization }
SWTerminalMorphTest >> setUp [
	super setUp.
	terminal := 	SWTerminalMorph new
		openInWorld;
		yourself.

	"Put here a common initialization logic for tests"
]

{ #category : #tests }
SWTerminalMorphTest >> test_run_calc [

	terminal input: '3+4'.
]

{ #category : #tests }
SWTerminalMorphTest >> test_run_ls [
	terminal execute: 'ls -l'.

]

{ #category : #tests }
SWTerminalMorphTest >> test_run_output [
	|io|
	
	io := terminal newIO.
	io outputStream << 'hogehoge'.
]
