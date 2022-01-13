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
		defineMethod: #includes: as: Boolean;
		defineMethod: #collect: as: Array
]
