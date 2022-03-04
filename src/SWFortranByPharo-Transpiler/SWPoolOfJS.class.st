"
an implementation of SWTranspilerPool for ECMAScript.
"
Class {
	#name : #SWPoolOfJS,
	#superclass : #SWTranspilerPool,
	#category : #'SWFortranByPharo-Transpiler-JS'
}

{ #category : #constants }
SWPoolOfJS class >> classInfoClass [
	^ SWCDTofJS
]

{ #category : #constants }
SWPoolOfJS class >> mangleClass [
	^ SWMangleOfJS
]

{ #category : #constants }
SWPoolOfJS class >> methodBodyTranspilerClass [
	^ SWMBTofJS
]

{ #category : #'as yet unclassified' }
SWPoolOfJS >> transpile_Array: cdt [
	cdt
		senderTranspilerOf: #anySatisfy: is: [ :mbt | mbt putMessageWithSelector: 'find' ]
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
SWPoolOfJS >> transpile_FileLocator: ctd [
	ctd
		senderTranspilerOf: #/ is: [ :mbt |
			mbt putMessageWithSelector: #joinPath_
		]
]

{ #category : #'as yet unclassified' }
SWPoolOfJS >> transpile_PositionableStream: cdt [
	cdt
		senderTranspilerOf: #upToEnd is: [ :mbt | mbt putMessageWithSelector: 'read' ]
]

{ #category : #'as yet unclassified' }
SWPoolOfJS >> transpile_String: cdt [
	cdt
		senderTranspilerOf: #beginsWith: is: [ :mbt | mbt putMessageWithSelector: 'startsWith' ];
		senderTranspilerOf: #endsWith: is: [ :mbt | mbt  putMessageWithSelector: 'endsWith' ];
		senderTranspilerOf: #, is: [ :mbt | mbt putOpBinaryWith: #+ ]
]
