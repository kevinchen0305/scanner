#!/bin/bash

TXT=$1

include_reserved=`cat ${TXT} | grep -o -i "include" | sed -n '1p'`
include_count=`cat ${TXT} | grep -o -i "include" | wc -l`
main_reserved=`cat ${TXT} | grep -o -i "main" | sed -n '1p'`
main_count=`cat ${TXT} | grep -o -i "main" | wc -l`
char_reserved=`cat ${TXT} | grep -o -i "char" | sed -n '1p'`
char_count=`cat ${TXT} | grep -o -i "char" | wc -l`
int_reserved=`cat ${TXT} | grep -o -i "int[$ ]" | sed -n '1p'`
#avoid catching pr"int"f
int_count=`cat ${TXT} | grep -o -i "int[$ ]" | wc -l`
float_reserved=`cat ${TXT} | grep -o -i "float" | sed -n '1p'`
float_count=`cat ${TXT} | grep -o -i "float" | wc -l`
if_reserved=`cat ${TXT} | grep -i '^if' | grep -v 'else' | grep -o 'if' | sed -n '1p'`
#grep if,and then delete elseif
if_count=`cat ${TXT} | grep -i '^if' | grep -v 'else' | grep -o "if" | wc -l`
else_reserved=`cat ${TXT} | grep -i "else" | grep -v "if" | grep -o -i 'else' | sed -n '1p'`
#grep else,and then delete elseif
else_count=`cat ${TXT} | grep -i "else" | grep -v "if" | grep -o -i "else" | wc -l`
elseif_reserved=`cat ${TXT} | grep -o -i "elseif" | sed -n '1p'`
elseif_count=`cat ${TXT} | grep -o -i "elseif" | wc -l`
for_reserved=`cat ${TXT} | grep -o -i "for" | sed -n '1p'`
for_count=`cat ${TXT} | grep -i "^for" | sed -E 's/for[a-z,0-9]+//g' | grep -o "for" | wc -l`
while_reserved=`cat ${TXT} | grep -o -i "while" | sed -n '1p'`
while_count=`cat ${TXT} | grep -i "while" | grep -v "//" | grep -v -E "while[a-z,0-9]+" | grep -o "while" | wc -l`
do_reserved=`cat ${TXT} | grep -o -i "do" | sed -n '1p'`
do_count=`cat ${TXT} | grep -o -i "do" | wc -l`
return_reserved=`cat ${TXT} | grep -o -i "return" | sed -n '1p'`
return_count=`cat ${TXT} | grep -o -i "return" | wc -l`
switch_reserved=`cat ${TXT} | grep -o -i "switch" | sed -n '1p'`
switch_count=`cat ${TXT} | grep -o -i "switch" | wc -l`
case_reserved=`cat ${TXT} | grep -o -i "case" | sed -n '1p'`
case_count=`cat ${TXT} | grep -o -i "case" | wc -l`
printf_reserved=`cat ${TXT} | grep -o -i "printf" | sed -n '1p'`
printf_count=`cat ${TXT} | grep -o -i "printf" | wc -l`
scanf_reserved=`cat ${TXT} | grep -o -i "scanf" | sed -n '1p'`
scanf_count=`cat ${TXT} | grep -o -i "^scanf" | wc -l`
WORD_reserved=$((${include_count}+${main_count}+${char_count}+${int_count}+${float_count}+${if_count}+${else_count}+${elseif_count}+${for_count}+${while_count}+${do_count}+${return_count}+${switch_count}+${case_count}+${printf_count}+${scanf_count}))

arr_reserved=("${include_reserved}" "${main_reserved}" "${char_reserved}" "${int_reserved}" "${float_reserved}" "${if_reserved}" "${else_reserved}" "${elseif_reserved}" "${for_reserved}" "${while_reserved}" "${do_reserved}" "${return_reserved}" "${switch_reserved}" "${case_reserved}" "${printf_reserved}" "${scanf_reserved}")

arr_reserved_count=("${include_count}" "${main_count}" "${char_count}" "${int_count}" "${float_count}" "${if_count}" "${else_count}" "${elseif_count}" "${for_count}" "${while_count}" "${do_count}" "${return_count}" "${switch_count}" "${case_count}" "${printf_count}" "${scanf_count}")


LIBRARY_NAME=`cat ${TXT} | grep "#include" | sed -n 's/#include//p'`
LIBRARY_count=`cat ${TXT} | grep "#include" | wc -l`


COMMENT_NAME=`cat ${TXT} | grep "//" | cut -d'/' -f3 | sed "s/^/\\//g" | sed "s/^/\\//g"` #if insert /,we must plus \\ in front of / when they are in " "
COMMENT_NAME2=`cat ${TXT} | sed "s/\\/\\///g" | grep -o "/.*/"`
COMMENT1_count=`cat ${TXT} | grep "//" | cut -d'/' -f3 | sed "s/^/\\//g" | sed "s/^/\\//g" | wc -l`
COMMENT2_count=`cat ${TXT} | sed "s/\\/\\///g" | grep -o "/.*/" | wc -l`


id_count=`cat ${TXT} | grep -e "^int[$ ]" -e "^float" -e "^char" | cut -d';' -f1 | sed -E "s/\\*[a-z]*[,]?//g" | grep -E "[a-z]+([_][0-9])?" | sed 's/int //g' | sed 's/float //g' | sed 's/char //g' | sed 's/,/\n/g' | sed '/^$/d' | sed 's/ //g' | wc -l`
sum=0
for((k=1;k<=${id_count};k++))
do
idtw=`cat ${TXT} | grep -e "^int[$ ]" -e "^float" -e "^char" | cut -d';' -f1 | sed -E "s/\\*[a-z]*[,]?//g" | grep -E "[a-z]+([_][0-9])?" | sed 's/int //g' | sed 's/float //g' | sed 's/char //g' | sed 's/scanf//g' | sed 's/,/\n/g' | sed '/^$/d' | sed 's/ //g' | sed -n "${k}p"`
idtw_count=`cat ${TXT} | grep "${idtw}" | grep -v "^scanf" |  grep -v '#include' | grep -v '^int[$ ]' | grep -v '^float' | grep -v '^char'|grep -v -E "${idtw}[a-z]+" | grep -o "${idtw}" | wc -l`

   sum=$((${sum}+${idtw_count}+1));
done


CONSTANT_count=`cat ${TXT} | sed -E "s/[a-z]+[_][0-9]+//g" | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' | wc -l`

CONSTANT=`cat ${TXT} | sed -E "s/[a-z]+[_][0-9]+//g" | grep -Eo '[+-]?[0-9]+([.][0-9]+)?' | sed -n "${i}p"`



#avoid catching == <= >= !=
OPERATOR_equal=`cat ${TXT} | sed 's/==//g' | sed 's/<=//g' | sed 's/>=//g' | sed 's/!=//g' | grep -o '=' | sed -n '1p'`
equal_count=`cat ${TXT} | sed 's/==//g' | sed 's/<=//g' | sed 's/>=//g' | sed 's/!=//g' | grep -o '=' | wc -l`
OPERATOR_plus=`cat ${TXT} | sed 's/++//g' | grep -o '+' | sed -n '1p'`
plus_count=`cat ${TXT} | sed 's/++//g' | grep -o '+' | wc -l`
OPERATOR_sub=`cat ${TXT} | sed 's/--//g' | sed 's/ //g' | grep '-' | grep -E '([a-z,0-9])+[-]' | grep -o '-' | sed -n '1p'`
sub_count=`cat ${TXT} | sed 's/--//g' | sed 's/ //g' | grep '-' | sed -E 's/([a-z,0-9])+[-]/#include/g' |grep -o "#include" | wc -l`
OPERATOR_plusone=`cat ${TXT} | grep -o '++' | sed -n '1p'`
plusone_count=`cat ${TXT} | grep -o '++' | wc -l`
OPERATOR_subone=`cat ${TXT} | grep -o "\\--" | sed -n '1p'`
subone_count=`cat ${TXT} | grep -o "[-][-]" | wc -l`
OPERATOR_and=`cat ${TXT} | sed '/scanf/d' | grep -o '&' | sed -n '1p'`
and_count=`cat ${TXT} | sed '/scanf/d' | grep -o '&' | wc -l`
OPERATOR_percent=`cat ${TXT} | sed 's/%d//g' | sed 's/%f//g' | sed 's/%c//g' | grep -o '%' | sed -n '1p'`
percent_count=`cat ${TXT} | sed 's/%d//g' | sed 's/%f//g' | sed 's/%c//g' | grep -o '%' | wc -l`
OPERATOR_sign=`cat ${TXT} | grep -o "\\^" | sed -n '1p'`
sign_count=`cat ${TXT} | grep -o "\\^" | wc -l`
OPERATOR_mul=`cat ${TXT} | grep "[^/, ]\\*[^/]" | grep -o "*" | sed -n '1p'`
mul_count=`cat ${TXT} | sed 's/ //g' | grep "[^/, ]\\*[^/]" | sed -E "s/[a-z,0-9,)]+[*]/#include/g" | grep -o "#include" | wc -l`
OPERATOR_diver=`cat ${TXT} | sed "s/\\/[*]//g" | sed "s/[*]\\///g" |grep "[/]" | sed 's/[/][/]//g' | grep -o "[/]" | sed -n '1p'` #delete /*comment/*, then delete //comment
diver_count=`cat ${TXT} | sed "s/\\/[*]//g" | sed "s/[*]\\///g" |grep "[/]" | sed 's/[/][/]//g' | grep -o "[/]" | wc -l`
OPERATOR_line=`cat ${TXT} | grep -o '|' | sed -n '1p'`
line_count=`cat ${TXT} | grep -o '|' | wc -l`


arr_op=("${OPERATOR_equal}" "${OPERATOR_plus}" "${OPERATOR_sub}" "${OPERATOR_plusone}" "${OPERATOR_subone}" "${OPERATOR_and}" "${OPERATOR_percent}" "${OPERATOR_sign}" "${OPERATOR_mul}" "${OPERATOR_diver}" "${OPERATOR_line}")
arr_opc=("${equal_count}" "${plus_count}" "${sub_count}" "${plusone_count}" "${subone_count}" "${and_count}" "${percent_count}" "${sign_count}" "${mul_count}" "${diver_count}" "${line_count}")

COMPARATOR_smaller=`cat ${TXT} | sed '/#include/d' | sed 's/<=//g' | grep -o '<' | sed -n '1p'`
smaller_count=`cat ${TXT} | sed '/#include/d' | sed 's/<=//g' | grep -o '<' | wc -l`
COMPARATOR_bigger=`cat ${TXT} | sed '/#include/d' | sed 's/>=//g' | grep -o '>' | sed -n '1p'`
bigger_count=`cat ${TXT} | sed '/#include/d' | sed 's/>=//g' | grep -o '>' | wc -l`
COMPARATOR_smallereq=`cat ${TXT} | grep -o '<=' | sed -n '1p'`
smallereq_count=`cat ${TXT} | grep -o '<=' | wc -l`
COMPARATOR_biggereq=`cat ${TXT} | grep -o '>=' | sed -n '1p'`
biggereq_count=`cat ${TXT} | grep -o '>=' | wc -l`
COMPARATOR_noteq=`cat ${TXT} | grep -o '!=' | sed -n '1p'`
noteq_count=`cat ${TXT} | grep -o '!=' | wc -l`
COMPARATOR_eqeq=`cat ${TXT} | grep -o '==' | sed -n '1p'`
eqeq_count=`cat ${TXT} | grep -o '==' | wc -l`

arr_comparator=("${COMPARATOR_smaller}" "${COMPARATOR_bigger}" "${COMPARATOR_smallereq}" "${COMPARATOR_biggereq}" "${COMPARATOR_noteq}" "${COMPARATOR_eqeq}")
arr_comparator_count=("${smaller_count}" "${bigger_count}" "${smallereq_count}" "${biggereq_count}" "${noteq_count}" "${eqeq_count}")

bracket_small_left=`cat ${TXT} | grep -o "(" | sed -n '1p'`
bracket_small_left_count=`cat ${TXT} | grep -o "(" | wc -l`
bracket_small_right=`cat ${TXT} | grep -o ")" | sed -n '1p'`
bracket_small_right_count=`cat ${TXT} | grep -o ")" | wc -l`
bracket_big_left=`cat ${TXT} | grep -o "{" | sed -n '1p'`
bracket_big_left_count=`cat ${TXT} | grep -o "{" | wc -l`
bracket_big_right=`cat ${TXT} | grep -o "}" | sed -n '1p'`
bracket_big_right_count=`cat ${TXT} | grep -o "}" | wc -l`

arr_braket=("${bracket_small_left}" "${bracket_small_right}" "${bracket_big_left}" "${bracket_big_right}")
arr_braket_count=("${bracket_small_left_count}" "${bracket_small_right_count}" "${bracket_big_left_count}" "${bracket_big_right_count}")

percent_d=`cat ${TXT} | grep -o "%d" | sed -n '1p'`
percent_d_count=`cat ${TXT} | grep -o "%d" | wc -l`
percent_f=`cat ${TXT} | grep -o "%f" | sed -n '1p'`
percent_f_count=`cat ${TXT} | grep -o "%f" | wc -l`
percent_c=`cat ${TXT} | grep -o "%c" | sed -n '1p'`
percent_c_count=`cat ${TXT} | grep -o "%c" | wc -l`
CHANGE_line=`cat ${TXT} | grep -o '\\\n' | sed -n '1p'`
CHANGE_line_count=`cat ${TXT} | grep -o '\\\n' | wc -l`
slash_t=`cat ${TXT} | grep -o '\\\t' | sed -n '1p'`
slash_t_count=`cat ${TXT} | grep -o '\\\t' | wc -l`
slash_slash=`cat ${TXT} | grep -o '[\][\]' | sed -n '1p'`
slash_slash_count=`cat ${TXT} | grep -o '[\][\]' | wc -l`

arr_specifier=("${percent_d}" "${percent_f}" "${percent_c}" "${CHANGE_line}" "${slash_t}" "${slash_slash}" )
arr_specifier_count=("${percent_d_count}" "${percent_f_count}" "${percent_c_count}" "${CHANGE_line_count}" "${slash_t_count}" "${slash_slash_count}")


POINTER=`cat ${TXT} | grep -e "^int[$ ]" -e "^float" -e "^char" | cut -d';' -f1 | grep -E -o "[*][a-z]+[0-9]?" | sed -n '1p'`

POINTER_count=`cat ${TXT} | sed "s/\\/[*]//g" | sed "s/[*]\\///g" | sed "s/[a-z,0-9][*]//g" |  grep -E -o "[*][a-z]+[0-9]?" | wc -l`

for ((i=0;i<id_count;i++))
do
    id=`cat ${TXT} | grep -e "^int " -e "^float" -e "^char" | cut -d ';' -f1 | sed -E "s/\\*[a-z]*[,]?//g" | grep -E "[a-z]+([_][0-9])?" | sed 's/int //g' | sed 's/float //g' | sed 's/char //g' | sed 's/,/\n/g' | sed '/^$/d' | sed 's/ //' | sed -n "${i}p"`
    

ADDRESS=`cat ${TXT} | grep "scanf" | grep -o "&${id}"`
ADDRESS_count=`cat ${TXT} | grep "scanf" | grep -o "&${id}" | wc -l`
done


comma=`cat ${TXT} | grep -o "," | sed -n '1p'`
comma_count=`cat ${TXT} | grep -o "," | wc -l`
semicolon=`cat ${TXT} | grep -o ";" | sed -n '1p'`
semicolon_count=`cat ${TXT} | grep -o ";" | wc -l`
hashtag=`cat ${TXT} | grep -o "#" | sed -n '1p'`
hashtag_count=`cat ${TXT} | grep -o "#" | wc -l`
double_qoutes=`cat ${TXT} | grep -o '"' | sed -n '1p'`
double_qoutes_count=`cat ${TXT} | grep -o '"' | wc -l`

arr_punc=("${comma}" "${semicolon}" "${hashtag}" "${double_qoutes}" )
arr_punc_count=("${comma_count}" "${semicolon_count}" "${hashtag_count}" "${double_qoutes_count}")




printedtoken=`cat ${TXT} | grep -e "^printf" -e "^scanf" | sed 's/%d//g' | sed 's/%f//g' | sed 's/%c//g' | sed 's/\\\n//g' | sed 's/\\\t//g' | sed 's/[\][\]//g' | cut -d'"' -f 2 | sed 's/ /\n/g' | sed "s/,//g" | sed "/^$/d"`
print_count=`cat ${TXT} | grep -e "^printf" -e "^scanf" | sed 's/%d//g' | sed 's/%f//g' | sed 's/%c//g' | sed 's/\\\n//g' | sed 's/\\\t//g' | sed 's/[\][\]//g' | cut -d'"' -f 2 | sed 's/ /\n/g' | sed "s/,//g" | sed "/^$/d" | wc -l`

(echo "Total:$((${WORD_reserved}+${LIBRARY_count}+${COMMENT1_count}+${COMMENT2_count}+${sum}+${CONSTANT_count}+${equal_count}+${plus_count}+${sub_count}+${plusone_count}+${subone_count}+${percent_count}+${line_count}+${and_count}+${sign_count}+${mul_count}+${diver_count}+${smaller_count}+${bigger_count}+${smallereq_count}+${biggereq_count}+${noteq_count}+${eqeq_count}+${bracket_small_left_count}+${bracket_small_right_count}+${bracket_big_left_count}+${bracket_big_right_count}+${percent_d_count}+${percent_f_count}+${percent_c_count}+${CHANGE_line_count}+${slash_t_count}+${slash_slash_count}+${POINTER_count}+${ADDRESS_count}+${comma_count}+${semicolon_count}+${hashtag_count}+${double_qoutes_count}+${print_count}))tokens";) >> scanner_test.txt

(echo -e "\nReserved word:${WORD_reserved}";
for((i=0;i<16;i++))
do
    if [ "${arr_reserved_count[$i]}" -gt 0 ];then
    echo "${arr_reserved[$i]}  (x${arr_reserved_count[$i]})";
    fi
done) >> scanner_test.txt

(echo -e "\nLibrary name:${LIBRARY_count}";
echo "${LIBRARY_NAME}";) >> scanner_test.txt

(echo -e "\nComment:$((${COMMENT1_count}+${COMMENT2_count}))";
echo "${COMMENT_NAME}";
echo "${COMMENT_NAME2}";) >> scanner_test.txt

(echo -e "\nIdentifier:${sum}"
for((k=1;k<=${id_count};k++))
do
idtw=`cat ${TXT} | grep -e "^int[$ ]" -e "^float" -e "^char" | cut -d';' -f1 | sed -E "s/\\*[a-z]*[,]?//g" | grep -E "[a-z]+([_][0-9])?" | sed 's/int //g' | sed 's/float //g' | sed 's/char //g' | sed 's/,/\n/g' | sed '/^$/d' | sed 's/ //g' | sed -n "${k}p"`
idtw_count=`cat ${TXT} | grep "${idtw}" | grep -v "^scanf" |  grep -v '#include' | grep -v '^int[$ ]' | grep -v '^float' | grep -v '^char'|grep -v -E "${idtw}[a-z]+" | grep -o "${idtw}" | wc -l`

   echo "${idtw}  (x$((${idtw_count}+1)))";
done) >> scanner_test.txt

(echo -e "\nConstant:${CONSTANT_count}";
echo "${CONSTANT}";) >> scanner_test.txt

(echo -e "\nOperator:$((${equal_count}+${plus_count}+${sub_count}+${plusone_count}+${subone_count}+${percent_count}+${line_count}+${and_count}+${sign_count}+${mul_count}+${diver_count}))";
for((j=0;j<11;j++))
do
    if [ "${arr_opc[$j]}" -gt 0 ]; then
        echo "${arr_op[$j]}  (x${arr_opc[$j]})";
    fi
done) >> scanner_test.txt

(echo -e "\nComparator:$((${smaller_count}+${bigger_count}+${smallereq_count}+${biggereq_count}+${noteq_count}+${eqeq_count}))";
for((x=0;x<6;x++))
do
    if [ "${arr_comparator_count[$x]}" -gt 0 ]; then
        echo "${arr_comparator[$x]}  (x${arr_comparator_count[$x]})";
    fi
done) >> scanner_test.txt

(echo -e "\nBracket:$((${bracket_small_left_count}+${bracket_small_right_count}+${bracket_big_left_count}+${bracket_big_right_count}))";
for((k=0;k<4;k++))
do
    if [ "${arr_braket_count[$k]}" -gt 0 ]; then
        echo "${arr_braket[$k]}  (x${arr_braket_count[$k]})";
    fi
done) >> scanner_test.txt

(echo -e "\nFormat specifier:$((${percent_d_count}+${slash_t_count}+${slash_slash_count}+${percent_f_count}+${percent_c_count}+${CHANGE_line_count}))";
for((y=0;y<6;y++))
do
    if [ "${arr_specifier_count[$y]}" -gt 0 ]; then
         echo "${arr_specifier[$y]}  (x${arr_specifier_count[$y]})";
    fi
done) >> scanner_test.txt

(echo -e "\nPointer:${POINTER_count}";
echo "${POINTER}  (x${POINTER_count})";) >> scanner_test.txt

(echo -e "\nAddress:${ADDRESS_count}";
echo "${ADDRESS}";) >> scanner_test.txt

(echo -e "\nPunctuation:$((${comma_count}+${semicolon_count}+${hashtag_count}+${double_qoutes_count}))";
for((z=0;z<4;z++))
do
    if [ "${arr_punc_count[$z]}" -gt 0 ]; then
        echo "${arr_punc[$z]}  (x${arr_punc_count[$z]})";
    fi
done) >> scanner_test.txt

(echo -e "\nPrinted token:${print_count}";
echo "${printedtoken}";) >> scanner_test.txt

