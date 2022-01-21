Extension { #name : #SequenceableCollection }

{ #category : #'*SWFortranByPharo-Analyzer' }
SequenceableCollection class >> initializeClassSideTranspiler: transpiler [
	transpiler 
		defineMethodReturnsReceiver: #streamContents:
]

{ #category : #'*SWFortranByPharo-Analyzer' }
SequenceableCollection class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodReturnsReceiver: #copyFrom:to:;
		defineMethodReturnsReceiver: #do:;
		defineMethodReturnsReceiver: #,;
		defineMethod: #includes: asReturn: Boolean;
		defineMethod: #collect: asReturn: Array
]
