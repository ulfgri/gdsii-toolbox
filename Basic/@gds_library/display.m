function display(glib);
%function display(glib);
%
% display method for GDS libraries
%

    % print variable name
    fprintf('\n%s is a GDSII library:\n\n', inputname(1));
    fprintf('   Library name  :  %s\n', glib.lname);
    fprintf('   Database unit :  %g m\n', glib.dbunit);
    fprintf('   User unit     :  %g m\n', glib.uunit);
    fprintf('   Structures    :  %d\n', numel(glib.st));
    for k = 1:numel(glib.st)
        fprintf('%9d ... %s (%d)\n', k, sname(glib.st{k}), numel(glib.st{k}));
    end
    fprintf('\n');

end
