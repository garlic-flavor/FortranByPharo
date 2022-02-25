"
I am a pool of SWClassInfo.
"
Class {
	#name : #SWPool,
	#superclass : #SWPoolBase,
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #'as yet unclassified' }
SWPool class >> classDispatcherClass [
	^ SWClass
]

{ #category : #'as yet unclassified' }
SWPool class >> initializersKey [
	^ 'decode_'
]

{ #category : #'as yet unclassified' }
SWPool class >> search: aSelector in: aClass [
	^ self search: aSelector in: aClass ifFound: [ :found | found ] ifNone: [ self error ]
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

{ #category : #accessing }
SWPool >> classTranspilerClass [

	^ self owner class classTranspilerClass
]

{ #category : #accessing }
SWPool >> decoderClass [

	^ self owner class
]

{ #category : #api }
SWPool >> getResult: aSender [
	self error; flag: #toRemove.
	^ (self getClassDispatcher: aSender method methodClass)
		getResult: aSender

]

{ #category : #api }
SWPool >> getSender: aSelector with: operands [
	(self haltList includes: aSelector) ifTrue: [ self halt ].

	^ self class search: aSelector in: operands first value ifFound: [ :foundMethod |
		(self haltList includes: foundMethod) ifTrue: [ self halt ].
		(self getClassDispatcher: foundMethod methodClass)
			getResult: (SWSender new
				method: foundMethod;
				operands: operands;
				yourself)
	] ifNone: [
		self logger log: [ 'An unknown method detected: ', aSelector ].
		(self haltList includes: self owner class unresolvedSelectorKey)  ifTrue: [ self halt ].
		SWSender new
			operands: operands;
			yourself
	]

]

{ #category : #accessing }
SWPool >> haltList [
	^ self owner haltList
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
		declareMethodReturnsReceiversElement: #ensure:;
		declareMethodReturnsReceiversElement: #value:
]

{ #category : #initialization }
SWPool >> initialize_Boolean: ct [
	ct
		declareMethodReturnsFirstArgumentsElement: #ifTrue:;
 		declareMethodReturnsFirstArgumentsElement: #ifFalse:;
		declareMethodReturnsFirstOrSecondArgumentsElement: #ifTrue:ifFalse:;
		declareMethodReturnsFirstOrSecondArgumentsElement: #ifFalse:ifTrue:;
"
		declareMethodReturnsFirstArgument: #and:;
		declareMethodReturnsFirstArgument: #or:
" yourself
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
		declareMethodReturnsSecondArgument: #at:ifAbsent:;
		declareMethodReturnsSecondArgument: #at:ifAbsentPut:;
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
		declareMethod: #error asReturn: nil;
		declareMethod: #error: asReturn: nil;
"
		declareMethod: #printString asReturn: String;
		declareMethod: #size asReturn: Integer;
"
		declareMethod: #asString asReturn: String;
"
		declareMethodReturnsFirstArgument: #at:put:;
		declareMethod: #at: asReturn: Object;
		declareMethodReturnsReceiver: #putOn:;
		declareMethodReturnsReceiver: #assert:description:
" yourself
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
		declareMethodReturnsReceiverOrFirstArgumentsElement: #ifNil:;
		declareMethodReturnsReceiverOrFirstArgumentsElement: #ifNotNil:;
		declareMethodReturnsFirstOrSecondArgumentsElement: #ifNil:ifNotNil:;
		declareMethodReturnsFirstOrSecondArgumentsElement: #ifNotNil:ifNil:
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

{ #category : #accessing }
SWPool >> logger [
	^ self owner logger
]
