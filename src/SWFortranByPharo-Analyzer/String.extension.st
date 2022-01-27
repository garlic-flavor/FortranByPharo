Extension { #name : #String }

{ #category : #'*SWFortranByPharo-Analyzer' }
String class >> initializeClassSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiversInstance: #crlf;
		defineMethodReturnsReceiversInstance: #cr
]

{ #category : #'*SWFortranByPharo-Analyzer' }
String class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiver: #trimLeft:right:;
		defineMethodReturnsReceiver: #translateWith:;
		defineMethodAsCompareOperator: #=;
		defineMethodReturnsReceiver: #endsWith:;
		defineMethodReturnsReceiver: #beginsWith:
]
