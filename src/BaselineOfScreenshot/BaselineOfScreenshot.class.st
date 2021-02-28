Class {
	#name : #BaselineOfScreenshot,
	#superclass : #BaselineOf,
	#category : #BaselineOfScreenshot
}

{ #category : #accessing }
BaselineOfScreenshot >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'Screenshot' ]
]

{ #category : #accessing }
BaselineOfScreenshot >> projectClass [
	^ MetacelloCypressBaselineProject
]
