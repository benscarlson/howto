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

$1 #refer back to a previous sub-group
${1} #Use the second if there is a digit immediatly after the backreference. i.e. so the regex doesn't think you are trying to match $10, use ${1}0


