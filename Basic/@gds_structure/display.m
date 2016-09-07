function display(gstruc)
%function display(gstruc)
%
% display method for GDS structures
%

   % print variable name
   fprintf('\n%s is a GDSII structure with ', inputname(1));
   nel = numel(gstruc.el);
   if nel == 1
      fprintf('1 element:\n\n');
   else
      fprintf('%d elements:\n\n', nel);
   end
   fprintf('   sname = %s\n', gstruc.sname);
   fprintf('   cdate = %d-%d-%d, %02d:%02d:%02d\n', gstruc.cdate);
   if ~isempty(gstruc.mdate)
      fprintf('   mdate = %d-%d-%d, %02d:%02d:%02d\n', gstruc.mdate);
   end
   fprintf('\n');

end
