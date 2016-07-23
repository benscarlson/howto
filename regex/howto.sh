# ways that '^' is used
^xyz #can indicate the beginning of a line 
gr[^x]y #can indicate a "not" if used within a character class
gr[^ae]y #applies to the whole list. this will not match gray or grey

cat|cattle #would match either cat or cattle
ca(t|ttle) #would also match either cat or cattle

\d #match a single digit
\d{1,2} #(I think) match one or two digits

[] #character class, will match one of the characters inside the brackets
gr[ea]y #matches grey or gray
gr[^x]y #matches anything but grxy.  eg. gray, grby, grcy
[^0-9] #match a non-digit character

