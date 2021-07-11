Class {
	#name : #SWProject,
	#superclass : #Object,
	#instVars : [
		'client',
		'classes',
		'sources',
		'objs',
		'exeName'
	],
	#category : #'SWFortranByPharo-Client-Client'
}

{ #category : #accessing }
SWProject >> classes [

	^ classes
]

{ #category : #accessing }
SWProject >> classes: anObject [

	classes := anObject
]

{ #category : #accessing }
SWProject >> client [

	^ client
]

{ #category : #accessing }
SWProject >> client: anObject [

	client := anObject
]

{ #category : #execution }
SWProject >> compileAll [
	self objs: (self sources collect: [ :aSource ||objname res|
		objname := String streamContents: [ :s |
			s << 'obj/'; << (aSource at: #class) name; << '/'; << (aSource at: #hash); << '.o'
		].
		res := client post: objname with: {
			'action' -> 'compile'.
			'type' -> (aSource at: #type).
			'sources' -> {aSource at: #Location}.
		}.
		self assert: [ res at: #success ].
		(Dictionary newFrom: aSource)
			at: #source put: (aSource at: #Location);
			at: #Location put: (res at: #Location);
			yourself.
	])
]

{ #category : #accessing }
SWProject >> exeName [

	^ exeName ifNil: [
		exeName := String streamContents: [ :s |
			s << 'exe/';
				<< (self classes isNotEmpty ifTrue: [ (self classes at: 1) name ] ifFalse: [ 'a' ]);
				<< '.out'
		]
	]
]

{ #category : #accessing }
SWProject >> exeName: anObject [

	exeName := anObject
]

{ #category : #navigating }
SWProject >> go [
	^ self
		putAll;
		compileAll;
		linkAll;
		run.
]

{ #category : #running }
SWProject >> goDomestic [
	^ String streamContents: [ :s |
		self classes do: [ :aClass ||instance|
			instance := aClass new.
			instance view: s.
			instance program.
		]
	]
]

{ #category : #initialization }
SWProject >> initialize [
	super initialize.

]

{ #category : #execution }
SWProject >> linkAll [
	|res|
	res := self client post: self exeName with: { 
		'action' -> 'link'.
		'type' -> 'f90'.
		'sources' -> (self objs collect: [:each | (each at: #Location) asString ]).
	}.
	self assert: [ res at: #success ].
	self exeName: (res at: #Location).

]

{ #category : #accessing }
SWProject >> objs [

	^ objs
]

{ #category : #accessing }
SWProject >> objs: anObject [

	objs := anObject
]

{ #category : #execution }
SWProject >> putAll [
	self sources: (self classes collect: [ :aClass ||instance contents hash filename res|
		instance := aClass new.
		contents := instance readTranspiledStream contents.
		hash := (SHA256 hashMessage: contents) hex.
		filename := String streamContents: [ :s |
			s << 'src/'; << aClass name; << '/'; << hash; << '.'; << instance type
		].
		res := client put: filename contents: contents.	
		self assert: [ res at: #success ].
		Dictionary new
			at: #Location put: (res at: #Location);
			at: #hash put: hash;
			at: #type put: instance type;
			at: #class put: aClass;
			yourself.
	])
]

{ #category : #execution }
SWProject >> run [
	|res|
	res := self client post: self exeName with: {
		'action' -> 'execute'.
		'arguments' -> {  }
	}.
	(res at: #success) ifFalse: [ Error signal. ].
	^ res
]

{ #category : #accessing }
SWProject >> sources [

	^ sources
]

{ #category : #accessing }
SWProject >> sources: anObject [

	sources := anObject
]
