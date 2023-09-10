Class {
	#name : #SWFCallerBase,
	#superclass : #Object,
	#instVars : [
		'referenceMode',
		'id',
		'script',
		'baseDir',
		'transpiler',
		'sourceTarget',
		'buildTarget',
		'readyToCall'
	],
	#category : #'SWFortranByPharo-FFCaller'
}

{ #category : #accessing }
SWFCallerBase class >> localDirectory [
	^ self osProperty localDirectory
]

{ #category : #accessing }
SWFCallerBase class >> osProperty [
	^ SWOS default
]

{ #category : #'as yet unclassified' }
SWFCallerBase class >> transpilerClass [
	^ self subclassResponsibility 
]

{ #category : #'private - accessing' }
SWFCallerBase >> baseDir [

	^ baseDir ifNil: [
		baseDir := self class localDirectory / 'mods' / (self name, '-', self id asString)
	]
]

{ #category : #'private - accessing' }
SWFCallerBase >> baseDir: anObject [

	baseDir := anObject
]

{ #category : #'private - building' }
SWFCallerBase >> build [
	self buildTarget exists ifFalse: [
		self sourceTarget exists ifFalse: [ self buildSourceTarget ].
		self buildFromSource
	].
	self readyToCall: true
]

{ #category : #'private - building' }
SWFCallerBase >> buildFromSource [
	^ self subclassResponsibility
]

{ #category : #'private - building' }
SWFCallerBase >> buildSourceTarget [
	^ self subclassResponsibility 
]

{ #category : #'private - accessing' }
SWFCallerBase >> buildTarget [

	^ buildTarget ifNil: [ buildTarget := self baseDir / self buildTargetName ]
]

{ #category : #'private - accessing' }
SWFCallerBase >> buildTarget: anObject [

	buildTarget := anObject
]

{ #category : #'private - accessing' }
SWFCallerBase >> buildTargetExt [
	" '.out' for an Executable. '.dylib' for a Library."
	^ self subclassResponsibility 
]

{ #category : #'private - accessing' }
SWFCallerBase >> buildTargetName [
	^ self name, self buildTargetExt

]

{ #category : #'as yet unclassified' }
SWFCallerBase >> call [
	^ self call: {  }
]

{ #category : #api }
SWFCallerBase >> call: arg1 [
	^ self referenceMode ifTrue: [
		self script value: arg1
	] ifFalse: [
		(self readyToCall) ifFalse: [ self build ].
		self callBuildedWith: arg1
	]

]

{ #category : #'private - running' }
SWFCallerBase >> callBuildedWith: arg1 [
	^ self subclassResponsibility 
]

{ #category : #'private - accessing' }
SWFCallerBase >> id [

	^ id ifNil: [ id := UUID new ]
]

{ #category : #'private - accessing' }
SWFCallerBase >> id: anObject [

	id := anObject
]

{ #category : #accessing }
SWFCallerBase >> name [

	^ self transpiler name
]

{ #category : #accessing }
SWFCallerBase >> name: anObject [

	self transpiler name: anObject
]

{ #category : #'private - accessing' }
SWFCallerBase >> readyToCall [

	^ readyToCall ifNil: [ readyToCall := false ]
]

{ #category : #'private - accessing' }
SWFCallerBase >> readyToCall: anObject [

	readyToCall := anObject
]

{ #category : #accessing }
SWFCallerBase >> referenceMode [

	^ referenceMode ifNil: [ referenceMode := false ]
]

{ #category : #accessing }
SWFCallerBase >> referenceMode: anObject [

	referenceMode := anObject
]

{ #category : #accessing }
SWFCallerBase >> script [

	^ script ifNil: [ script := [ ] ]
]

{ #category : #accessing }
SWFCallerBase >> script: anObject [

	script := anObject
]

{ #category : #'private - accessing' }
SWFCallerBase >> sourceExt [
	^ '.f03'
]

{ #category : #'private - accessing' }
SWFCallerBase >> sourceTarget [

	^ sourceTarget ifNil: [ sourceTarget := self baseDir / self sourceTargetName ]
]

{ #category : #'private - accessing' }
SWFCallerBase >> sourceTarget: anObject [

	sourceTarget := anObject
]

{ #category : #'private - accessing' }
SWFCallerBase >> sourceTargetName [
	^ self name, self sourceExt

]

{ #category : #accessing }
SWFCallerBase >> transpiler [
	^ self subclassResponsibility 


]

{ #category : #accessing }
SWFCallerBase >> transpiler: anObject [

	transpiler := anObject
]
