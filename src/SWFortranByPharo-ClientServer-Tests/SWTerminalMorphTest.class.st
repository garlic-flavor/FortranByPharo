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
	terminal := 	SWTerminalMorphtoRemove start.

	"Put here a common initialization logic for tests"
]

{ #category : #running }
SWTerminalMorphTest >> tearDown [
	terminal close
]

{ #category : #tests }
SWTerminalMorphTest >> test_run_calc [
	terminal input: '3+4'.
	self assert: terminal contents asString equals: (' % 3+4', String cr, 'hoge! 7 hoge!', String cr)
]

{ #category : #tests }
SWTerminalMorphTest >> test_run_ls [
	
	terminal execute: 'ls -l'.

]

{ #category : #tests }
SWTerminalMorphTest >> test_run_output [

	terminal inputStream << 'hogehoge'; cr
]
