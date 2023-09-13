Class {
	#name : #SWFProgramCaller,
	#superclass : #SWFCaller,
	#instVars : [
		'io'
	],
	#category : #'SWFortranByPharo-FFCaller'
}

{ #category : #'private - building' }
SWFProgramCaller >> buildFromSource [
	^ SWOS default fortranCompilerAdapterClass
		buildExe: self buildTarget from: { self sourceTarget } with: {  }
]

{ #category : #'private - building' }
SWFProgramCaller >> buildSourceTarget [
	self sourceTarget
		ensureCreateFile;
		writeStreamDo: [ :s |
			self transpiler stream payload: s.
			self transpiler transpile
		]
]

{ #category : #'private - accessing' }
SWFProgramCaller >> buildTargetExt [
	^ '.out'
]

{ #category : #api }
SWFProgramCaller >> call: args [
	self referenceMode ifTrue: [
		self io args: args.
		self script value: self io.
		io out flush.
		io out done.
	] ifFalse: [
		(self readyToCall) ifFalse: [ self build ].
		self callBuildedWith: args
	]
]

{ #category : #'private - running' }
SWFProgramCaller >> callBuildedWith: args [
	|subprocess|
	self io args: args.
	subprocess := SWShell execute: self buildTarget fullName redirectTo: self io.

]

{ #category : #'open/close' }
SWFProgramCaller >> close [
	io ifNotNil: [ io close. io := nil ]
]

{ #category : #accessing }
SWFProgramCaller >> io [

	^ io ifNil: [ io := SWIO new ]
]

{ #category : #accessing }
SWFProgramCaller >> io: anObject [

	io := anObject
]

{ #category : #accessing }
SWFProgramCaller >> transpiler [
	^ transpiler ifNil: [
		transpiler := self class transpilerClass new
			main: self script;
			yourself
	]
]
