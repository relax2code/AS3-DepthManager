AS3-DepthManager
================

display list depth manager  , this class originally from http://www.libspark.org/browser/as3/DepthManager
with modification in removeChild function 


Example:
========

Adding Child 
================

function addChild( child:DisplayObject ):DisplayObject

function addChildAt( child:DisplayObject, depth:int ):DisplayObject


Manage Depth
=============

function  setDepth( child:DisplayObject, depth:int ):void

function getDepth( child:DisplayObject ):int 

function swapChildren( child1:DisplayObject, child2:DisplayObject ):void


Removing Child
==============

function removeChild( child:DisplayObject ):DisplayObject

function removeChildAt( depth:int ):DisplayObject

