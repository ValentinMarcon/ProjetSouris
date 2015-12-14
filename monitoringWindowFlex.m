function varargout = monitoringWindowFlex(varargin)

%Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
'gui_Singleton',  gui_Singleton, ...
'gui_OpeningFcn', @monitoringWindowFlex_OpeningFcn, ...
'gui_OutputFcn',  @monitoringWindowFlex_OutputFcn, ...
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

function monitoringWindowFlex_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles); 

tabMonitoringFlex = uitab(tabgp, 'Title', 'Box'); % METTRE UN NUMERO DE BOITE QUI S'INCREMENTE
    %For the first box 
    textStateMouse1 = uicontrol('Style','text',...
    'parent',tabMonitoringFlex,...
    'Backgroundcolor',[0.94 0.94 0.94],...
    'Position',[.5 240 100 36],...
    'visible', 'on', ...
    'String','The mouse is currently in state :');
    
    buTabBox1 = uicontrol('Style','pushButton',...
    'parent',tabMonitoringFlex,...
    'Backgroundcolor',[0.94 0.94 0.94],...
    'Position',[.5 240 100 37],...
    'visible', 'on', ...
    'String','See Tab');  
     
    buPerformBox1 = uicontrol('Style','pushButton',...
    'parent',tabMonitoringFlex,...
    'Backgroundcolor',[0.94 0.94 0.94],...
    'Position',[.5 240 100 38],...
    'visible', 'on', ...
    'String','See Performance Graph');    
    
    buLateralizeBox1 = uicontrol('Style','pushButton',...
    'parent',tabMonitoringFlex,...
    'Backgroundcolor',[0.94 0.94 0.94],...
    'Position',[.5 240 100 39],...
    'visible', 'on', ...
    'String','See Lateralization Graph');


% Outputs from this function are returned to the command line.
function varargout = monitoringWindowFlex_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;