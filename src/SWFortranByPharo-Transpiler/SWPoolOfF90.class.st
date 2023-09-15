"
An implementation of transpiler pool for Fortran.
"
Class {
	#name : #SWPoolOfF90,
	#superclass : #SWTranspilerPool,
	#category : #'SWFortranByPharo-Transpiler-F90'
}

{ #category : #constants }
SWPoolOfF90 class >> classInfoClass [
	^ SWCDTofF90
]

{ #category : #constants }
SWPoolOfF90 class >> mangleClass [
	^ SWMangleOfF90
]

{ #category : #constants }
SWPoolOfF90 class >> methodBodyTranspilerClass [
	^ SWMBTofF90
]

{ #category : #'as yet unclassified' }
SWPoolOfF90 >> transpile_SWIO: cdt [
	cdt
		senderTranspilerOf: #<< is: [ :mbt |
			mbt put: 'write (*, *, advance="no") ';
				transpileChild: mbt children second.
		];
		senderTranspilerOf: #ln is: [ :mbt |
			mbt put: 'write (*, *)'
		];
		senderTranspilerOf: #ln: is: [ :mbt |
			mbt put: 'print *, ';
				transpileChild: mbt children second.
		]
]

{ #category : #'as yet unclassified' }
SWPoolOfF90 >> transpile_SWTypeClass: cdt [
	cdt senderTranspilerOf: #declare:as: is: [ :mbt |
"
		mbt putTypeDeclarationOf: mbt children second as: mbt children third.
"
	]
]
