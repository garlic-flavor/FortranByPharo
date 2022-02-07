Extension { #name : #OSSUnixSubprocess }

{ #category : #'*SWFortranByPharo-Analyzer' }
OSSUnixSubprocess class >> initializeInstanceSideTranspiler: transpiler [
	transpiler 
		declareMethod: #defaultEncoding asReturn: ZnCharacterEncoder;
		declareMethodReturnsReceiver: #run;
		declareMethod: #waitForExit asReturn: SmallInteger

]
