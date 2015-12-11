function varargout = parametersBinWindow(varargin)
%Med Library
hfile =(fullfile(matlabroot, 'lib','win32', '704IO.h'))
loadlibrary('704IO',hfile,'alias','lib')

%Initialization code
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
'gui_Singleton',  gui_Singleton, ...
'gui_OpeningFcn', @parametersBinWindow_OpeningFcn, ...
'gui_OutputFcn',  @parametersBinWindow_OutputFcn, ...
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


function parametersBinWindow_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);    

% function buNbBox()
%textNbBox's value retrieval
global nbBox
%textAddColumn's value retrieval
    tabgp = uitabgroup('Position',[.01 .20 0.98 .75]);
    while nbBox>0
        nbBox = nbBox - 1;
%    if numbBox == 1
        %creation of the tab
        tab1 = uitab(tabgp, 'Title', 'Box');
        
        %labels and texts displayed for each tab corresponding to a box
        labNbOutput = uicontrol('Style','text',...
            'parent', tab1,...
            'BackgroundColor',[0.94 0.94 0.94],...
            'Position',[.5 240 100 36],...
            'visible', 'on', ...
            'String','Output parameters :');
        labNbInput = uicontrol('Style','text',...
            'parent', tab1,...
            'BackgroundColor',[0.94 0.94 0.94],...
            'Position',[.5 95 100 36],...
            'visible', 'on', ...
            'String','Input parameters :');
        
        %Initialization of the data
        dataOutput = cell(4,16);

        %Output table's creation
        rnamesOutput = {'Rack','Port','Offset','Value'};
        tableOutput= uitable('ColumnWidth',{70},...
            'parent', tab1, ...
            'Position',[30 145 480 112], ...
            'data',dataOutput, ...
            'ColumnEditable',true(1,16), ...
            'RowName',rnamesOutput,...
            'CellEditCallback',@recoverDataPos);
 

        %Initialization of the data
        dataInput = cell(3,8);    

        global tableInput
        %Input table's creation
        rnamesInput = {'Rack','Port','Offset'};
        tableInput = uitable('ColumnWidth',{70},...
            'parent', tab1, ...
            'Position',[30 20 480 93], ...
            'data',dataInput, ...
            'ColumnEditable',true(1,8), ...
            'RowName',rnamesInput,...
            'CellEditCallback',@recoverDataPos);
        
%     elseif numbBox == 2
%         %creation of the tab1
%         tab1 = uitab(tabgp,'Title', 'Box 1');
%         %labels and texts displayed for each tab corresponding to a box
%         labNbOutput = uicontrol('Style','text',...
%             'parent', tab1,...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'Position',[.5 220 100 36],...
%             'visible', 'off', ...
%             'String','Number of outputs :');
%         labNbInput = uicontrol('Style','text',...
%             'parent', tab1,...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'Position',[.5 190 100 36],...
%             'visible', 'off', ...
%             'String','Number of inputs :');
%         popupNbOutput = uicontrol('Style','popup',...
%             'parent', tab1,...
%             'string',{'',1:16}, ...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'visible', 'off', ...
%             'Position',[100 240 40 20]);
%         popupNbInput = uicontrol('Style','popup',...
%             'parent', tab1,...
%             'string',{'',1:8}, ...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'visible', 'off', ...
%             'Position',[100 210 40 20]);
% 
%         %Initialization of the data
%         dataOutput = cell(4,numbColumn);
% 
%         %Output table's creation
%         rnamesOutput = {'Rack','Port','Offset','Value'};
%         tableOutput= uitable('ColumnWidth',{70},...
%             'parent', tab1, ...
%             'Position',[30 140 480 112], ...
%             'data',dataOutput, ...
%             'ColumnEditable',true(1,16), ...
%             'RowName',rnamesOutput,...
%             'CellEditCallback',@recoverDataPos);
% 
% 
%         %Initialization of the data
%         dataInput = cell(3,8);
% 
%         %Input table's creation
%         rnamesInput = {'Rack','Port','Offset'};
%         tableInput = uitable('ColumnWidth',{70},...
%             'parent', tab1, ...
%             'Position',[30 20 480 93], ...
%             'data',dataInput, ...
%             'ColumnEditable',true(1,8), ...
%             'RowName',rnamesInput,...
%             'CellEditCallback',@recoverDataPos);
%         %---Tab1 END
%         
%         %creation of the tab2
%         tab2 = uitab(tabgp,'Title', 'Box 2');
%         %labels and texts displayed for each tab corresponding to a box
%         labNbOutput = uicontrol('Style','text',...
%             'parent', tab2,...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'Position',[.5 220 100 36],...
%             'visible', 'off', ...
%             'String','Number of outputs :');
%         labNbInput = uicontrol('Style','text',...
%             'parent', tab2,...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'Position',[.5 190 100 36],...
%             'visible', 'off', ...
%             'String','Number of inputs :');
%         popupNbOutput = uicontrol('Style','popup',...
%             'parent', tab2,...
%             'string',{'',1:16}, ...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'visible', 'off', ...
%             'Position',[100 240 40 20]);
%         popupNbInput = uicontrol('Style','popup',...
%             'parent', tab2,...
%             'string',{'',1:8}, ...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'visible', 'off', ...
%             'Position',[100 210 40 20]);
% 
%         %Initialization of the data
%         dataOutput = cell(4,numbColumn);
% 
%         %Output table's creation
%         rnamesOutput = {'Rack','Port','Offset','Value'};
%         tableOutput= uitable('ColumnWidth',{70},...
%             'parent', tab2, ...
%             'Position',[30 140 480 112], ...
%             'data',dataOutput, ...
%             'ColumnEditable',true(1,16), ...
%             'RowName',rnamesOutput,...
%             'CellEditCallback',@recoverDataPos);
% 
% 
%         %Initialization of the data
%         dataInput = cell(3,8);
% 
%         %Input table's creation
%         rnamesInput = {'Rack','Port','Offset'};
%         tableInput = uitable('ColumnWidth',{70},...
%             'parent', tab2, ...
%             'Position',[30 20 480 93], ...
%             'data',dataInput, ...
%             'ColumnEditable',true(1,8), ...
%             'RowName',rnamesInput,...
%             'CellEditCallback',@recoverDataPos);
%         %---Tab2 END
%         
%     elseif numbBox == 3 
%         %creation of the tab1
%         tab1 = uitab(tabgp,'Title', 'Box 1');
%         %labels and texts displayed for each tab corresponding to a box
%         labNbOutput = uicontrol('Style','text',...
%             'parent', tab1,...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'Position',[.5 220 100 36],...
%             'visible', 'off', ...
%             'String','Number of outputs :');
%         labNbInput = uicontrol('Style','text',...
%             'parent', tab1,...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'Position',[.5 190 100 36],...
%             'visible', 'off', ...
%             'String','Number of inputs :');
%         popupNbOutput = uicontrol('Style','popup',...
%             'parent', tab1,...
%             'string',{'',1:16}, ...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'visible', 'off', ...
%             'Position',[100 240 40 20]);
%         popupNbInput = uicontrol('Style','popup',...
%             'parent', tab1,...
%             'string',{'',1:8}, ...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'visible', 'off', ...
%             'Position',[100 210 40 20]);
% 
%         %Initialization of the data
%         dataOutput = cell(4,numbColumn);
% 
%         %Output table's creation
%         rnamesOutput = {'Rack','Port','Offset','Value'};
%         tableOutput= uitable('ColumnWidth',{70},...
%             'parent', tab1, ...
%             'Position',[30 140 480 112], ...
%             'data',dataOutput, ...
%             'ColumnEditable',true(1,16), ...
%             'RowName',rnamesOutput,...
%             'CellEditCallback',@recoverDataPos);
% 
% 
%         %Initialization of the data
%         dataInput = cell(3,8);
% 
%         %Input table's creation
%         rnamesInput = {'Rack','Port','Offset'};
%         tableInput = uitable('ColumnWidth',{70},...
%             'parent', tab1, ...
%             'Position',[30 20 480 93], ...
%             'data',dataInput, ...
%             'ColumnEditable',true(1,8), ...
%             'RowName',rnamesInput,...
%             'CellEditCallback',@recoverDataPos);
%         %---Tab1 END
%         
%         %creation of the tab2
%         tab2 = uitab(tabgp,'Title', 'Box 2');
%         %labels and texts displayed for each tab corresponding to a box
%         labNbOutput = uicontrol('Style','text',...
%             'parent', tab2,...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'Position',[.5 220 100 36],...
%             'visible', 'off', ...
%             'String','Number of outputs :');
%         labNbInput = uicontrol('Style','text',...
%             'parent', tab2,...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'Position',[.5 190 100 36],...
%             'visible', 'off', ...
%             'String','Number of inputs :');
%         popupNbOutput = uicontrol('Style','popup',...
%             'parent', tab2,...
%             'string',{'',1:16}, ...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'visible', 'off', ...
%             'Position',[100 240 40 20]);
%         popupNbInput = uicontrol('Style','popup',...
%             'parent', tab2,...
%             'string',{'',1:8}, ...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'visible', 'off', ...
%             'Position',[100 210 40 20]);
% 
%         %Initialization of the data
%         dataOutput = cell(4,numbColumn);
% 
%         %Output table's creation
%         rnamesOutput = {'Rack','Port','Offset','Value'};
%         tableOutput= uitable('ColumnWidth',{70},...
%             'parent', tab2, ...
%             'Position',[30 140 480 112], ...
%             'data',dataOutput, ...
%             'ColumnEditable',true(1,16), ...
%             'RowName',rnamesOutput,...
%             'CellEditCallback',@recoverDataPos);
% 
% 
%         %Initialization of the data
%         dataInput = cell(3,8);
% 
%         %Input table's creation
%         rnamesInput = {'Rack','Port','Offset'};
%         tableInput = uitable('ColumnWidth',{70},...
%             'parent', tab2, ...
%             'Position',[30 20 480 93], ...
%             'data',dataInput, ...
%             'ColumnEditable',true(1,8), ...
%             'RowName',rnamesInput,...
%             'CellEditCallback',@recoverDataPos);
%         %---Tab2 END
%         
%         %creation of the tab3
%         tab3 = uitab(tabgp,'Title', 'Box 3');
%         %labels and texts displayed for each tab corresponding to a box
%         labNbOutput = uicontrol('Style','text',...
%             'parent', tab3,...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'Position',[.5 220 100 36],...
%             'visible', 'off', ...
%             'String','Number of outputs :');
%         labNbInput = uicontrol('Style','text',...
%             'parent', tab3,...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'Position',[.5 190 100 36],...
%             'visible', 'off', ...
%             'String','Number of inputs :');
%         popupNbOutput = uicontrol('Style','popup',...
%             'parent', tab3,...
%             'string',{'',1:16}, ...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'visible', 'off', ...
%             'Position',[100 240 40 20]);
%         popupNbInput = uicontrol('Style','popup',...
%             'parent', tab3,...
%             'string',{'',1:8}, ...
%             'BackgroundColor',[0.94 0.94 0.94],...
%             'visible', 'off', ...
%             'Position',[100 210 40 20]);
% 
%         %Initialization of the data
%         dataOutput = cell(4,numbColumn);
% 
%         %Output table's creation
%         rnamesOutput = {'Rack','Port','Offset','Value'};
%         tableOutput= uitable('ColumnWidth',{70},...
%             'parent', tab3, ...
%             'Position',[30 140 480 112], ...
%             'data',dataOutput, ...
%             'ColumnEditable',true(1,16), ...
%             'RowName',rnamesOutput,...
%             'CellEditCallback',@recoverDataPos);
% 
% 
%         %Initialization of the data
%         dataInput = cell(3,8);
% 
%         %Input table's creation
%         rnamesInput = {'Rack','Port','Offset'};
%         tableInput = uitable('ColumnWidth',{70},...
%             'parent', tab3, ...
%             'Position',[30 20 480 93], ...
%             'data',dataInput, ...
%             'ColumnEditable',true(1,8), ...
%             'RowName',rnamesInput,...
%             'CellEditCallback',@recoverDataPos);
%         %---Tab3 END
    
% 
% %     end
%     %the validation button is available
%     set(handles.buNbTab,'visible','on');
    end


% Outputs from this function are returned to the command line.
function varargout = parametersBinWindow_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% Allows the user to recover the position of data entered in the table
function recoverDataPos(hObject,callbackdata)
global rowIndice columnIndice
    numval = eval(callbackdata.EditData);
    rowIndice = callbackdata.Indices(1)%recovers row position
    columnIndice = callbackdata.Indices(2)%recovers column position
    hObject.Data{rowIndice,columnIndice} = numval;
    
    
% % Checks entered values
% function checkRackValue(src, eventdata)
% if eventdata.Indices(2) == 2&& ...
%         (eventdata.NewData <0 || eventdata.NewData > 120 )
%     tableData = src.Data;
%     tableData{eventdata.Indices(1), eventdata.Indices(2)} = eventdata.PreviousData;
%     src.Data = tableData;
%     warning('WARNIIING')
% end

function buNbTab_Callback(hObject, eventdata, handles)
    global tableInput
    selectInputTab = get(tableInput,'Data')
%     input1 = selectInputTab(1:3)
%     input2 = selectInputTab(4:6)

    close(gcf);
