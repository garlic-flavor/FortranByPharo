"
I am a pool of SWClassInfo.
"
Class {
	#name : #SWGlobal,
	#superclass : #SWPoolBase,
	#category : #'SWFortranByPharo-Analyzer-Analyzer'
}

{ #category : #constants }
SWGlobal class >> classInfoClass [
	^ SWClassInfo
]

{ #category : #constants }
SWGlobal class >> globalAccessKey [
	^ #globalAccess
]

{ #category : #constants }
SWGlobal class >> initializersHeader [
	^ 'decode_'
]

{ #category : #constants }
SWGlobal class >> pragmaKey [
	^ #pragma
]

{ #category : #constants }
SWGlobal class >> unresolvedSelectorKey [
	^ #unresolvedSelector

]

{ #category : #accessing }
SWGlobal >> atGlobalAccess [
	(self haltList includes: self class globalAccessKey) ifTrue: [ self halt ].

]

{ #category : #accessing }
SWGlobal >> atPragma [
	(self haltList includes: self class pragmaKey) ifTrue: [ self halt ]
]

{ #category : #api }
SWGlobal >> decode: aSenderInfo [

	^ (self getClassInfo: aSenderInfo method methodClass)
		decode: aSenderInfo

]

{ #category : #api }
SWGlobal >> decode: aSelector with: operands [
	(self haltList includes: aSelector) ifTrue: [ self halt ].
	^ self class search: aSelector in: operands first value ifFound: [ :foundMethod |
		(self haltList includes: foundMethod) ifTrue: [ self halt ].
		self decode: (SWSenderInfo new
			method: foundMethod;
			operands: operands;
			yourself)
	] ifNone: [
		(self haltList includes: aSelector) ifTrue: [ self halt ].
		(self haltList includes: self class unresolvedSelectorKey)  ifTrue: [ self halt ].
		SWMessageInfo new
			operands: operands;
			yourself
	]

]

{ #category : #initialization }
SWGlobal >> decode_AbstractBinaryFileStream: ct [
	ct
		declareMethodReturnsReceiver: #position:
]

{ #category : #initialization }
SWGlobal >> decode_AbstractFileReference: ct [
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
SWGlobal >> decode_Behavior: ct [
	ct
		declareMethodReturnsReceiversInstance: #basicNew:;
		declareMethodReturnsReceiversInstance: #basicNew

]

{ #category : #initialization }
SWGlobal >> decode_BinaryFileStream: ct [
	ct
		declareMethodReturnsReceiver: #truncate:
]

{ #category : #initialization }
SWGlobal >> decode_BlockClosure: ct [
	ct
		declareMethodReturnsReceiversElement: #on:do:;
		declareMethodReturnsReceiversElement: #ensure:;
		declareMethodReturnsReceiversElement: #value:
]

{ #category : #initialization }
SWGlobal >> decode_Boolean: ct [
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
SWGlobal >> decode_Character: ct [
	ct
		declareMethod: #asInteger asReturn: Integer
]

{ #category : #initialization }
SWGlobal >> decode_CharacterClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #value:
]

{ #category : #initialization }
SWGlobal >> decode_Collection: ct [
	ct
		declareMethodReturnsSecondArgument: #detect:ifNone:;
		declareMethodReturnsFirstArgument: #inject:into:;
		declareMethod: #anySatisfy: asReturn: Boolean
]

{ #category : #initialization }
SWGlobal >> decode_DateAndTimeClass: ct [
	ct
		declareMethodReturnsReceiversClass: #now
]

{ #category : #initialization }
SWGlobal >> decode_Dictionary: ct [
	ct
		declareMethodReturnsSecondArgument: #at:put:;
		declareMethodReturnsSecondArgument: #at:ifAbsent:;
		declareMethodReturnsSecondArgument: #at:ifAbsentPut:;
		declareMethod: #includesKey: asReturn: Boolean;
		declareMethodReturnsReceiver: #stonOn:
]

{ #category : #initialization }
SWGlobal >> decode_DictionaryClass: ct [
	ct
		declareMethodReturnsReceiversClass: #fromSton:
]

{ #category : #initialization }
SWGlobal >> decode_Exception: ct [
	ct
		declareMethodReturnsReceiver: #signal
]

{ #category : #initialization }
SWGlobal >> decode_Magnitude: ct [
	ct
		declareMethodAsCompareOperator: #>=;
		declareMethodAsCompareOperator: #<=;
		declareMethodAsCompareOperator: #>;
		declareMethodAsCompareOperator: #<";
		defineMethodAsCompareOperator: #="

]

{ #category : #initialization }
SWGlobal >> decode_Number: ct [
	ct
		declareMethodAsBinaryOperator: #+;
		declareMethodAsBinaryOperator: #-;
		declareMethodAsBinaryOperator: #*;
		declareMethodAsBinaryOperator: #/

]

{ #category : #initialization }
SWGlobal >> decode_Object: ct [
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
SWGlobal >> decode_OrderedDictionary: ct [
	ct
		declareMethodReturnsReceiver: #initialize:
]

{ #category : #initialization }
SWGlobal >> decode_Path: ct [
	ct
		declareMethodReturnsReceiver: #/;
		declareMethod: #basename asReturn: String;
		declareMethodReturnsReceiver: #withName:extension:;
		declareMethod: #pathString asReturn: String
]

{ #category : #initialization }
SWGlobal >> decode_PathClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #from:
]

{ #category : #initialization }
SWGlobal >> decode_ProtoObject: ct [
	ct
		declareMethodAsCompareOperator: #==;
		declareMethodReturnsReceiversClass: #class;
		declareMethodReturnsReceiverOrFirstArgumentsElement: #ifNil:;
		declareMethodReturnsReceiverOrFirstArgumentsElement: #ifNotNil:;
		declareMethodReturnsFirstOrSecondArgumentsElement: #ifNil:ifNotNil:;
		declareMethodReturnsFirstOrSecondArgumentsElement: #ifNotNil:ifNil:
]

{ #category : #initialization }
SWGlobal >> decode_STONClass: ct [
	ct
		declareMethod: #jsonWriter asReturn: STONWriter;
		declareMethod: #fromString: asReturn: Object
]

{ #category : #initialization }
SWGlobal >> decode_Semaphore: ct [
	ct
		declareMethodReturnsReceiver: #wait;
		declareMethodReturnsReceiver: #signal
]

{ #category : #initialization }
SWGlobal >> decode_SequenceableCollection: ct [
	ct
		declareMethodReturnsReceiver: #,;
		declareMethodReturnsReceiver: #collect:;
		declareMethod: #indexOf:startingAt:ifAbsent: asReturn: Integer
]

{ #category : #initialization }
SWGlobal >> decode_SequenceableCollectionClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #streamContents:

]

{ #category : #initialization }
SWGlobal >> decode_Set: ct [
	ct
		declareMethodReturnsFirstOrSecondArgument: #remove:ifAbsent:;
		declareMethodReturnsFirstArgument: #add:;
		declareMethod: #includes: asReturn: Boolean
]

{ #category : #initialization }
SWGlobal >> decode_SmallDictionary: ct [
	ct
		declareMethodReturnsSecondArgument: #at:put:;
		declareMethodReturnsSecondArgument: #at:ifAbsent:;
		declareMethod: #includesKey: asReturn: Boolean
]

{ #category : #initialization }
SWGlobal >> decode_String: ct [
	ct
		declareMethodReturnsReceiver: #trimLeft:right:;
		declareMethodReturnsReceiver: #asLowercase;
		declareMethod: #asZnUrl asReturn: ZnUrl;
		declareMethod: #beginsWith: asReturn: Boolean;
		declareMethod: #endsWith: asReturn: Boolean;
		declareMethodReturnsReceiver: #printOn:
]

{ #category : #initialization }
SWGlobal >> decode_StringClass: ct [
	ct
		declareMethodReturnsReceiversInstance: #crlf;
		declareMethodReturnsReceiversInstance: #with:
]

{ #category : #initialization }
SWGlobal >> decode_TestAsserter: ct [
	ct
		declareMethodReturnsReceiver: #assert:description:
]

{ #category : #initialization }
SWGlobal >> decode_TestCaseClass: ct [
	ct
		declareMethod: #allTestSelectors asReturn: OrderedCollection
]

{ #category : #initialization }
SWGlobal >> decode_ThreadSafeTranscript: ct [
	ct
		declareMethodReturnsFirstArgument: #nextPutAll:;
		declareMethodReturnsFirstArgument: #nextPut:;
		declareMethodReturnsReceiver: #endEntry;
		declareMethodReturnsFirstArgument: #critical:
]

{ #category : #modifying }
SWGlobal >> haltAtGlobalAccess [
	self haltAtGlobalAccess: true
]

{ #category : #modifying }
SWGlobal >> haltAtGlobalAccess: aBoolean [
	self haltAt: self class globalAccessKey switch: aBoolean
]

{ #category : #modifying }
SWGlobal >> haltAtPragma [
	self haltAtPragma: true
]

{ #category : #modifying }
SWGlobal >> haltAtPragma: aBoolean [
	self haltAt: self class pragmaKey switch: aBoolean
]

{ #category : #modifying }
SWGlobal >> haltAtUnresolvedSelector [
	self haltAtUnresolvedSelector: true
]

{ #category : #modifying }
SWGlobal >> haltAtUnresolvedSelector: aBoolean [
	self haltAt: self class unresolvedSelectorKey switch: aBoolean

]

{ #category : #api }
SWGlobal >> remove: aSenderInfo [

	^ (self getClassInfo: aSenderInfo method methodClass)
		remove: aSenderInfo

]
