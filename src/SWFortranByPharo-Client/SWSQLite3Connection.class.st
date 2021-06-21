"
I fork initialize to replace SQLite3Library to SWSQLite3Library.
"
Class {
	#name : #SWSQLite3Connection,
	#superclass : #SQLite3Connection,
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #initialization }
SWSQLite3Connection class >> initialize [
	SQLite3Library compile: 'macLibraryName
	"macOS 11 Big sur needs this hacking.
	the diff is belows.
	- #(''libsqlite3.dylib'' ''libsqlite3.0.dylib'')
	+ #(''libsqlite3.dylib'' ''libsqlite3.0.dylib'' ''sqlite3/libtclsqlite3.dylib'')
	"
	| pluginDir |
	pluginDir := FileSystem /''usr''/''lib''.
	#(''libsqlite3.dylib'' ''libsqlite3.0.dylib'' ''sqlite3/libtclsqlite3.dylib'')
		detect: [ :each | (pluginDir / each) exists ] 
		ifFound: [ :libName | ^ (pluginDir / libName) fullName  ].

	self error: ''Module not found.'''.
]

{ #category : #convenience }
SWSQLite3Connection class >> on: aFilename do: aBlock [
	|connection|
	connection := self memory.
	^ [
		connection open.
		aBlock value: connection.
		connection execute: 'VACUUM INTO ?;' value: aFilename
	] ensure: [ connection close. ]
]

{ #category : #accessing }
SWSQLite3Connection >> lastInsertRowID [
	"Is this OK? I'm not sure."
	^ library lastInsertRowId: self handle.
]
