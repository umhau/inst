#!/bin/bash

## EXAMPLES
# taken from https://www.ctan.org/tex-archive/support/pdfjam

# Example 1: Batch 2-upping of documents
# Consider converting each of two documents to a side-by-side "2-up" format. Since we want the two documents to be processed separately, we'll use the --batch option:
# pdfjam --batch --nup 2x1 --suffix 2up --landscape file1.pdf file2.pdf
# This will produce new files file1-2up.pdf and file2-2up.pdf in the current working directory.

# Example 2: Merging pages from 2 documents
# Suppose we want a single new document which puts together selected pages from two different files:
# pdfjam file1.pdf '{},2-' file2.pdf '10,3-6' --outfile ../myNewFile.pdf
# The new file myNewFile.pdf, in the parent directory of the current one, contains an empty page, followed by all pages of file1.pdf except the first, followed by pages 10, 3, 4, 5 and 6 from file2.pdf.
# The resulting PDF page size will be whatever is the default paper size for you at your site. If instead you want to preserve the page size of (the first included page from) file1.pdf, use the option --fitpaper true.
# All pages in an output file from pdfjam will have the same size and orientation. For joining together PDF files while preserving different page sizes and orientations, pdfjam is not the tool to use.

# Example 6: Trimming pages; and piped output
# Suppose we want to trim the pages of our input file prior to n-upping. This can be done by using a pipe:
# pdfjam myfile.pdf --trim '1cm 2cm 1cm 2cm' --clip true --outfile /dev/stdout | pdfjam --nup 2x1 --frame true --outfile myoutput.pdf
# The --trim option specifies an amount to trim from the left, bottom, right and top sides respectively; to work as intended here it needs also --clip true. These (i.e., trim and clip) are in fact options to LaTeX's \includegraphics command (in the standard graphics package).

## EXTENSION: booklet printing
# # install dependency (700mb): texlive-extra-utils
# pdfbook foo.pdf
# # source: https://askubuntu.com/a/873464
# # improvement: https://superuser.com/questions/904332/add-gutter-binding-margin-to-existing-pdf-file

# set -e

infile="$1"; if [ ! -f "$infile" ]; then echo "file not found! exiting.";exit;fi
outfile="$infile.`date "+%Y.%m.%d.%H.%M.%S"`.pdf"

read -p "Remove pages from the document? y/n. [n]: " rp_bool; rp_bool=${rp_bool:-n}

if [ "$rp_bool" == 'y' ]; then
    echo -e "\tenter page range: e.g., '{},2,4-5,9-' makes an empty page, followed by pages"
    echo -e "\t2,4,5,6 of the file, followed by pages 9 on to the end of the file. "
    echo -ne "\tenter page selection (do not use quotes) > "
    read pagerange
else
    pagerange=" - "
fi

# read -p "trim document pages? y/n. [n]: " trimbool; trimbool=${trimbool:-n}

# if [ "$trimbool" == 'y' ]; then
#     echo -e "\tenter page trim, in centimeters: e.g., '1cm 2cm 1cm 2cm'. Measurements"
#     echo -e "\tcorrespond to the left, bottom, right and top sides respectively. "
#     echo -ne "\tEnter page trim (do not use quotes) > "
#     read trimnumbers
#     trimnumbers=\'$trimnumbers\'
#     pagetrim=" --trim $trimnumbers --clip true "
# else
#     pagetrim=""
# fi

# echo "$infile --> $outfile"

pdfjam "$infile" "$pagerange" --no-landscape -q --frame true --nup 2x2 --offset '13 0' --scale '0.95' --twoside  --outfile "$outfile"

echo -ne "\n\t"; lpstat -d
read -p "print document to default printer? y/n. [y]: " printbool; printbool=${printbool:-y}

if [ "$printbool" == 'y' ]; then

    # echo -ne "\n\t"; lpstat -d
    # echo -ne "\tuse default printer? y/n. [y]: "; read defaultbool; defaultbool=${defaultbool:-y}
    # if [ "$defaultbool" == 'n' ]; then
    #     echo -e "\tavailable printers\n"
    #     lpstat -p -d # or just -e for a simple list
    #     echo -ne "\nenter the name of the printer you want to use:\n\t> "; read printer;
    # fi

    # echo -ne "\nready to print. confirm > "; read;

    number_of_pages=$(pdfinfo "$outfile" | grep Pages | awk '{print $2}')
    number_of_sheets=$(($number_of_pages/2 + $number_of_pages % 2))

    echo -e "\ttotal sheet count: $number_of_sheets"
    echo -ne "\tprinting pages: "

    currentlineusage='20'
    for i in $(seq 1 $number_of_sheets);
    do
        page_1=$(("$i"*2-1)); page_2=$(($page_1 + 1))
        pagereport="($page_1,$page_2) "
        reportlength=${#pagereport}
        newlineusage=$(("$currentlineusage" + "$reportlength" ))
        if (( "$newlineusage" > 80 )); then 
            echo -ne "\n\t"; currentlineusage='4'; 
        else currentlineusage=$newlineusage; 
        fi         

        # bash /usr/bin/lpr -P "$printer" -o page-ranges="$page_1-$page_2" -o sides=two-sided-long-edge -o fit-to-page -o media=letter "$outfile"

        lpr -o page-ranges="$page_1-$page_2" -o sides=two-sided-long-edge -o fit-to-page -o media=letter "$outfile"

        echo -ne "$pagereport"

        ((print_job_count++))

    done

    echo -e "\n\twarning: $print_job_count print jobs have been created and $print_job_count sheets of paper will be"
    echo -e "\tused. if you change your mind, run cancel -a to cancel all pending print jobs."    

    read -p "cancel all queued documents? y/n. [n]: " cancelbool; cancelbool=${cancelbool:-n}
    if [ "$cancelbool" == 'y' ]; then cancel -a; fi

fi

read -p "delete formatted document (wait until printing is completed)? y/n. [y]: " delbool; delbool=${delbool:-y}
if [ "$delbool" == 'y' ]; then rm -rf "$outfile"; fi
