function  loadfile_hd5_total(filename_loaded,handles)
    
global selstring; global s;
global Cursors;
global number_of_cursors; global cursor_locs;
global number_of_cursors2; global cursor_locs2;
global hh;
% global filename_loaded;
global dfs;
global drname;
global fs;

Cursors = []; 
cursor_locs = [];
number_of_cursors = 0;
cursor_locs2 = [];
number_of_cursors2 = 0;

% if ~strcmp(filename_loaded(end-2:end),'.h5')
%     f = errordlg('Dir not found','File Error');
%     set(handles.loadingdata,'visible','off');
%     return;
% end

dfs = loadDataFile(filename_loaded);        

fs  = dfs.header.AcquisitionSampleRate;
i = strfind(filename_loaded,'\');
drname = filename_loaded(i(end)+1:end);


k = strfind(drname,'_');
l = strfind(drname,'.');
% if isempty(k)
%     selstring = [drname(1:k(1)-1) drname(k(end-1):l-1)];
% else
    selstring = [drname(1:k(1)-1) drname(k(end-1):l-1)];
% end

names = fieldnames(dfs);
idx = 1;
% stemp = zeros(10000,length(names)-1);
for j = 1:length(names)
    if strfind(char(names(j)),'sweep')
        aaa = dfs.(char(names(j)));
        stemp{idx} = aaa.analogScans;
        idx = idx + 1;
    end
end
s = cell2mat(stemp);
% hh = plot(handles.axes1,sg);
% set(handles.selbox,'string',selstring);
% set(handles.selbox,'value',[]);
% set(handles.stimtext,'string','');
%         
aa=1;
    