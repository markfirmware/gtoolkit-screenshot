# gtoolkit-screenshot

Load the code:

    Metacello new
        repository: 'github://markfirmware/gtoolkit-screenshot:master/src';
        baseline: 'Screenshot';
        load

Then inspect this (control g) in a playground:

    Screenshot test

It will save and load screenshot-1.png that has a png text chunk which is displayed in Items in the Screenshot inspector.

Inspecting this

    Screenshot testFileReference

Will show the captured playground text in an inspector tab
