Extension { #name : #SequenceableCollection }

{ #category : #'*SWFortranByPharo-Analyzer' }
SequenceableCollection class >> initializeClassSideTranspiler: transpiler [
	transpiler 
		declareMethodReturnsReceiver: #streamContents:
]

{ #category : #'*SWFortranByPharo-Analyzer' }
SequenceableCollection class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		declareMethodReturnsReceiver: #copyFrom:to:;
		declareMethodReturnsReceiver: #do:;
		declareMethodReturnsReceiver: #,;
		declareMethod: #includes: asReturn: Boolean;
		declareMethod: #collect: asReturn: Array
]
