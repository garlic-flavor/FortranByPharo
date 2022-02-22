Class {
	#name : #SWDecoderTestOld,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Analyzer-Tests-Olds'
}

{ #category : #tests }
SWDecoderTestOld >> test_11_ZnServer_startOn [
	|sa|
	sa := SWDecoderOld new: SWServer>>#startOn: with: { SWServer. SmallInteger }.
	sa pool addInitializerIn: SWServer.
"
	sa debugMode: true.
"
	sa decode.
	self assert: sa return value equals: SWServer.

]
