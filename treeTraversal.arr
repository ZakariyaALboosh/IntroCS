use context essentials2021
data BTree<T>:
  | mt
  | node(value :: T, left :: BTree<T>, right :: BTree<T>)
end

a-tree =
  node(5,
    node(4, 
      node(3, mt, mt), mt),
    node(6, node(7, mt, mt), node(8, mt, mt)))

# degenerate tree from DCIC book
b-tree = node(1, mt,
  node(2, mt,
    node(3, mt,
      node(4, mt, mt))))


c-tree = node(38, node(5, node(1,mt,mt), node(9,node(8,mt,mt), node(15,node(13,mt,mt),mt))), node(45, mt, node(47,node(46,mt,mt),mt)))

fun btree-in-order<A>(tree :: BTree<A>) -> List<A>:
  doc: "Returns the elements of tree in a list via an in-order traversal"
  fun helper(n :: BTree<A>) -> List<A>:
    cases (BTree) n:
      | mt => empty
      | node(v, l, r) => helper(l) + link(v, empty) + helper(r)
    end
  end
  
  fun helper-right(n :: BTree<A>) -> List<A>:
    cases (BTree) n:
      | mt => empty
      | node(v, l, r) =>  link(v, empty) + helper(l) + helper(r)
    end
  end

  cases (BTree) tree:
    | mt => empty
    | node(v, l, r) =>
      helper(l) + link(v, empty) + helper-right(r)
  end
where:
  btree-in-order(a-tree) is [list: 3, 4, 5, 6, 7, 8]
  btree-in-order(b-tree) is [list: 1, 2, 3, 4]
  btree-in-order(c-tree) is [list: 1, 5, 8, 9, 13, 15, 38,45, 46, 47]
end

fun btree-pre-order<A>(tree :: BTree<A>) -> List<A>:
  doc: "Returns the elements of tree in a list via a pre-order traversal"
    fun helper(n :: BTree<A>) -> List<A>:
    cases (BTree) n:
      | mt => empty
      | node(v, l, r) => link(v, helper(l) + helper(r) )  
    end
  end
  
  cases (BTree) tree:
    | mt => empty
    | node(v, l, r) =>
      link(v, empty) + helper(l) + helper(r)
  end
where:
  btree-pre-order(c-tree) is [list: 38, 5, 1, 9, 8, 15, 13, 45, 47, 46]
end



fun btree-post-order<A>(tree :: BTree<A>) -> List<A>:
  doc: "Returns the elements of tree in a list via a post-order traversal"
   fun helper(n :: BTree<A>) -> List<A>:
    cases (BTree) n:
      | mt => empty
      | node(v, l, r) => helper(l) + helper(r) + link(v,  empty)  
    end
  end
  
  cases (BTree) tree:
    | mt => empty
    | node(v, l, r) =>
      helper(l) + helper(r) + link(v, empty)
  end

where:
  btree-post-order(c-tree) is [list: 1, 8, 13, 15, 9, 5, 46, 47, 45, 38]
end


fun btree-map<A, B>(f :: (A -> B), tree :: BTree<A>) -> BTree<B>:
  doc: "Recursively applies f to the value of every node contained in tree"

  cases (BTree) tree:
    | mt => mt
    | node(v, l, r) =>
      node(f(v), btree-map(f, l), btree-map(f, r))
  end
where:
  btree-map(lam(x): x + 1 end, a-tree) is node(6, node(5, node(4, mt, mt), mt), 
    node(7, node(8, mt, mt), node(9, mt, mt)))
  btree-map(lam(x): x + 1 end, b-tree) is node(2, mt, node(3, mt, node(4, mt, node(5, mt, mt))))
  btree-map(lam(x): x + 1 end, c-tree) is node(39, node(6, node(2,mt,mt), node(10,node(9,mt,mt), node(16,node(14,mt,mt),mt))), node(46, mt, node(48,node(47,mt,mt),mt)))

end


fun btree-fold<A, B>(
f :: (A, B -> B),
traversal :: (BTree<A> -> List<A>),
base :: B,
tree :: BTree<A>
    ) -> B:
  doc: "Does regular fold on a list from tree traversal"
  
  fun helper(l :: List<A>, b :: B,ff :: (A, B -> B) )-> B:
    cases (List<A>) l:
      |empty => b
      |link(first, rest) => helper(rest, ff(first, b), ff)
    end
  end
  cases (BTree) tree:
    |mt => mt
    |node(v, l, r)=>
              helper(traversal(tree), base, f)
end
where:
  btree-fold(lam(x, acc): x * acc end, btree-in-order, 1, a-tree) is 20160
  btree-fold(lam(x, acc): x * acc end, btree-in-order, 1, c-tree) is 259530804000
end


fun btree-filter<A>(f :: (A -> Boolean), tree :: BTree<A>) -> BTree<A>:
  doc: "deletes node and it's children if f() retruns false"
  cases (BTree) tree:
    |mt => mt
    |node(v, l, r) => 
      if f(v) :
        node(v, btree-filter(f, l), btree-filter(f, r))
      else:
        mt
      end
  end
      where:
  btree-filter(lam(x): not(x == 3) end, b-tree) is node(1, mt, node(2, mt, mt))
   
end