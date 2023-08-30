"
SWMTofF90 is an implementation of SWModuleTranspiler for Fortran 90.
"
Class {
	#name : #SWMTofF90,
	#superclass : #SWModuleTranspiler,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #accessing }
SWMTofF90 class >> poolClass [
	^ SWPoolOfF90
]

{ #category : #accessing }
SWMTofF90 >> exeFilename [
	^ String streamContents: [ :s | self putExeFilenameOn: s ]
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

	self stream put: 'program '.
	self putBasenameOn: self stream.
	self stream putLine; incIndent; put: 'implicit none'; putLine.
	self mainTranspiler transpileAsMain.
	self stream decIndent; putLine: 'contains'; incIndent.
	self transpile: self mainTranspiler expression method methodClass.
	self stream decIndent; put: 'end program '.
	self putBasenameOn: self stream.
	self stream putLine
]

{ #category : #'as yet unclassified' }
SWMTofF90 >> transpileAsBindCFunc: aName [
	self solveDependencies.
	
	self stream
		<< 'module '; << aName; << '_module'; putLine;
		incIndent;
		<< 'use iso_c_binding'; putLine;
		<< 'implicit none'; putLine;
		decIndent;
		<< 'contains'; putLine;
		incIndent;
		<< 'function '; << aName; << '_f ('.
	self stream
		<< ') bind(c, Name=';
		<< (Character value: 39); << aName; << (Character value: 39); << ')'; putLine;
		incIndent.
	self mainTranspiler transpileAsMain.
	self stream
		decIndent;
		<< 'end function ';
		<< aName; << '_f'; putLine;
		decIndent;
		<< 'end module ';
		<< aName;
		<< '_module'; putLine
]
