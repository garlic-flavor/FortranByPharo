Class {
	#name : #SWTranspilerBaseOld,
	#superclass : #Object,
	#instVars : [
		'type',
		'logger'
	],
	#category : #'SWFortranByPharo-Client-Transpiler'
}

{ #category : #accessing }
SWTranspilerBaseOld class >> analyzerClass [

	^ SWMethodInfo
]

{ #category : #utils }
SWTranspilerBaseOld class >> domainSpecificMessageTranspilerOf: arg1 [

	^ ((self safeSelectorNameOf: arg1) , 'For:With:') asSymbol
]

{ #category : #utils }
SWTranspilerBaseOld class >> safeSelectorNameOf: arg1 [

	arg1 = '=' ifTrue: [ ^ 'opEqual_' ].
	arg1 = '~=' ifTrue: [ ^ 'opNotEqual_' ].
	arg1 = ',' ifTrue: [ ^ 'opCamma_' ].
	arg1 = '->' ifTrue: [ ^ 'opArrow_' ].
	arg1 = '/' ifTrue: [ ^ 'opDiv_' ].
	arg1 = '<<' ifTrue: [ ^ 'opWrite_' ].
	^ arg1 collect: [ :arg2 | 
		  (#' >#:/' anySatisfy: [ :arg3 | arg3 = arg2 ])
			  ifTrue: [ $_ ]
			  ifFalse: [ arg2 ] ]
]

{ #category : #testing }
SWTranspilerBaseOld >> hasDomainSpecificTranspilerOf: arg1 ifTrue: arg2 [

	| tmp1 |
	tmp1 := self class domainSpecificMessageTranspilerOf: arg1.
	(self respondsTo: tmp1) ifTrue: [ arg2 value: tmp1 ]
]

{ #category : #testing }
SWTranspilerBaseOld >> ifUniqueMessageTranspilerExistsOn: arg1 of: arg2 thenDo: arg3 [

	| tmp1 tmp2 |
	self
		halt;
		flag: #ToImplement.
	tmp1 := arg1 transpileUsing: self analyzer.
	tmp1 class = Metaclass ifFalse: [ ^ self ].
	tmp2 := self uniqueMessageTranspilerOf: arg2.
	(tmp1 methodDict includesKey: tmp2) ifTrue: [ 
		arg3 value: tmp1 soleInstance value: tmp2 ]
]

{ #category : #accessing }
SWTranspilerBaseOld >> logger [

	^ logger ifNil: [ logger := SWLogger new ] ifNotNil: [ logger ]
]

{ #category : #accessing }
SWTranspilerBaseOld >> logging: arg1 [

	self logger enabled: arg1
]

{ #category : #utils }
SWTranspilerBaseOld >> methodBodyGeneratorNameOf: arg1 [

	^ (String streamContents: [ :arg2 | 
		   arg2
			   << self type;
			   << '_';
			   << (self class safeSelectorNameOf: arg1 selector);
			   << 'Using:' ]) asSymbol
]

{ #category : #'code generation - protected' }
SWTranspilerBaseOld >> putMessage: arg1 send: arg2 with: arg3 [

	self logger log: [ arg1 asString , '>>' , arg2 asString ].
	self
		ifUniqueMessageTranspilerExistsOn: arg1
		of: arg2
		thenDo: [ :arg4 :arg5 | ^ arg4 perform: arg5 with: arg3 with: self ];
		hasDomainSpecificTranspilerOf: arg2
		ifTrue: [ :arg6 | ^ self perform: arg6 with: arg1 with: arg3 ].
	^ self putOrdinaryMessage: arg1 send: arg2 with: arg3
]

{ #category : #'code generation - protected' }
SWTranspilerBaseOld >> putOrdinaryMessage: arg1 send: arg2 with: arg3 [

	^ self subclassResponsibility
]

{ #category : #'public - accessing' }
SWTranspilerBaseOld >> type [

	^ type
]

{ #category : #'public - accessing' }
SWTranspilerBaseOld >> type: arg1 [

	type := arg1
]

{ #category : #utils }
SWTranspilerBaseOld >> uniqueMessageTranspilerOf: arg1 [

	^ (String streamContents: [ :arg2 | 
		   arg2
			   << self type;
			   << '_';
			   << (self class safeSelectorNameOf: arg1);
			   << 'With:Using:' ]) asSymbol
]
