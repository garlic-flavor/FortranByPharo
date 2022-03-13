"
Fortran project runner.
"
Class {
	#name : #SWPRofF90,
	#superclass : #SWProjectRunner,
	#category : #'SWFortranByPharo-ClientServer-Client'
}

{ #category : #compiling }
SWPRofF90 >> compile: aModule [
	^ self exec: 'gfortran' with: { '-o'. aModule exeFilename. aModule filename }
]

{ #category : #execution }
SWPRofF90 >> execute: aModule [
	^ self
		compile: aModule;
		run: aModule
]

{ #category : #running }
SWPRofF90 >> run: aModule [
	^ self exec: aModule exeFilename with: #()
]
