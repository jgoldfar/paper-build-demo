$pdflatex="pdflatex --shell-escape --enable-write18 -enable-write18 --synctex=1 -interaction=nonstopmode %O %S";

# $cwd = cwd();
# $pdf_previewer = 'osascript -e "set theFile to POSIX file \"%S\" as alias" -e "set thePath to POSIX path of theFile" -e "tell application \"Skim\"" -e "open theFile" -e "end tell"';
# $pdf_update_method = 4;
# $pdf_update_command = '/usr/bin/osascript -e "set theFile to POSIX file \"%S\" as alias" -e "set thePath to POSIX path of theFile" -e "tell application \"Skim\"" -e "  set theDocs to get documents whose path is thePath" -e "  try" -e "    if (count of theDocs) > 0 then revert theDocs" -e "  end try" -e "  open theFile" -e "end tell"';

# $pdf_previewer =~ s#pwd#$cwd#
# $pdf_update_command =~ s#pwd#$cwd#

# add_cus_dep('gnuplot', 'table', 0, 'gnuplot_sub');
# sub gnuplot_sub {
# 	system( "gnuplot \"$_[0].gnuplot\"" )
# }
