use context essentials2021
provide *
import shared-gdrive("nile-support.arr", "1OsN_vprdBWgzTtGTiFHVXmQDBsjM13HN") 
as NT
type File = NT.File
file = NT.file
type Recommendation = NT.Recommendation
recommendation = NT.recommendation
# DO NOT CHANGE ANYTHING ABOVE THIS LINE


fun recommend(title :: String, book-records :: List<File>) -> Recommendation:

  doc: ```Takes in the title of a book and a list of files,
       and returns a recommendation of book(s) to be paired with title
       based on the files in book-records.```
  buys = filter(lam(elem): string-contains(elem.content, title) end, book-records)
  
  distinct-list-of-books = distinct(fold((lam(acc,elem): acc.append(elem) end),[list: ] ,map(lam(s): string-split-all(s.content, "\n") end, buys)).remove(title))
  
    list-of-books = fold((lam(acc,elem): acc.append(elem) end),[list: ] ,map(lam(s): string-split-all(s.content, "\n") end, buys)).remove(title)
  
  
  
  recommendation(reccounts(createvector(distinct-list-of-books, list-of-books)),
    keepmostcommonwords(distinct-list-of-books ,  createvector(distinct-list-of-books, list-of-books),mostcommon(createvector(distinct-list-of-books,
          list-of-books))
      ))
  
  
  
   
end


fun mostcommon( vec :: List<Number>)-> Number:
  doc:``` returns highest number in list, which represents the most commonly bought together book ```
  fold(lam(mc, v): if v > mc : v  else: mc end end,0, vec)
      where: 
  mostcommon([list: 1, 1, 2 ]) is 2
    end

fun numofmostcommon(mc :: Number, vec :: List<Number> )  -> Number:
  doc: ``` number of times the most common book(s) appeared``` 
  if mc == 1 :
    1
  else:
  
    fold(lam(a, elem): if elem == mc: a + 1 else: a end end, 0, vec)
  end
  
where:
  numofmostcommon(7,[list: 0, 1,7,6,7,5,7] ) is 3
end

fun reccounts(vec :: List<Number>)-> Number:
  doc: ``` for the case of more than one most common book, multiplies the number of times they appeared by their number. ```
  mostcommon(vec) * numofmostcommon(mostcommon(vec), vec)
end

fun keepmostcommonwords( words :: List<String>, vec :: List<Number>, mc :: Number) : 
  doc: ``` keeps the most common words using a vector of numerical values that contains number of repitions for each word and mc is the largest number in the vector ```
  fold2(lam(acc, word, vecval): if vecval == mc : acc.append([list:word]) else: acc  end end , [list :] , words, vec)
end


fun createvector(totalwords :: List<String>, d:: List<String>) -> List<Number> :
  doc: ``` maps a list of words to a list of numbers with each number containing the number of times the word appeared in the list. totalwords is the list without repitition ```
  map(lam(wrd): (counta(wrd, d) ) end ,totalwords)
end

fun counta( a:: String, docu :: List<String>) -> Number:
  doc: ``` counts repititions of a string (a) in a list of strings (docu) ```
  if member(docu, a) :
    length(filter(lam(e): e == a end,docu))
    
  else:
    0
end
end



fun popular-pairs(records :: List<File>) -> Recommendation:
  doc: ```Takes in a list of files and returns a recommendation of
       the most popular pair(s) of books in records.    TODO ```
  recommendation(0, empty)
end




check:
  file-1 = file("", "Crime and Punishment\nHeaps are Lame\nLord of the Flies")
  file-2 = file("", "Crime and Punishment\nRandom Book\nLord of the Flies")
  file-3 = file("", "Test Book\nHeaps are Lame\nRandom Book")

  input = [list: file-1, file-2, file-3]

  recommend("Crime and Punishment", input) is recommendation(2, [list: "Lord of the Flies"])
  recommend("Test Book", input) is recommendation(1, [list: "Heaps are Lame", "Random Book"])
  recommend("No Recommendation", input) is recommendation(0, empty)
end
