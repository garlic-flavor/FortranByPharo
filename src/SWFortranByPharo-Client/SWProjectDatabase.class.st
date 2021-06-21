"
This handles SQLite and store the project information.
"
Class {
	#name : #SWProjectDatabase,
	#superclass : #Object,
	#category : #'SWFortranByPharo-Client-Project'
}

{ #category : #adding }
SWProjectDatabase class >> addProject: aProject on: connection [
	connection execute: 'INSERT INTO project(name, description) VALUES(?, ?);'
		value: aProject name value: aProject description.
	^ connection lastInsertRowID

]

{ #category : #adding }
SWProjectDatabase class >> addSource: aCode toProject: projectId on: connection [
	connection execute: 'INSERT INTO source(projectId, filename, type, code, description) VALUES(?, ?, ?, ?, ?);'
		with: {projectId. aCode filename. aCode type. aCode code. aCode description}.
]

{ #category : #'as yet unclassified' }
SWProjectDatabase class >> createBuildingRequestTableOn: connection [
	connection execute: 'CREATE TABLE request(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		projectId INTEGER NOT NULL,
		request TEXT NOT NULL
	);'.
	
	connection execute: 'CREATE TABLE project(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		name TEXT NOT NULL,
		description TEXT
	);'.
		
	connection execute: 'CREATE TABLE source(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		projectId INTEGER NOT NULL,
		filename TEXT NOT NULL,
		type TEXT NOT NULL,
		code TEXT NOT NULL,
		description TEXT
	);'. 

]

{ #category : #'as yet unclassified' }
SWProjectDatabase class >> generateDatabaseFilePathOf: aProject [
	|dirPath dbname|
	dirPath := FileLocator imageDirectory / 'requestdb'.
	dirPath ensureCreateDirectory.
	dbname := String new writeStream << aProject name << '-' << (UUID new asString) << '.db'; contents.
	^ dirPath / dbname
]

{ #category : #private }
SWProjectDatabase class >> historyDBPath [
	^ FileLocator imageDirectory / 'history.db'
]

{ #category : #writing }
SWProjectDatabase class >> writeHistory: aBlock [
	|connection firstRun|
	firstRun := self historyDBPath exists not.
	connection := SQLite3Connection on: self historyDBPath.
	^ [
		connection open.
		firstRun ifTrue: [
			connection execute: 'CREATE TABLE source(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				time TEXT NOT NULL,
				type TEXT NOT NULL,
				class TEXT NOT NULL,
				description TEXT,
				code TEXT NOT NULL,
				buildHash TEXT,
				status TEXT
			);'.
			connection execute: 'CREATE TABLE project(
				id INTEGER PRIMARY KEY AUTOINCREMENT,
				time TEXT NOT NULL,
				name TEXT NOT NULL,
				program TEXT NOT NULL,
				modules TEXT
			);'.
		].
		aBlock value: connection.
	] ensure: [ connection close. ]
]
