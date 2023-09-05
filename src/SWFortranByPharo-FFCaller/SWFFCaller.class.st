Class {
	#name : #SWFFCaller,
	#superclass : #SWFCaller,
	#category : #'SWFortranByPharo-FFCaller'
}

{ #category : #'private - building' }
SWFFCaller >> buildFromSource [
	^ SWOS default fortranCompilerAdapterClass
		buildDynamiclib: self buildTarget
		from: { self sourceTarget } with: {  }
]

{ #category : #'private - building' }
SWFFCaller >> buildSourceTarget [

	self sourceTarget
		ensureCreateFile;
		writeStreamDo: [ :s |
			self transpiler stream payload: s.
			self transpiler transpileAsBindCFunc.
		].

]

{ #category : #'private - accessing' }
SWFFCaller >> buildTargetExt [
	^ '.dylib'
]

{ #category : #'private - running' }
SWFFCaller >> callBuildedWith: arg1 [
	^ self ffiCall: self scriptSpec
]

{ #category : #'library path' }
SWFFCaller >> ffiLibraryName [
	^ self buildTarget fullName
]

{ #category : #'private - accessing' }
SWFFCaller >> scriptSpec [
	|arguments args ret result|
	arguments := self transpiler mainTranspiler expression arguments.
	args := OrderedCollection new.
	arguments withIndexDo: [ :one :i|
		args add: (SWMangleOfC transpiledTypeNameOf: one type value) asSymbol;
			add: ('arg', i asString) asSymbol.
		(i < arguments size) ifTrue: [ args add: #, ]
	].
	ret := self transpiler mainTranspiler expression result elementType.
	result := OrderedCollection new
		add: (SWMangleOfC transpiledTypeNameOf: ret value) asSymbol;
		add: (self name, '_c') asSymbol;
		add: args asArray;
		yourself.
	^ result asArray

]
