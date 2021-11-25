"
I transpile Pharo to ECMAScript.
"
Class {
	#name : #SWMBTofJS,
	#superclass : #SWMethodBodyTranspiler,
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #'code generation' }
SWMBTofJS >> putStatement: aStatement [.
	self << aStatement.
	self put: ';'.
	self stream putLine.
]
