Extension { #name : #Integer }

{ #category : #'*SWFortranByPharo-Analyzer' }
Integer class >> initializeInstanceSideTranspiler: transpiler [
	transpiler
		defineMethodAsBinaryOperator: #+;
		defineMethodAsBinaryOperator: #-;
		defineMethodAsBinaryOperator: #*;
		defineMethodAsBinaryOperator: #/;
		defineMethodAsCompareOperator: #>=;
		defineMethodAsCompareOperator: #<=;
		defineMethodAsCompareOperator: #>;
		defineMethodAsCompareOperator: #<;
		defineMethodAsCompareOperator: #=
		
]
