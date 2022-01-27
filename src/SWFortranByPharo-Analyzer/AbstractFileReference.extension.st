Extension { #name : #AbstractFileReference }

{ #category : #'*SWFortranByPharo-Analyzer' }
AbstractFileReference class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiver: #joinPath:;
		defineMethod: #contains: asReturn: Boolean;
		defineMethod: #exists asReturn:Boolean;
		defineMethod: #fullName asReturn: String

]
