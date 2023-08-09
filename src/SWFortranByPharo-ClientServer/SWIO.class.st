"
Stream layout.

                  ========== Data flow ===========>

 +----------+        +--------- SWIO ----------+          +------+
 | previous |  = readStream =>          = writeStream =>  | next |
 |   pipe   |        | (in)               (out)|          | pipe |
 +----------+        +-------------------------+          +------+


"
Class {
	#name : #SWIO,
	#superclass : #Stream,
	#instVars : [
		'in',
		'out',
		'err',
		'args'
	],
	#category : #'SWFortranByPharo-ClientServer-Shell'
}

{ #category : #'instance creation' }
SWIO class >> new [
	^ self basicNew
		initialize;
		yourself
]

{ #category : #comparing }
SWIO >> < inputStream [

	self in: inputStream
]

{ #category : #comparing }
SWIO >> > outputStream [

	self out: outputStream
]

{ #category : #'bit manipulation' }
SWIO >> >> aBlock [

	^ self in >> aBlock
]

{ #category : #accessing }
SWIO >> args [

	^ args ifNil: [ args := OrderedCollection new ]
]

{ #category : #accessing }
SWIO >> args: anObject [

	args := anObject
]

{ #category : #testing }
SWIO >> atEnd [
	"Answer whether the receiver can access any more objects."

	^ self in atEnd
]

{ #category : #'open/close' }
SWIO >> close [

	self in close.
	self out close.
	self err close.


]

{ #category : #testing }
SWIO >> closed [

	^ self out closed
]

{ #category : #accessing }
SWIO >> contents [
	"Answer all of the contents of the receiver."

	^ self in contents
]

{ #category : #accessing }
SWIO >> err [

	^ err ifNil: [ err := SWWaitableStream newOnPipe ]
]

{ #category : #accessing }
SWIO >> err: aStream [

	err := aStream
]

{ #category : #accessing }
SWIO >> in [
	^ in ifNil: [ in := SWWaitableStream newOnPipe ]
]

{ #category : #accessing }
SWIO >> in: aStream [

	in := aStream
]

{ #category : #running }
SWIO >> ln [
	(self out)
		nextPutAll: SWOS default lineSep;
		flush

]

{ #category : #accessing }
SWIO >> next [
	"Answer the next object accessible by the receiver."
	^ self in next
]

{ #category : #accessing }
SWIO >> nextPut: anObject [
	"Insert the argument, anObject, as the next object accessible by the
	receiver. Answer anObject."
	^ self out nextPut: anObject
]

{ #category : #accessing }
SWIO >> out [

	^ out ifNil: [ out := SWWaitableStream newOnPipe ]
]

{ #category : #accessing }
SWIO >> out: aStream [

	out := aStream
]

{ #category : #accessing }
SWIO >> readStream [
	^ self in

]

{ #category : #writing }
SWIO >> writeStream [

	^ self out
]
