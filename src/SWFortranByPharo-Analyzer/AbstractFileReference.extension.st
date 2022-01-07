Extension { #name : #AbstractFileReference }

{ #category : #'*SWFortranByPharo-Analyzer' }
AbstractFileReference class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiver: #joinPath:;
		defineMethod: #contains: as: Boolean;
		defineMethod: #exists as: Boolean
]
