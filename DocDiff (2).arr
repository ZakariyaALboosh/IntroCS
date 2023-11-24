use context essentials2021
include math

fun dot-product(x :: List<Number>, y :: List<Number>) -> Number :
  var result = 0 
  holder = map(lam(d): result := result + d end, map2(lam(b,c): b * c end, x, y))
  result
end

fun createvector(totalwords :: List<String>, d:: List<String>) -> List<Number> :
  map(lam(wrd): (counta(totalwords, wrd, d) ) end ,totalwords)
end

fun counta(totalwords :: List<String>, a:: String, docu :: List<String>) -> Number:

  if member(docu, a) :
    length(filter(lam(e): e == a end,docu))
    
  else:
    0
end
end


  fun overlap(doc1 :: List<String>, doc2 :: List<String>) -> Number:
  
  totalwords = distinct(doc1.append(doc2).map(string-toupper).sort())
  vector1 = createvector(totalwords, doc1.map(string-toupper) )
  vector2 = createvector(totalwords, doc2.map(string-toupper) )
  

  (dot-product(vector1, vector2)) / num-max(
    num-sqr(num-sqrt(dot-product(vector1, vector1))), 
    num-sqr(num-sqrt(dot-product(vector2, vector2))))
  
  
where: 
  overlap([list: "welcome", "to", "Walmart"], 
    [list: "WELCOME", "To", "walmart"]) is-roughly 3/3
end


check:

 # these examples taken from the Examplar paper
  overlap([list: "welcome", "to", "Walmart"], 
    [list: "WELCOME", "To", "walmart"]) is-roughly 3/3
  overlap([list: "1", "!", "A", "?", "b"], 
    [list: "1", "A", "b"]) is-roughly 3/5
  overlap([list: "alakazam", "abra"],
    [list: "abra", "kadabra", "alakazam", "abra"]) is-roughly 2/4
  overlap([list: "a", "b"], [list: "c"]) is 0/3

  # epsilon test for roughnums
  epsilon = 0.001
  a = [list: "alakazam", "abra"]
  b = [list: "abra", "kadabra", "alakazam", "abra"]

  num-abs(overlap(a, b) - 2/4) <= epsilon is true  

end

