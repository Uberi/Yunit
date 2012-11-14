Yunit
=====
Super simple testing framework for AutoHotkey.

Yunit is designed to aid in the following tasks:

* Automated code testing.
* Automated benchmarking.
* Basic result reporting and collation.
* Test management.

Installation
------------
Installation is simply a matter of adding the Yunit folder to the library path of your project.

An example directory structure is shown below:

    + SomeProject
    |    + Lib
    |    |    + Yunit
    |    |    |    LICENSE.txt
    |    |    |    README.md
    |    |    |    ...
    |    |    + OtherLibrary
    |    |    |    ...
    |    README.md
    |    SomeProject.ahk

In AutoHotkey v1.1, library locations are checked as follows:

1. Local library: %A_ScriptDir%\Lib\
2. User library: %A_MyDocuments%\Lib\
3. Standard library: %A_AhkPath%\Lib\

Usage
-----
Yunit must be imported to be used:

    