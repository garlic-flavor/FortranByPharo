"
A SWProjectTest is a test class for testing the behavior of SWProject
"
Class {
	#name : #SWProjectTest,
	#superclass : #TestCase,
	#category : #'SWFortranByPharo-Client-Tests'
}

{ #category : #tests }
SWProjectTest class >> testCodeGeneration2 [
	<sampleInstance>
	|project|
	project := SWProject new
			name: 'helloworld';
			description: 'My first Hello, World project.';
			source: SWTestHelloWorld new.
	^ project generate
]

{ #category : #tests }
SWProjectTest class >> testCodeGenerationOfRuby [
	<sampleInstance>
	|project|
	project := SWProject new
			name: 'helloworld';
			description: 'My first Hello, World project.';
			source: (SWTestHelloWorld new type: #rb).
	^ project generate

]

{ #category : #tests }
SWProjectTest class >> testDomestic [
	<sampleInstance>
	|project|
	project := SWProject new
			name: 'helloworld';
			description: 'My first Hello, World project.';
			source: SWTestHelloWorld new.

	^ project goDomestic
]

{ #category : #tests }
SWProjectTest class >> testRequsestDatabaseCreation [
	<sampleInstance>
	|project codes|
	project := SWProject new
			name: 'helloworld';
			description: 'My first Hello, World project.';
			source: SWTestHelloWorld new.
	codes := project generate.
	^ project createRequestingDatabaseOf: codes.
]

{ #category : #tests }
SWProjectTest >> testCodeGeneration [
	|project gen|
	project := SWProject new
			name: 'helloworld';
			description: 'My first Hello, World project.';
			source: SWTestHelloWorld new.
	gen := project generate.
	self assert: (gen at: 1) code equals: 'program HelloWorld
    print *, ''Hello, World!''
end program HelloWorld
'.
]

{ #category : #tests }
SWProjectTest >> testOfHelloWorld [
	|project|
	project := SWProject new
		name: 'helloworld';
		description: 'My first Hello, World project.';
		source: SWTestHelloWorld new.

	self assert: (project goDomestic) equals: (project go).

]
