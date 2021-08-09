"
I display the progress of the building and the running.
"
Class {
	#name : #SWClientView,
	#superclass : #SpPresenter,
	#instVars : [
		'fileTree',
		'label',
		'progress',
		'logbox',
		'log',
		'logcount',
		'actionBar',
		'update',
		'abort',
		'socket',
		'server',
		'isNewline'
	],
	#classVars : [
		'default'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #navigating }
SWClientView class >> default [
	default ifNil: [default := self new openWithSpec; yourself ].
	default isDisplayed ifFalse: [ default openWithSpec ].
	^ default
	
]

{ #category : #specs }
SWClientView class >> defaultSpec [

	^ SpPanedLayout newTopToBottom
		add: #fileTree;
		add: (SpBoxLayout newTopToBottom
			add: #logbox;
			add: #label withConstraints: [ :constraints | constraints height: 20 ];
			add: #progress withConstraints: [ :constraints | constraints height: 10 ];
			add: #actionBar expand: false fill: false padding: 0;
			yourself);
		yourself
]

{ #category : #initialization }
SWClientView class >> reset [
	<script>
	default ifNotNil: [
		default delete.
		default socket: nil.
		default := nil
	].
	^ self default
]

{ #category : #accessing }
SWClientView class >> title [
	^ 'ProjectView'
]

{ #category : #logging }
SWClientView >> << message [
	isNewline ifTrue: [self logheader. isNewline := false ].
	log << message asString.

]

{ #category : #accessing }
SWClientView >> contents [
	^ log contents
]

{ #category : #logging }
SWClientView >> cr [
	self logfooter.
	isNewline := true.
]

{ #category : #'as yet unclassified' }
SWClientView >> disableAborting [
	abort disable
]

{ #category : #'as yet unclassified' }
SWClientView >> enableAborting [
	abort enable
]

{ #category : #requesting }
SWClientView >> exec: target with: options [
	|res inst|
	self << target; << '('; << options; << ')'; << ' to '; << self server; cr.
	inst := SWServerInstruction new
		execute;
		target: target;
		options: options;
		yourself.
	res := self socket ensureSendMessage: inst toString.
	self
		<< res code; cr;
		<< (res entity at: #stdout ifAbsent: ''); << res message; cr.
	^ res.
]

{ #category : #initialization }
SWClientView >> initialize [
	super initialize.
	isNewline := true.
]

{ #category : #initialization }
SWClientView >> initializePresenters [
	fileTree := self newFileTree.
	log := String new writeStream.
	logcount := 0.
	logbox := self newText.
	logbox beNotEditable.
	
	label := self newLabel.
	progress := self newProgressBar.
	progress fixedAt: 0.

	update := self newUpdateButton.
	abort := self newButton
		label: 'Abort';
		icon: (self iconNamed: #smallCancel);
		yourself.
	actionBar := self newActionBar
		add: update;
		addLast: abort;
		yourself.

]

{ #category : #accessing }
SWClientView >> label: message [
	label label: message.
]

{ #category : #'private - logging' }
SWClientView >> logfooter [
	log << Character cr.
	logcount := logcount + 1.
	logbox
		text: log contents;
		scrollValue: (0@logcount).

]

{ #category : #accessing }
SWClientView >> logger: aBlock [
	self logheader.
	aBlock value: log.
	self logfooter.
]

{ #category : #'private - logging' }
SWClientView >> logheader [
	log << (DateAndTime now prettyPrint); << '> '.

]

{ #category : #initialization }
SWClientView >> newFileTree [
	^ (self newTreeTable)
		addColumn: (SpStringTableColumn new
			title: 'Server side';
			evaluated: [ :each |
				String streamContents: [ :s |
					(each at: #isDirectory ifAbsent: false) ifFalse: [
						s << (each at: #creationTime ifAbsent: ' '); << ' '
					].
					s << (each at: #basename ifAbsent: 'anonymous')
				]
			]
		);
		children: [ :each | each at: #children ifAbsent: {  } ];
		yourself.

]

{ #category : #initialization }
SWClientView >> newUpdateButton [
	^ self newButton
		label: 'Update';
		icon: (self iconNamed: #smallUpdate);
		action: [
			[
				|res|
				self socket sendRequestGet: '/'.
				res := self socket readResponse.
				fileTree roots: (res at: 'entity' ifAbsent: nil).
			] schedule.
		];
		yourself.

]

{ #category : #requesting }
SWClientView >> post: target with: anAssociationArray [
	|res|
	self << anAssociationArray; << ' '; << target; << ' to '; << self server; cr.
	self socket sendRequestPost: target with: anAssociationArray.
	res := self socket readResponse.
	self << (res at: #reason ifAbsent: ''); cr.
	self << (res at: #stdout ifAbsent: ''); << (res at: #message ifAbsent: ''); cr.
	
	^ res.
]

{ #category : #accessing }
SWClientView >> progress: aNumber [
	progress fixedAt: aNumber.
]

{ #category : #requesting }
SWClientView >> put: target contents: contents [
	|req status|
	self << 'put: '; << target; << '('; << contents size asString; << ') to '; << self server; cr.
	req := SWServerInstruction new
		head;
		target: target;
		yourself.
	status := self socket ensureSendMessage: req toString.
	(status entity at: #exists ifAbsent: false) ifTrue: [
		self << target; << ' already existed.'; cr.
		^ status
	].

	req put; length: contents size.
	status := self socket
		ensureSendMessage: req toString;
		ensureSendMessage: contents.
	^ status

]

{ #category : #accessing }
SWClientView >> server [

	^ server ifNil: [ server := 'ws://localhost:50000' ]
]

{ #category : #accessing }
SWClientView >> server: anObject [

	server := anObject
]

{ #category : #accessing }
SWClientView >> socket [
	(socket isNil or: [ socket isConnected not ]) ifTrue: [
		socket := ZnWebSocket to: self server
	].
	^ socket


]

{ #category : #accessing }
SWClientView >> socket: anObject [

	socket := anObject
]
