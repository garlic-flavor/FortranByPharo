Extension { #name : #ZnWebSocket }

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> parseRequest: received [
	|request dict|
	request := ZnRequest readFrom: received readStream.
	dict := Dictionary new
		at: #method put: request method;
		at: #target put: request uri;
		at: #type put: request contentType;
		at: #original put: request;
		yourself.
	request headersDo: [ :key :value | dict at: key put: value ].
	request contentType = ZnMimeType applicationJson ifTrue: [
		(STON reader on: request entity contents readStream; next) associationsDo: [ :assoc |
			dict at: assoc key put: assoc value
		]
	] ifFalse: [
		dict at: #entity put: (request entity ifNil: [ nil ] ifNotNil: [ request entity contents ])
	].
	^ dict
]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> readResponse [
	|received response dict|
	received := self readMessage.
	response := ZnResponse readFrom: received readStream.
	dict := Dictionary new
		at: #success put: (response code < 400);
		at: #code put: response code;
		at: #reason put: response statusLine reason;
		at: #type put: response contentType;
		at: #original put: response;
		at: #message put: '';
		yourself.
	response headersDo: [ :key :value | dict at: key put: value ].
	response contentType = ZnMimeType applicationJson ifTrue: [
		(STON reader on: response entity contents readStream; next) associationsDo: [ :assoc |
			dict at: assoc key put: assoc value
		]
	] ifFalse: [
		dict at: #entity put: (response entity ifNil: [ nil ] ifNotNil: [ response entity contents ])
	].
	^ dict
]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> readResponseHaltOnFailure [
	"I'm for debugging purpose."
	^ self readResponseOnFailureDo: [ :res | self halt. ]

]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> readResponseOnFailureDo: aBlock [
	|res|
	res := self readResponse.
	^ (res at: #code) < 400 ifTrue: [ res ]
		ifFalse: [ aBlock value: res ]

]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> sendRequestGet: target [
	^ self sendBytes: (ZnRequest get: target) toByteArray
]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> sendRequestHead: target [
	^ self sendBytes: (ZnRequest head: target) toByteArray
]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> sendRequestPost: target with: anAssociationArray [
	^ self sendBytes: ((ZnRequest post: target) entity:
		(ZnEntity json: (String streamContents: [:s |
			STON writer on: s; nextPut: (STON mapClass newFrom: anAssociationArray)
	]))) toByteArray
]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> sendRequestPut: target with: anAssociationArray entity: entity [
	|request|
	request := ZnRequest put: target.
	anAssociationArray do: [ :assoc| request headers at: assoc key put: assoc value ].
	request entity: (entity isString ifTrue: [ ZnEntity text: entity ] ifFalse: [ ZnEntity bytes: entity ]).
	^ self sendBytes: request toByteArray

]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> sendResponseBadRequest: request [
	^ self sendBytes: (ZnResponse badRequest: request) toByteArray

]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> sendResponseCreated: target with: anAssociationArray [
	^ self sendBytes: (ZnResponse created: target entity:
		(ZnEntity json: (String streamContents: [:s |
			STON writer on: s; nextPut: (STON mapClass newFrom: anAssociationArray)
	]))) toByteArray

]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> sendResponseInternalServerError: anAssociationArray [
	^ self sendBytes: (ZnResponse serverErrorWithEntity:
		(ZnEntity json: (String streamContents: [:s |
			STON writer on: s; nextPut: (STON mapClass newFrom: anAssociationArray)
	]))) toByteArray

]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> sendResponseNotImplemented: anAssociationArray [
	^ self sendBytes: ((ZnResponse statusLine: ZnStatusLine notImplemented)
		entity: (ZnEntity json: (String streamContents: [:s |
			STON writer on: s; nextPut: (STON mapClass newFrom: anAssociationArray)
	]))) toByteArray

]

{ #category : #'*SWFortranByPharo-Base' }
ZnWebSocket >> sendResponseOk: entity [
	entity class = ByteArray ifTrue: [
		^ self sendBytes: (ZnResponse ok: (ZnEntity bytes: entity)) toByteArray
	].
	entity isArray ifTrue: [
		^ self sendBytes: (ZnResponse ok:
			(ZnEntity json: (String streamContents: [:s|
				STON writer on: s; nextPut: (STON mapClass newFrom: entity)
		]))) toByteArray.
	].

	^ self sendBytes: (ZnResponse ok: (ZnEntity text: entity asString)) toByteArray
]
