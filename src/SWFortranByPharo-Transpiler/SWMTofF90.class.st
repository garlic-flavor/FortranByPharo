"
SWMTofF90 is an implementation of SWModuleTranspiler for Fortran 90.
"
Class {
	#name : #SWMTofF90,
	#superclass : #SWModuleTranspiler,
	#instVars : [
		'name'
	],
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #accessing }
SWMTofF90 class >> poolClass [
	^ SWPoolOfF90
]

{ #category : #accessing }
SWMTofF90 >> bindC [

	^ self mainTranspiler bindC
]

{ #category : #accessing }
SWMTofF90 >> bindC: anObject [

	self mainTranspiler bindC: anObject
]

{ #category : #accessing }
SWMTofF90 >> exeFilename [
	^ String streamContents: [ :s | self putExeFilenameOn: s ]
]

{ #category : #accessing }
SWMTofF90 >> main: aScript [
	(aScript includesBehavior: SWFProgram) ifTrue: [
		self name: aScript name
	].
	^ super main: aScript
]

{ #category : #accessing }
SWMTofF90 >> name [

	^ name ifNil: [ name := 'anonymous' ]
]

{ #category : #accessing }
SWMTofF90 >> name: anObject [

	name := anObject
]

{ #category : #streaming }
SWMTofF90 >> putBasenameOn: aStream [
	aStream << self name
]

{ #category : #streaming }
SWMTofF90 >> putExeFilenameOn: aStream [
	aStream << 'cache/'.
	self putBasenameOn: aStream.
	aStream << '.out'
]

{ #category : #streaming }
SWMTofF90 >> putFilenameOn: aStream [
	aStream << 'cache/'.
	self putBasenameOn: aStream.
	aStream << '.f90'
]

{ #category : #accessing }
SWMTofF90 >> stream [
	^ stream ifNil: [
		stream := SWTranspilerStream new
			delimiter: '';
			firstLineHeaderOfComment: '!';
			middleLineHeaderOfComment: '!';
			lastLineOfComment: '!';
			singleLineHeaderOfComment: '!';
			yourself
	]
]

{ #category : #'public API' }
SWMTofF90 >> transpile [
	self solveDependencies.

	self stream
		<< 'program '; << self name; << '_program'; putLine; incIndent.
	self pool payload keysDo: [ :aClass |
		aClass = self mainTranspiler receiverClass ifFalse: [
			(aClass includesBehavior: SWFProgram) ifTrue: [
				self stream << 'use '; << aClass name; << '_module'; putLine.
			]
		]
	].
	self stream << 'implicit none'; putLine.
	self mainTranspiler transpileAsMain.
	self stream decIndent; << 'contains'; putLine; incIndent.

	(self pool getClassInfo: self mainTranspiler receiverClass instanceSide) putMember.
"
	cdt := (self pool getClassInfo: aClass).
	cdt isTranspiled ifTrue: [ ^ self ].
	cdt transpile.

	self transpile: self mainTranspiler expression method methodClass instanceSide.
	self transpile: self mainTranspiler receiverClass instanceSide.
"	

	self stream decIndent; << 'end program '; << self name; << '_program'; putLine.

]

{ #category : #'as yet unclassified' }
SWMTofF90 >> transpileAsBindCFunc [
	self bindC: true.
	self solveDependencies.
	
	self stream
		<< 'module '; << self name; << '_module'; putLine;
		incIndent;
		<< 'use iso_c_binding'; putLine;
		<< 'implicit none'; putLine;
		decIndent;
		<< 'contains'; putLine;
		incIndent;
		<< 'function '; << self name; << ' ('.
	self mainTranspiler putArgumentDeclaration: self mainTranspiler expression arguments.

	self stream
		<< ') result(return) bind(c, Name=';
		<< (Character value: 39); << self name; << '_c'; << (Character value: 39); << ')'; putLine;
		incIndent.
	self mainTranspiler putSequenceAndReturn.
	self stream
		decIndent;
		<< 'end function ';
		<< self name; putLine;
		decIndent;
		<< 'end module ';
		<< self name;
		<< '_module'; putLine
]
