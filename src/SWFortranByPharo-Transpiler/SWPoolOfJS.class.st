"
an implementation of SWTranspilerPool for ECMAScript.
"
Class {
	#name : #SWPoolOfJS,
	#superclass : #SWTranspilerPool,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #accessing }
SWPoolOfJS class >> classInfoClass [
	^ SWCDTofJS
]

{ #category : #'as yet unclassified' }
SWPoolOfJS class >> methodBodyTranspilerClass [
	^ SWMBTofJS
]

{ #category : #'as yet unclassified' }
SWPoolOfJS >> transpile_Collection: cdt [
	cdt
		senderTranspilerOf: #inject:into: is: [ :mbt |
			mbt
				transpileChild: mbt children first;
				putClassAccessor;
				put: 'reduce('.
			(mbt child: mbt children third) putClosure.
			mbt
				put: ', ';
				transpileChildWithBracket: mbt children second;
				put: ')'.
"
			aNode := sender node.
			transpiler
				<< aNode receiver;
				putClassAccessor;
				put: 'reduce(';
				<< (aNode arguments at: 2);
				put: ', ';
				<< (aNode arguments at: 1);
				put: ')'
"
		]
]

{ #category : #'as yet unclassified' }
SWPoolOfJS >> transpile_String: cdt [
	cdt
		senderTranspilerOf: #beginsWith: is: [ :mbt |
			mbt putMessageWithSelector: 'startsWith'
		];
		senderTranspilerOf: #endsWith: is: [ :mbt |
			mbt  putMessageWithSelector: 'endsWith'
		]

]
