"
SWMTofF90 is an implementation of SWModuleTranspiler for Fortran 90.
"
Class {
	#name : #SWMTofF90,
	#superclass : #SWModuleTranspiler,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #'as yet unclassified' }
SWMTofF90 class >> poolClass [
	^ SWPoolOfF90
]

{ #category : #'as yet unclassified' }
SWMTofF90 >> exeFilename [
	^ String streamContents: [ :s | self putExeFilenameOn: s ]
]

{ #category : #'as yet unclassified' }
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
			yourself
	]
]

{ #category : #'public API' }
SWMTofF90 >> transpile: aClass [
	self flag: #toImplement.
]

{ #category : #'as yet unclassified' }
SWMTofF90 >> transpilePayload [
	self error; flag: #toRemove.
	self stream
		put: 'program ';
		put: self basename;
		putLine;
		incIndent.
	super transpilePayload.
	self stream
		decIndent;
		put: 'end program ';
		put: self basename;
		putLine
]
