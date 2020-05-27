% --- Executes on button press in Disp.
function Disp_Sig(handles,p)
% hObject    handle to Disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
global s fs;

t = 0:(1/fs):(length(s)-1)/fs;
axes(handles.maxes2);
plot(handles.maxes2,t,s);
 xlim([t(1) t(end)]);
