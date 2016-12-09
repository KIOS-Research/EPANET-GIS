function varargout = inp2gis(varargin)
% INP2GIS MATLAB code for inp2gis.fig
%      INP2GIS, by itself, creates a new INP2GIS or raises the existing
%      singleton*.
%
%      H = INP2GIS returns the handle to a new INP2GIS or the handle to
%      the existing singleton*.
%
%      INP2GIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INP2GIS.M with the given input arguments.
%
%      INP2GIS('Property','Value',...) creates a new INP2GIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before inp2gis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to inp2gis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help inp2gis

% Last Modified by GUIDE v2.5 09-Dec-2016 15:56:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @inp2gis_OpeningFcn, ...
                   'gui_OutputFcn',  @inp2gis_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before inp2gis is made visible.
function inp2gis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to inp2gis (see VARARGIN)

% Choose default command line output for inp2gis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes inp2gis wait for user response (see UIRESUME)
% uiwait(handles.figure1);
addpath(genpath(pwd));

set(handles.pushbutton1,'string','Export GIS');
set(handles.popupmenu1,'string',pwd);
% set(handles.popupmenu1,'enable','off');
set(handles.edit2,'string','');
set(handles.edit2,'enable','off');
% set(handles.pushbutton1,'enable','off');

% --- Outputs from this function are returned to the command line.
function varargout = inp2gis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

getPathInpname = get(handles.popupmenu1,'String');
set(handles.edit2,'enable','on');

try
    d=epanet(getPathInpname,'bin','LoadFile');
catch e
    set(handles.edit2,'String','Wrong path of input file. Select new input file.');
    return;
end
    
set(handles.edit2,'String','Wait a moment...')
pause(.01);
inp2gis_main(d,getPathInpname);
set(handles.edit2,'String','Operation complete.')

[~,f]=fileparts(getPathInpname);
winopen(f)
% --- Executes on button press in text2.
function text2_Callback(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.popupmenu1,'string',pwd);
% set(handles.popupmenu1,'enable','off');
set(handles.edit2,'string','');
set(handles.edit2,'enable','off');
% set(handles.pushbutton1,'enable','off');

[inpname,pathfile] = uigetfile('*.inp');
if length(inpname)~=1
%     set(handles.popupmenu1,'enable','on');
    set(handles.edit2,'enable','off');
%     set(handles.pushbutton1,'enable','on'); 
    
file = [pathfile,inpname];
set(handles.popupmenu1,'String',file);

end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
