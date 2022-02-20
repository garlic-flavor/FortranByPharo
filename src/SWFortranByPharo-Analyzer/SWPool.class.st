"
I am a pool of SWClassInfo.
"
Class {
	#name : #SWPool,
	#superclass : #Object,
	#instVars : [
		'payload',
		'owner'
	],
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #utils }
SWPool class >> search: selector in: aClass [
	^ self search: selector in: aClass ifFound: [ :detected | detected ] ifNone: [ self error: (selector, ' is not found in ', aClass asString) ]

]

{ #category : #utils }
SWPool class >> search: selector in: aClass ifFound: foundBlock ifNone: noneBlock [
	aClass ifNil: [ ^ noneBlock value ].

	^ aClass methodDict at: selector ifPresent: [ :detected |
			foundBlock value: detected
	] ifAbsent: [
			self search: selector in: aClass superclass ifFound: foundBlock ifNone: noneBlock
	]

]

{ #category : #api }
SWPool >> addInitializerIn: aClass [
	"invoke aClass>>#initialize_Hoge: with Hoge class transpiler."
	 aClass classSide methodDict values select: [ :each |
		each selector beginsWith: 'initialize_'
	] thenDo: [ :each ||name target|
		name := each selector copyAfter: $_.
		name := (each selector endsWith: 'Class:') ifTrue: [
			name copyUpToLast: $C
		] ifFalse: [
			name copyUpToLast: $:
		].
		name = 'self' ifTrue: [ name := aClass instanceSide name ].
		target := Smalltalk globals at: name asSymbol.
		(each selector endsWith: 'Class:') ifTrue: [
			target := target classSide
		].
		each valueWithReceiver: aClass instanceSide arguments: {
			self getClassTranspiler: target
		}
	]
]

{ #category : #accessing }
SWPool >> classTranspilerClass [

	^ self owner class classTranspilerClass
]

{ #category : #accessing }
SWPool >> decoderClass [

	^ self owner class
]

{ #category : #enumerating }
SWPool >> detect: aNeedle ifFound: aBlock [
self halt; flag: #toRemove.
	^ self payload detect: aNeedle ifFound: aBlock
]

{ #category : #private }
SWPool >> getClassTranspiler: aClass [
	^ self payload at: aClass ifAbsent: [|newCT|
		newCT := self newClassTranspiler: aClass.
		aClass isClassSide ifTrue: [
			(self getClassTranspiler: aClass instanceSide)
		].
		newCT
	]

]

{ #category : #'as yet unclassified' }
SWPool >> getResult: aSelector with: operands [
	^ self class search: aSelector in: operands first value ifFound: [ :method |
		(self getClassTranspiler: method methodClass)
			getResult: aSelector with: operands
	] ifNone: [
		self logger log: [ 'An unknown method detected: ', aSelector ].
		(self haltList includes: #unresolvedSelector)  ifTrue: [ self halt ].
		UndefinedObject
	].

]

{ #category : #'private - accessing' }
SWPool >> haltList [
	^ self owner haltList
]

{ #category : #private }
SWPool >> initialize: aClassTranspiler asOf: aClass [
	|initializer|
	aClass ifNil: [ ^ aClassTranspiler ].
	self initialize: aClassTranspiler asOf: aClass superclass.
	initializer := self initializerFor: aClass.
	(self respondsTo: initializer) ifTrue: [
		self perform: initializer with: aClassTranspiler
	].
	^ aClassTranspiler
]

{ #category : #initialization }
SWPool >> initialize_AbstractBinaryFileStream: ct [
	ct
		declareMethodReturnsReceiver: #position:
]

{ #category : #initialization }
SWPool >> initialize_AbstractFileReference: ct [
	ct
		declareMethodReturnsReceiver: #joinPath:;
		declareMethod: #contains: asReturn: Boolean;
		declareMethod: #exists asReturn: Boolean;
		declareMethodReturnsReceiver: #resolve;
		declareMethodReturnsReceiver: #relativeTo:;
		declareMethod: #fullName asReturn: String;
		declareMethod: #contents asReturn: String;
		declareMethodReturnsReceiver: #parent;
		declareMethodReturnsFirstArgumentsElement: #writeStreamDo:
]

{ #category : #initialization }
SWPool >> initialize_Behavior: ct [
	ct
		declareMethodReturnsReceiversInstance: #basicNew:;
		declareMethodReturnsReceiversInstance: #basicNew
]

{ #category : #initialization }
SWPool >> initialize_BinaryFileStream: ct [
	ct
		declareMethodReturnsReceiver: #truncate:
]

{ #category : #initialization }
SWPool >> initialize_BlockClosure: ct [
	ct
		declareMethodReturnsReceiversElement: #on:do:;
		declareMethodReturnsReceiversElement: #ensure:
]

{ #category : #initialization }
SWPool >> initialize_Boolean: ct [
	ct
		declareMethodReturnsFirstArgument: #ifTrue:;
 		declareMethodReturnsFirstArgument: #ifFalse:;
		declareMethodReturnsFirstArgument: #ifTrue:ifFalse:;
		declareMethodReturnsFirstArgument: #ifFalse:ifTrue:;
		declareMethodReturnsFirstArgument: #and:;
		declareMethodReturnsFirstArgument: #or:
]

{ #category : #initialization }
SWPool >> initialize_Character: ct [
	ct
		declareMethod: #asInteger asReturn: Integer
]

{ #category : #initialization }
SWPool >> initialize_CharacterClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #value:
]

{ #category : #initialization }
SWPool >> initialize_Collection: ct [
	ct
		declareMethodReturnsSecondArgument: #detect:ifNone:;
		declareMethodReturnsFirstArgument: #inject:into:;
		declareMethod: #anySatisfy: asReturn: Boolean
]

{ #category : #initialization }
SWPool >> initialize_DateAndTimeClass: ct [
	ct
		declareMethodReturnsReceiversClass: #now
]

{ #category : #initialization }
SWPool >> initialize_Dictionary: ct [
	ct
		declareMethodReturnsSecondArgument: #at:put:;
		declareMethodReturnsSecondArgumentsElement: #at:ifAbsent:;
		declareMethodReturnsSecondArgumentsElement: #at:ifAbsentPut:;
		declareMethod: #includesKey: asReturn: Boolean;
		declareMethodReturnsReceiver: #stonOn:
]

{ #category : #initialization }
SWPool >> initialize_DictionaryClass: ct [
	ct
		declareMethodReturnsReceiversClass: #fromSton:
]

{ #category : #initialization }
SWPool >> initialize_Exception: ct [
	ct
		declareMethodReturnsReceiver: #signal
]

{ #category : #initialization }
SWPool >> initialize_IntervalClass: ct [
	ct
		setBreakpointOn: #new
]

{ #category : #initialization }
SWPool >> initialize_Magnitude: ct [
	ct
		declareMethodAsCompareOperator: #>=;
		declareMethodAsCompareOperator: #<=;
		declareMethodAsCompareOperator: #>;
		declareMethodAsCompareOperator: #<";
		defineMethodAsCompareOperator: #="

]

{ #category : #initialization }
SWPool >> initialize_Number: ct [
	ct
		declareMethodAsBinaryOperator: #+;
		declareMethodAsBinaryOperator: #-;
		declareMethodAsBinaryOperator: #*;
		declareMethodAsBinaryOperator: #/
		
]

{ #category : #initialization }
SWPool >> initialize_Object: ct [
	ct
		declareMethodAsCompareOperator: #=;
		declareMethod: #error: asReturn: nil;
		declareMethod: #printString asReturn: String;
		declareMethod: #size asReturn: Integer;
		declareMethod: #asString asReturn: String;
		declareMethodReturnsFirstArgument: #at:put:;
		declareMethod: #at: asReturn: Object;
		declareMethodReturnsReceiver: #putOn:;
		declareMethodReturnsReceiver: #assert:description:
]

{ #category : #initialization }
SWPool >> initialize_OrderedDictionary: ct [
	ct
		declareMethodReturnsReceiver: #initialize:
]

{ #category : #initialization }
SWPool >> initialize_Path: ct [
	ct
		declareMethodReturnsReceiver: #/;
		declareMethod: #basename asReturn: String;
		declareMethodReturnsReceiver: #withName:extension:;
		declareMethod: #pathString asReturn: String
]

{ #category : #initialization }
SWPool >> initialize_PathClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #from:
]

{ #category : #initialization }
SWPool >> initialize_ProtoObject: ct [
	ct
		declareMethodAsCompareOperator: #==;
		declareMethodReturnsReceiversClass: #class;
		declareMethodReturnsFirstArgument: #ifNil:;
		declareMethodReturnsFirstArgument: #ifNotNil:;
		declareMethodReturnsFirstArgument: #ifNil:ifNotNil;
		declareMethodReturnsFirstArgument: #ifNotNil:ifNil:
]

{ #category : #initialization }
SWPool >> initialize_STONClass: ct [
	ct
		declareMethod: #jsonWriter asReturn: STONWriter;
		declareMethod: #fromString: asReturn: Object
]

{ #category : #initialization }
SWPool >> initialize_SWStdClass: ct [
	ct
		setBreakpointOn: #haltOnDecoding
]

{ #category : #initialization }
SWPool >> initialize_SWTypeClass: ct [
	ct
		declareMethod: #declare:as: asReturn: Association
]

{ #category : #initialization }
SWPool >> initialize_Semaphore: ct [
	ct
		declareMethodReturnsReceiver: #wait;
		declareMethodReturnsReceiver: #signal
]

{ #category : #initialization }
SWPool >> initialize_SequenceableCollection: ct [
	ct
		declareMethodReturnsReceiver: #,;
		declareMethodReturnsReceiver: #collect:;
		declareMethod: #indexOf:startingAt:ifAbsent: asReturn: Integer
]

{ #category : #initialization }
SWPool >> initialize_SequenceableCollectionClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #streamContents:

]

{ #category : #initialization }
SWPool >> initialize_Set: ct [
	ct
		declareMethodReturnsFirstOrSecondArgument: #remove:ifAbsent:;
		declareMethodReturnsFirstArgument: #add:;
		declareMethod: #includes: asReturn: Boolean
]

{ #category : #initialization }
SWPool >> initialize_SmallDictionary: ct [
	ct
		declareMethodReturnsSecondArgument: #at:put:;
		declareMethodReturnsSecondArgument: #at:ifAbsent:;
		declareMethod: #includesKey: asReturn: Boolean
]

{ #category : #initialization }
SWPool >> initialize_String: ct [
	ct
		declareMethodReturnsReceiver: #trimLeft:right:;
		declareMethodReturnsReceiver: #asLowercase;
		declareMethod: #asZnUrl asReturn: ZnUrl;
		declareMethod: #beginsWith: asReturn: Boolean;
		declareMethod: #endsWith: asReturn: Boolean;
		declareMethodReturnsReceiver: #printOn:
]

{ #category : #initialization }
SWPool >> initialize_StringClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #crlf;
		declareMethodReturnsReceiversInstance: #with:
]

{ #category : #initialization }
SWPool >> initialize_TestAsserter: ct [
	ct
		declareMethodReturnsReceiver: #assert:description:
]

{ #category : #initialization }
SWPool >> initialize_TestCaseClass: ct [
	ct
		declareMethod: #allTestSelectors asReturn: OrderedCollection
]

{ #category : #initialization }
SWPool >> initialize_ThreadSafeTranscript: ct [
	ct
		declareMethodReturnsFirstArgument: #nextPutAll:;
		declareMethodReturnsFirstArgument: #nextPut:;
		declareMethodReturnsReceiver: #endEntry;
		declareMethodReturnsFirstArgument: #critical:
]

{ #category : #private }
SWPool >> initializerFor: target [
	^ (String streamContents: [ :s |
		s
			<< 'initialize_';
			<< target instanceSide name;
			<< (target isClassSide ifTrue: [ 'Class' ] ifFalse: [ '' ]);
			<< ':'
	]) asSymbol.

]

{ #category : #accessing }
SWPool >> logger [
	^ self owner logger
]

{ #category : #private }
SWPool >> newClassTranspiler: target [
	|ct|
	ct := self classTranspilerClass new
		pool: self;
		targetClass: target;
		yourself.
	self payload at: target put: ct.
	self initialize: ct asOf: target.
	target isInstanceSide ifTrue: [ self addInitializerIn: target ].
	^ ct
]

{ #category : #api }
SWPool >> newSenderOf: aSelector super: supered receiver: receiver with: args [
	|method|
self error; flag: #toRemove.
	method := self class search: aSelector
		in: (supered ifTrue: [ receiver value superclass ] ifFalse: [ receiver value ]).
	^ method ifNil: [ 
		self newUndefinedSenderOf: aSelector receiver: receiver with: args
	] ifNotNil: [
		(self getClassTranspiler: method methodClass)
			getSenderOf: method receiver: receiver with: args
	]
]

{ #category : #private }
SWPool >> newUndefinedSenderOf: aSelector receiver: receiver with: args [
	self error; flag: #toRemove.
	self logger log: [ 'An unknown method detected: ', aSelector ].
	(self owner haltList includes: #unresolvedSelector)  ifTrue: [ self halt ].
	^ self senderTranspilerClass new
		selector: aSelector;
		receiver: receiver;
		arguments: args;
		specifyReturnTypeAs: UndefinedObject;
		yourself

]

{ #category : #accessing }
SWPool >> owner [

	^ owner
]

{ #category : #accessing }
SWPool >> owner: anObject [

	owner := anObject
]

{ #category : #accessing }
SWPool >> payload [

	^ payload ifNil: [ payload := Dictionary new ]
]

{ #category : #accessing }
SWPool >> payload: anObject [

	payload := anObject
]

{ #category : #printing }
SWPool >> printOn: aStream [
	self putOn: aStream.
]

{ #category : #streaming }
SWPool >> putOn: aStream [
	aStream << $#; << (self hash % 16rFFFF) printStringHex
]
