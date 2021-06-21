"
I display the progress of the building and the running.
"
Class {
	#name : #SWProjectView,
	#superclass : #SpPresenter,
	#instVars : [
		'title',
		'label',
		'progress',
		'logbox',
		'abort',
		'log',
		'logcount'
	],
	#category : #'SWFortranByPharo-Client-Project'
}

{ #category : #specs }
SWProjectView class >> defaultSpec [

	^ SpBoxLayout newTopToBottom
		add: #title withConstraints: [ :constraints | constraints height: 20 ];
		add: #label withConstraints: [ :constraints | constraints height: 20 ];
		add: #progress withConstraints: [ :constraints | constraints height: 10 ];
		add: #logbox;
		add: #abort withConstraints: [:constraints | constraints height: 30 ];
		yourself
]

{ #category : #navigating }
SWProjectView class >> go [
	<sampleInstance>
	^ self new openWithSpec; yourself.
]

{ #category : #accessing }
SWProjectView class >> title [
	^ 'ProjectView'
]

{ #category : #accessing }
SWProjectView >> << message [
	log << message << Character cr.
	logcount := logcount + 1.
	logbox
		text: log contents;
		scrollValue: (0@logcount).

]

{ #category : #accessing }
SWProjectView >> contents [
	^ log contents
]

{ #category : #'as yet unclassified' }
SWProjectView >> disableAborting [
	abort disable
]

{ #category : #'as yet unclassified' }
SWProjectView >> enableAborting [
	abort enable
]

{ #category : #initialization }
SWProjectView >> initializePresenters [

	title := self newLabel.

	label := self newLabel.

	progress := self newProgressBar.
	progress fixedAt: 0.

	log := String new writeStream.
	logcount := 0.
	logbox := self newText.
	logbox beNotEditable.
	
	abort := self newButton.
	abort label: 'Abort'.

]

{ #category : #accessing }
SWProjectView >> label: message [
	label label: message.
]

{ #category : #'as yet unclassified' }
SWProjectView >> onAbort: aBlock [
	abort action: aBlock
]

{ #category : #accessing }
SWProjectView >> progress: aNumber [
	progress fixedAt: aNumber.
]

{ #category : #accessing }
SWProjectView >> title: aTitle [
	title label: aTitle.
]
