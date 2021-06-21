"
This resolve file reference from filename.
"
Class {
	#name : #SWFileManager,
	#superclass : #Object,
	#instVars : [
		'dispatcher',
		'base'
	],
	#category : #'SWFortranByPharo-Server-Shell'
}

{ #category : #adding }
SWFileManager >> add: directory withRuleOf: selector [
	dispatcher if: selector then: [ :file |
		directory isEmpty
			ifTrue: [ base / file ]
			ifFalse: [base / directory / file]
	].

]

{ #category : #dispatching }
SWFileManager >> dispatch: file [
	| path |
	path := dispatcher detect: file.
	(path parent) ensureCreateDirectory.
	^ path
]

{ #category : #initialization }
SWFileManager >> initialize [ 
	super initialize.
	dispatcher := SWDispatcher new.
	base := FileLocator imageDirectory.

]
