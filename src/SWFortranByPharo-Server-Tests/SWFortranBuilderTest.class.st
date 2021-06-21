"
A SWFortranBuilderTest is a test class for testing the behavior of SWFortranBuilder
"
Class {
	#name : #SWFortranBuilderTest,
	#superclass : #TestCase,
	#instVars : [
		'b'
	],
	#category : #'SWFortranByPharo-Server-Tests-Builder'
}

{ #category : #running }
SWFortranBuilderTest >> setUp [
	super setUp.
	b := SWFortranBuilder new.
	"Put here a common initialization logic for tests"
]

{ #category : #running }
SWFortranBuilderTest >> testBuilding [
	|source path project res|
	"ready the source to build."
	"The test assumes that gfrotran is on the path."
	source := 'native/helloworld.f90'.
	path := b fm dispatch: source.
	path exists ifTrue: [ path ensureDelete ].
	path writeStream
		nextPutAll: 'program hello'; lf;
		nextPutAll: '    print *, ''Hello, world!'''; lf;
		nextPutAll: 'end program hello'; lf;
		close.


	project := SWFortranProject new
		name: 'helloworld';
		sources: {source}.
	res := b buildThenRun: project.
	self assert: res isSuccess.
]

{ #category : #tests }
SWFortranBuilderTest >> testFileDispatching [
	self assert: (b fm dispatch: 'native/fortran.f90') equals: (FileLocator imageDirectory / 'src' / 'native' / 'fortran.f90').
]
