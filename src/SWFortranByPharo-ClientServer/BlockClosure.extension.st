Extension { #name : #BlockClosure }

{ #category : #'*SWFortranByPharo-ClientServer' }
BlockClosure >> | rightBlock [
	^ [ :std |
		|pipe semaphore|
		pipe := std newPipe.
		semaphore := Semaphore new.
		[
			self value: (std sub
				out: pipe writeStream;
				yourself).
			semaphore signal.
		] fork.
		[
			rightBlock value: (std sub
				in: pipe readStream;
				yourself).
			semaphore signal.
		] fork.
		semaphore wait.
		semaphore wait.
	]
]
