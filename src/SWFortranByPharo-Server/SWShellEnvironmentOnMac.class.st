"
The information about this development environment of Mac.
"
Class {
	#name : #SWShellEnvironmentOnMac,
	#superclass : #SWShellEnvironment,
	#category : #'SWFortranByPharo-Server-Shell'
}

{ #category : #accessing }
SWShellEnvironmentOnMac >> compilerName [ 
	^ #gfortran
]

{ #category : #accessing }
SWShellEnvironmentOnMac >> exeFileExtension [ 
	^ #out
]

{ #category : #accessing }
SWShellEnvironmentOnMac >> objFileExtension [ 
	^ #o
]
