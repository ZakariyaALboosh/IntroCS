use context essentials2021
import shared-gdrive("filesystem-types.arr", 
  "1C9WPivMElRfYhBzPibLMtDkXeME8N5rI") as F
type Dir = F.Dir
type File = F.File
type Path = F.Path
dir = F.dir
file = F.file

# DO NOT CHANGE ANYTHING ABOVE THIS LINE

# Implementation:


part2 = file('part2', 52, '')
hang = file('hang', 8, '')
draw = file('draw', 2, '')
read = file('read!', 19, '')
code = dir('Code', empty, [list: hang, draw, part2])
docs = dir('Docs', empty, [list: read])
libs = dir('Libs', [list: code, docs], empty)
part1 = file('part1', 99, '')
part3 = file('part3', 17, '')
textt = dir('Text', empty, [list: part1, part2, part3])
read2 = file('read!', 10, '')
TS = dir('TS', [list: textt, libs], [list: read2])


#==========Exercise 1==========#
fun how-many(a :: Dir) -> Number:
  doc: ""
  if a.ds == empty:
    countfiles(a.fs) 
  else:
    countfiles(a.fs) + how-many(a.ds.first) + how-many-dir(a.ds.rest)
  end
where:
  how-many(TS) is 8
  how-many(libs) is 4
  how-many(docs) is 1
    end

fun how-many-dir(a :: List<Dir>) -> Number:
  if a ==  empty:
    0
  else:
    how-many(a.first) + how-many-dir(a.rest)
  end
end


#==========Exercise 2==========#
fun du-dir(a-dir :: Dir) -> Number:
  doc: ""
  file-size(a-dir.fs) + dir-size(a-dir.ds) + code-size(a-dir) 
where:
  du-dir(TS) is 271
  du-dir(code) is 65
end

fun dir-size(a :: List<Dir>) -> Number:
  if a == empty:
    0    
  else if a.first.ds == empty:
    file-size(a.first.fs) + dir-size(a.rest) + code-size(a.first)
  else if a.first.fs == empty:
    dir-size(a.rest) + dir-size(a.first.ds) + code-size(a.first)
  else:
    a.first.fs.first.size + code-size(a.first) + file-size(a.first.fs.rest) + dir-size(a.first.ds) + dir-size(a.rest) 
    end    
  end
  
fun file-size(a :: List<File>) -> Number:
  if a == empty:
    0
  else: 
    a.first.size + file-size(a.rest) 
end
end

fun code-size(a :: Dir) -> Number:
  countfiles(a.fs) + countfiles(a.ds) 
end

#==========Exercise 3==========#
fun can-find(a-dir :: Dir, fname :: String) -> Boolean:
  doc: ""
  can-find-here(a-dir, fname) or can-find-there(a-dir.ds, fname)
where: 
  can-find(TS, 'hang') is true
  can-find(TS, 'test') is false
  can-find(libs, 'foo') is false
  can-find(libs, 'read!') is true
end


fun can-find-here(a :: Dir, fname :: String) -> Boolean:
  if a.fs == empty :
    false 
  else: 
    map(lam(e): e.name == fname end, a.fs).member(true)
  end

end

fun can-find-there(a :: List<Dir>, fname :: String) -> Boolean:
      if a == empty:
        false
      else:
        can-find(a.first, fname) or can-find-there(a.rest, fname)
  end
end
#==========Exercise 4==========#
fun fynd(a-dir :: Dir, fname :: String) -> List<Path>:
  doc: ""
  if can-find(a-dir, fname):
    if not(can-find-here(a-dir, fname)):
      map(lam(e):  [list:a-dir.name] + e.first end, map(lam(e): fynd(e, fname) end, a-dir.ds).filter(lam(e): not(e == empty) end))
    else:
      link(  [list: a-dir.name] , map(lam(e): if not(e == empty): e.first.push(a-dir.name) 
        else: empty end end, map(lam(e): fynd(e, fname) end, a-dir.ds)).filter(lam(e): not(e == empty) end))
    end
  else:
    empty 
  end
where:
  fynd(TS, "part3") is [list: [list: "TS", "Text"]]
  lst-same-els<Path>(fynd(TS, "part2") , [list: [list: "TS", "Libs", "Code"], [list: "TS", "Text"] ] ) is true
  
end
# ------------------------------------------------------------------
  
fun countfiles(a :: List<Any>) -> Number:
  if a == empty:
      0
  else: 
    1 + countfiles(a.rest)
  end
end

  



fun count<A>(target :: A, a :: List<A>) -> Number:

  el-checker = lam(el, cnt):

    if el == target:

      cnt + 1

    else:

      cnt

    end

  end

  a.foldl(el-checker, 0)

end

 

fun lst-same-els<A>(a :: List<A>, b :: List<A>) -> Boolean:

  fun same-count(el, acc):

    acc and (count(el, a) == count(el, b))

  end

  (a.length() == b.length()) and a.foldl(same-count, true)

end