Extension { #name : #OSSUnixSubprocess }

{ #category : #'*SWFortranByPharo-Analyzer' }
OSSUnixSubprocess class >> initializeInstanceSideTranspiler: transpiler [
	transpiler 
		defineMethod: #defaultEncoding asReturn: ZnCharacterEncoder;
		defineMethodReturnsReceiver: #run;
		defineMethod: #waitForExit asReturn: SmallInteger

]
