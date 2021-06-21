"
Build A fortran project.
"
Class {
	#name : #SWFortranBuilder,
	#superclass : #Object,
	#instVars : [
		'compiler',
		'fm'
	],
	#category : #'SWFortranByPharo-Server-Builder'
}

{ #category : #building }
SWFortranBuilder >> buildThenRun: project [
	|res|
	self checkAbsenceOf: project.
	res := self compilingProcess: project.	
	res := self 	linkingProcess: project with: res.
	^ self runningProcess: res.
]

{ #category : #building }
SWFortranBuilder >> checkAbsenceOf: project [
	<debuggerCompleteToSender>
	"check absence"
	project ifNil: [ self error: 'This project is nil.' ].
	project name ifNil: [ self error: 'The project needs its name.' ].
	(project sources isNil or: [ project sources isEmpty ])
		ifTrue: [ self error: 'The project ', project name, ' has no sources.' ].
		
]

{ #category : #accessing }
SWFortranBuilder >> compiler [
	^ compiler ifNil: [
		| compilername |
		compilername := SWShellEnvironment default compilerName.
		compilername = #gfortran ifTrue: [
			^ compiler := SWGFortranCompilerAdapter new
		].
	
		self error: 'No implementation on this machine.'
	]
]

{ #category : #accessing }
SWFortranBuilder >> compiler: anObject [

	compiler := anObject
]

{ #category : #building }
SWFortranBuilder >> compilingProcess: project [
	|res|
	res := SWBuildingResult new isSuccess: true.
	project sources do: [:file |
		|src obj r|
		src := self fm dispatch: file.
		obj := self fm dispatch: ((Path * file) withExtension: 'o') fullName.
		r := self compiler compileFortranFile: src to: obj.
		r isSuccess ifFalse: [ self error: res message].
		res put: (SWBuildingEachResult new
			copyFrom: r;
			source: src;
			output: obj)
	].
	^ res

]

{ #category : #accessing }
SWFortranBuilder >> fm [
	^ fm ifNil: [
		|ext|
		ext := [ :file | (Path * file) extension asLowercase].
		fm := SWFileManager new
			add: 'src' withRuleOf: [ :file | (ext value: file) beginsWith: 'f' ];
			add: 'obj' withRuleOf: [ :file | #('o' 'obj') includes: (ext value: file)];
			add: 'exe' withRuleOf: [ :file | #('' 'out' 'exe') includes:(ext value: file)];
			add: '' withRuleOf: [ :file | true ];
			yourself. 
	]
]

{ #category : #accessing }
SWFortranBuilder >> fm: anObject [

	fm := anObject
]

{ #category : #building }
SWFortranBuilder >> linkingProcess: project with: res [
	|objs exe r|
	objs := OrderedCollection new.
	objs addAll: project libraries.
	objs addAll: (res results collect: #output).

	exe := self fm dispatch: (((Path * project name) withExtension: SWShellEnvironment default exeFileExtension) fullName). 
	r := self compiler linkObjs: objs to: exe.
	r isSuccess ifFalse: [ self error: r message ].
	res put: (SWBuildingEachResult new
		copyFrom: r;
		source: objs;
		output: exe).
	^ res

]

{ #category : #building }
SWFortranBuilder >> runningProcess: res [
	|r|
	r := self compiler runExe: res lastOutput.
	r isSuccess ifFalse: [ self error: r message ].
	res put: (SWBuildingEachResult new
		copyFrom: r;
		source: res lastOutput;
		output: r message).
	^ res
]
