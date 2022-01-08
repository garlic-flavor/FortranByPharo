Extension { #name : #OSSUnixSubprocess }

{ #category : #'*SWFortranByPharo-Analyzer' }
OSSUnixSubprocess class >> initializeInstanceSideTranspiler: transpiler [
	transpiler 
		defineMethod: #defaultEncoding as: ZnCharacterEncoder;
		defineMethodReturnsReceiver: #run;
		defineMethod: #waitForExit as: SmallInteger
]
