Affine.m
==========

[Mathematica](http://www.wolfram.com/mathematica/) program for computations in representation theory
of affine and finite-dimensional Lie algebras.

Overview
----------

This program is based on the properties of weight system and uses Weyl symmetry. Central problems
are weight multiplicity calculation, branching of representation to representation of subalgebras
and tensor product decomposition. For more detail see `doc/paper.pdf`.

System requirements
----------

Mathematica. Tested with versions 7 and 8 on Linux and Windows.
More details in `doc/paper.pdf`

Installation
----------

`git clone git://github.com/naa/Affine.git`

Usage
----------

Add path to the beginning of your notebook

`AppendTo[$Path,"src/"];`
`<<affine.m;`


Demo
---------

The demonstration notebook `demo.nb` is in the folder `demo`. Notebook `paper.nb` in the same folder
contains the code which was used to produce examples in the paper.

All public functions of the package has online help, which can be invoked this way:

`?functionName`

For more details see files `demo/demo.nb`,`demo/paper.nb` and `doc/paper.pdf`. 


Tests
--------
Unit tests are in file `tests/tests.m`. To run all the tests just read the contents of this file
into your notebook after adding the folder to `$Path` with

`<<tests.m`
