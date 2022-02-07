Extension { #name : #AbstractFileReference }

{ #category : #'*SWFortranByPharo-Analyzer' }
AbstractFileReference class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiver: #joinPath:;
		declareMethod: #contains: asReturn: Boolean;
		declareMethod: #exists asReturn:Boolean;
		declareMethod: #fullName asReturn: String

]
