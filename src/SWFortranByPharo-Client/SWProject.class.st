"
This contains the information to building a project at client side.
"
Class {
	#name : #SWProject,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'source',
		'view'
	],
	#category : #'SWFortranByPharo-Client-Project'
}

{ #category : #running }
SWProject >> build: database [
	|buildresult|
	self flag: #TODO.
	buildresult := SWClientOfProjectBuilder build: database.
	self halt.
]

{ #category : #translating }
SWProject >> createRequestingDatabaseOf: codes [
	|requestdb|
	requestdb := SWProjectDatabase generateDatabaseFilePathOf: self.
	SWSQLite3Connection on: (requestdb fullName) do: [ :connection |
		|projectId|
		SWProjectDatabase createBuildingRequestTableOn: connection.
		projectId := SWProjectDatabase addProject: self on: connection.
		codes do: [ :each |
			SWProjectDatabase addSource: each toProject: projectId on: connection
		].
	].
	^ requestdb
]

{ #category : #accessing }
SWProject >> description [

	^ description
]

{ #category : #accessing }
SWProject >> description: anObject [

	description := anObject
]

{ #category : #running }
SWProject >> execute [
	self flag: #TODO.
	^ 'Hello, world!
'
]

{ #category : #translating }
SWProject >> generate [
	|codes transpiler|
	codes := OrderedCollection new.
	transpiler := SWTranspiler transpile: source.
	
	codes add: (SWTranspiledCode new 
		filename: (self source class asString, '.', source type);
		type: source type;
		description: source description;
		code: transpiler contents).
	
	^ codes
]

{ #category : #running }
SWProject >> go [
	|codes database buildresult|
	self flag: #TODO. "under construction"
	codes := self generate.
	database := self createRequestingDatabaseOf: codes.
	buildresult := self build: database.
	self halt.
	^ self execute.

]

{ #category : #running }
SWProject >> goDomestic [
	source
		view: self view;
		program.
	^ self view
		label: 'done.';
		progress: 1;
		disableAborting;
		contents

]

{ #category : #accessing }
SWProject >> name [

	^ name
]

{ #category : #accessing }
SWProject >> name: anObject [

	name := anObject
]

{ #category : #accessing }
SWProject >> source [

	^ source
]

{ #category : #accessing }
SWProject >> source: anObject [

	source := anObject
]

{ #category : #accessing }
SWProject >> view [

	^ view ifNil: [
		view := SWProjectView new
			title: self name;
			label: 'preparing...';
			openWithSpec;
			yourself
	]
]
