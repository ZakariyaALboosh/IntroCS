
use context essentials2021

data Person:
  | person(name :: String, age :: Number)
end

#solution to the sortacle assignment. to be commented and converted from pyret to python.

fun generate-input(n :: Number) -> List<Person>:
  repeat(n, generate-person())
end

fun is-valid(original :: List<Person>, sorted :: List<Person>) -> Boolean: 
  if is-equivalent(original, sorted):
    is-sorted(sorted)
  else:
    false 
end
end

fun oracle(sorter :: (List<Person> -> List<Person>)) -> Boolean:
  a = generate-input(0)
  b = generate-input(100)
  c = generate-input(1)
  not((is-valid(a, sorter(a)) and is-valid(b, sorter(b))) and is-valid(c,sorter(c)))
end

fun make-list-of-size(n):
  repeat(n, num-random(65535))
end


fun is-sorted(l :: List<Person>) -> Boolean:
  if l == empty :
    false
  else if l.rest == empty :
    true
  else: 
    (l.first.age <= l.rest.first.age)  and (is-sorted(l.rest))
  end
    end


fun is-equivalent(a :: List<Person> , b :: List<Person>) -> Boolean:
  if not(length(a) == length(b)):
    false  
  else if member(map(lam(e): if count-occurences(a, e) == count-occurences(b, e) : true else: false end end, a), false):
    false
  else:
    true 
  end
end
  
fun generate-person() -> Person:
  person(string-from-code-points(make-list-of-size(num-random(25))),num-random(150))
end


fun count-occurences(lst:: List, element :: Any) -> Number:
  doc: ```counts occurences, for testing list equivalency ```
  if lst == empty :
    0
  else if lst.first == element :
    1 + count-occurences(lst.rest, element)
  else: 
    0 + count-occurences(lst.rest, element)
end
end



fun correct-sorter(people :: List<Person>) -> List<Person>:

  doc: ```Consumes a list of people and produces a list of people

       that are sorted by age in ascending order.```

 

  sort-by(people,

    lam(p1, p2): p1.age < p2.age end,

    lam(p1, p2): p1.age == p2.age end)

where:

  tdelvecc = person("Thomas", 18)

  sli96    = person("Ell", 65)

  jmcclel1 = person("Julia", 32)

 

  correct-sorter(empty) is empty

  correct-sorter([list: sli96]) is [list: sli96]

  correct-sorter([list: sli96, tdelvecc]) is [list: tdelvecc, sli96]

  correct-sorter([list: tdelvecc, sli96]) is [list: tdelvecc, sli96]

  correct-sorter([list: tdelvecc, sli96, jmcclel1])

    is [list: tdelvecc, jmcclel1, sli96]

end
  
  check:
  l = [list: person("Zack", 12), person("Zack", 21), person("Zack", 100)]
  b = [list: person("Zack", 21), person("Zack", 12), person("Zack", 100)]
  is-sorted(l) is true
  is-equivalent(l,b) is true
    is-valid(b, l) is true 
  oracle(correct-sorter) is true
  end
