Extension { #name : #String }

{ #category : #'*SWFortranByPharo-Analyzer' }
String class >> initializeClassSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiversInstance: #crlf;
		declareMethodReturnsReceiversInstance: #cr
]

{ #category : #'*SWFortranByPharo-Analyzer' }
String class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiver: #trimLeft:right:;
		declareMethodReturnsReceiver: #translateWith:;
		declareMethodAsCompareOperator: #=;
		declareMethodReturnsReceiver: #endsWith:;
		declareMethodReturnsReceiver: #beginsWith:
]
