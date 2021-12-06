Class {
	#name : #SWClient,
	#superclass : #Object,
	#instVars : [
		'host',
		'port'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #requesting }
SWClient >> exec: arg1 with: arg2 [

	| tmp1 tmp2 tmp3 tmp5 |
	tmp5 := ZnUrl new.
	tmp5
		scheme: 'ws';
		host: self host;
		port: self port;
		addPathSegment: 'execute';
		queryAt: #target put: arg1.
	tmp1 := tmp5 yourself.
	arg2 do: [ :arg3 | tmp1 queryAt: #args add: arg3 ].
	tmp2 := ZnWebSocket to: tmp1.
	tmp3 := SWServerStatus readFrom: tmp2.
	tmp3 isOk ifFalse: [ 
		tmp2 close.
		tmp3 inspect.
		self error: 'The execution failed.' ].
	^ tmp3
]

{ #category : #public }
SWClient >> get: arg1 [

	| tmp2 |
	tmp2 := ZnClient new.
	tmp2
		http;
		host: self host;
		port: self port;
		addPathSegment: 'manage';
		enforceHttpSuccess: true;
		queryAt: #target put: arg1;
		get.
	^ tmp2 entity contents
]

{ #category : #requesting }
SWClient >> head: arg1 [

	| tmp1 tmp3 |
	tmp3 := ZnClient new.
	tmp3
		http;
		host: self host;
		port: self port;
		addPathSegment: 'manage';
		queryAt: #target put: arg1;
		head.
	tmp1 := tmp3 response.
	^ tmp1 isError ifFalse: [ 
		  tmp1 headers at: #'Last-Modified' ifAbsent: [ '' ] ]
]

{ #category : #accessing }
SWClient >> host [

	^ host ifNil: [ host := 'localhost' ] ifNotNil: [ host ]
]

{ #category : #accessing }
SWClient >> host: arg1 [

	host := arg1
]

{ #category : #accessing }
SWClient >> nextPut: arg1 [

	(self head: arg1 filename) ifNil: [ 
		self put: arg1 filename contents: arg1 contents ]
]

{ #category : #accessing }
SWClient >> port [

	^ port ifNil: [ port := 50000 ] ifNotNil: [ port ]
]

{ #category : #accessing }
SWClient >> port: arg1 [

	port := arg1
]

{ #category : #requesting }
SWClient >> put: arg1 contents: arg2 [

	| tmp2 |
	tmp2 := ZnClient new.
	tmp2
		http;
		host: self host;
		port: self port;
		addPathSegment: 'manage';
		queryAt: #target put: arg1;
		contents: arg2;
		enforceHttpSuccess: true;
		put.
	^ tmp2 response headers at: #'Last-Modified'
]
