use context essentials2021
provide *
provide-types *

import shared-gdrive("updater-types.arr", "1h-qMLhuD-flbIdVmNCZ4mTOpmd6lF_UJ") 
as support


import lists as L

data Tree<A>:
  | mt
  | node(value :: A, children :: List<Tree>)
end

data Cursor<A>:
  | mt-cursor
  | cursor(above :: Cursor<A>, index :: Number, point :: Tree<A>)
end



#assignment not finished .. to be done soon. a bit trickier than the other ones.



# test tree:
#        1
#       / \
#      2   5
#     / \   \
#    4   3   6 
#         \   \
#         3.5  7

test-tree = 
  node(1, [list:
      node(2, 
        [list: node(4, empty), node(3, [list: node(3.5, empty)])]),
      node(5, 
        [list: node(6, [list: node(7, empty)])])])



fun find-cursor<A>(tree :: Tree<A>, pred :: (A -> Boolean)) -> Cursor<A> :
  cases (Tree<A>) tree:
    |mt  => raise("Could not fin node matching predicate.")
    |node(value, children) => 
      if pred(value) :
        cursor(mt-cursor, 0, tree)
      else if not(is-empty(tree.children)):
        res = find-cursor-in-children(cursor(mt-cursor, 0, tree),tree.children , pred, 0)
        if res == mt-cursor:
          raise("Could not find node matching predicate.")
        else: 
          res
        end
      else:
          raise("Could not find node matching predicate.")
      end
  end

  
where:
  find-cursor(test-tree, lam(x): x == 1 end) is  cursor(mt-cursor, 0,  node(1, [list:
      node(2, 
        [list: node(4, empty), node(3, [list: node(3.5, empty)])]),
      node(5, 
        [list: node(6, [list: node(7, empty)])])]) )
  find-cursor(test-tree, lam(x): x == 3 end) is  cursor(cursor(cursor(mt-cursor, 0,  node(1, [list:
      node(2, 
        [list: node(4, empty), node(3, [list: node(3.5, empty)])]),
      node(5, 
              [list: node(6, [list: node(7, empty)])])]) ), 0, node(2, 
        [list: node(4, empty), node(3, [list: node(3.5, empty)])]) ), 1, node(3, [list: node(3.5, empty)]) )
  
  find-cursor(test-tree, lam(x): x == 88 end) raises "Could not find node matching predicate"
end




fun find-cursor-in-children<A>(parent :: Cursor<A>, children :: List<Tree<A>>, pred :: (A -> Boolean), index :: Number) -> Cursor<A> :
  cases (List<Tree<A>>) children:
      | empty => mt-cursor
      | link(f, r) =>
        cases (Tree<A>) f:
          |mt => mt-cursor
          |node(value, childList) =>
            if pred(value) :
              cursor(parent, index, f)
            else if not(is-empty(f.children)) :
            result  = find-cursor-in-children(cursor(parent, index, f),childList, pred ,0 )
              if result == mt-cursor:
                find-cursor-in-children(parent, r, pred, index + 1)
              else:
                result
              end
              else: 
                find-cursor-in-children(parent, r, pred, index + 1)
                        end
            end
        end
    end

                

  

          
          
       

