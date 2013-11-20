package com.voidelement.manager {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	
	public class DepthManager {
		private const DEPTH_RESERVED:int = 1048575;
		private const DEPTH_HIGHEST :int = 2130690045;
		private const DEPTH_LOWEST  :int = -16383;
		
		private var _container:DisplayObjectContainer;
		private var _dict:Dictionary;
		
		
		public function DepthManager( container:DisplayObjectContainer ):void {
			_container = container;
			_dict = new Dictionary( true );
			
			var len:int = _container.numChildren;
			var child:DisplayObject;
			
			for ( var i:int = 0; i < len; ++i ){
				child = _container.getChildAt( i );
				_dict[ i ] = child;
				_dict[ child ] = i;
			} 

		}
		
		
		public function addChild( child:DisplayObject ):DisplayObject {
			var depth:int = _container.numChildren ? _dict[ _container.getChildAt( _container.numChildren - 1 ) ] + 1 : 0;
			
			_dict[ depth ] = child;
			_dict[ child ] = depth;
			
			return _container.addChild( child );
		}
		
		public function addChildAt( child:DisplayObject, depth:int ):DisplayObject {
			var index:int = searchIndex( depth );
			
			if ( index < _container.numChildren ){
				var child0:DisplayObject = _container.getChildAt( index );
				
				if ( _dict[ child0 ] == depth ){
					removeChild( child0 );
				}
			}
			
			_dict[ depth ] = child;
			_dict[ child ] = depth;
			
			return _container.addChildAt( child, index );
		}
		

		public function setDepth( child:DisplayObject, depth:int ):void {
			if ( ( depth < DEPTH_LOWEST ) || ( depth > DEPTH_HIGHEST ) ){
				throw( new Error("Caution: " + depth + " is over limit of depth") );
			}
			if ( _dict[ child ] == depth ){
				return;
			}
			
			var child0:DisplayObject = getInstanceAtDepth( depth );
			
			if ( child0 != null ){
				swapChildren( child, child0 );
			} else {
				var index:int = searchIndex( depth );
				
				delete _dict[ _dict[ child ] ];
				_dict[ child ] = depth;
				_dict[ depth ] = child;
				
				if ( _container.getChildIndex( child ) < index ){
					_container.setChildIndex( child, index - 1 );
				} else {
					_container.setChildIndex( child, index );
				}
			}
		}
		
		public function getDepth( child:DisplayObject ):int {
			return _dict[ child ];
		}
		
		public function swapChildren( child1:DisplayObject, child2:DisplayObject ):void {
			if ( child1 == child2 ){
				return;
			}
			
			var depth:int = _dict[ child1 ];
			_dict[ child1 ] = _dict[ child2 ];
			_dict[ child2 ] = depth;
			
			_dict[ _dict[ child1 ] ] = child1;
			_dict[ _dict[ child2 ] ] = child2;
			
			_container.swapChildren( child1, child2 );
		}
		
		public function removeChild( child:DisplayObject ):DisplayObject {
			if (!_dict[child]) return null;
			delete _dict[ _dict[ child ] ];
			delete _dict[ child ];
			
			return _container.removeChild( child );
		}
		
		public function removeChildAt( depth:int ):DisplayObject {
			var child:DisplayObject = _dict[ depth ];
			
			if ( child == null ){
				throw( new RangeError("Caution: no child at depth " + depth ) );
			}
			
			delete _dict[ child ];
			delete _dict[ depth ];
			
			return _container.removeChild( child );
		}
		
		private function searchIndex( depth:int ):int {
			if ( _container.numChildren > 0 ){
				var left:int = 0;
				var right:int = _container.numChildren - 1;
				var index:int = right;
				var child:DisplayObject = _container.getChildAt( index );
				
				if ( depth <= _dict[ _container.getChildAt( 0 ) ] ){
					return 0;
				}
				if ( _dict[ child ] < depth ){
					return index + 1;
				}
				
				while ( _dict[ child ] != depth ){
					if ( index == left ){
						index += ( _dict[ child ] < depth ) ? 1 : 0;
						break;
					} else if ( depth < _dict[ child ] ){
						right = index;
						index = ( left + right ) >> 1;
					} else if ( _dict[ child ] < depth ){
						left = index;
						index = ( left + right ) >> 1;
					} else {
						break;
					}
					
					child = _container.getChildAt( index );
				}
				
				return index;
			} else {
				return 0;
			}
		}
		
		private function getInstanceAtDepth( depth:int ):DisplayObject {
			return _dict[ depth ];
		}
	}
}
