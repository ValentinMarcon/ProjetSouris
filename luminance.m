function m = luminance (t)

% New Branch for Poo

%function [pos, dirPos] = luminance () % to get lateralization graph
%--- Library declaration ---
%-- For portWrite --
hfile =(fullfile(matlabroot, 'lib','win64', '704IO.h'));
loadlibrary('704IO',hfile,'alias','lib')

%-- For portRead -- 
% The file has to be created at each Test704() call is Rack, Port and
% Offset change!
location = 'C:\Users\admin\Documents\MATLAB\';
mylib = [location '704IO.lib'];
mex('-g', 'Test704.cpp', mylib)

%--- Variables initialization ---
%Pellet retrieval increment
nbPelletRetrievalP1 = 0;
nbPelletRetrievalP2 = 0;
nbPelletRetrievalP3 = 0;
nbPelletRetrievalP4 = 0;

%To display the state number
stateNum = 0;
%Box and devices parameters
nosePoke = 0; % boolean: false (0) when nose poke is not activated
leftLever = 0; % idem
rightLever = 0; % idem
pelletVal = 1;

%%BOX MANAGEMENT%% (C'est �crit en dur pour l'instant)
%\ box = 0;
%\ portVal = 1;
%\ rackVal = 780;
%\ offsetVal = -1;
%\ pelletVal = 1;% 2 et 3 sont assign�s aux ARDUINO
%\ nosePokeVal  = 1;
%\ leftLeverVal = 2;
%\ rightLeverVal = 4;
b1 = box;
b1.portReadVal = 1;
b1.rackReadVal = 780;
b1.offsetReadVal = -1;
b1.nosePokeVal  = 1;
b1.leftLeverVal = 2;
b1.rightLeverVal = 4;
b1.portWriteVal = 1;
b1.rackWriteVal = 792;
b1.offsetWriteVal = 0;
b1.pelletVal = 1;% 2 et 3 sont assign�s aux ARDUINO
b1.leftScreenVal = []; %Pour pr�voir les �crans
b1.rightScreenVal = [ ]; %Pour pr�voir les �crans

b2 = box;
b2.portReadVal = 1;
b2.rackReadVal = 781;
b2.offsetReadVal = -1;
b2.nosePokeVal = 8; %par exemple
b2.leftLeverVal = 16;
b2.rightLeverVal = 32;
b2.portWriteVal = 1;
b2.rackWriteVal = 792;
b2.offsetWriteVal = 0;
b2.pelletVal = 4; % 5 et 6 sont assign�s aux ARDUINO
b2.leftScreenVal = []; %Pour pr�voir les �crans
b2.rightScreenVal = []; %Pour pr�voir les �crans

tableb = [b1,b2];
nbBox = length(tableb);
currentBox = 0; %Initialized by 0 because of the first incrementation in the state machine

b = tableb(currentBox); % by default
%%!BOX MANAGEMENT%%

state = 'start';
underState3 = 'US3S1'; % for "Under State 3, Stage 1"
underState4 = 'US4S1';
underState5 = 'US5S1';

%--- State machine ---
while(1)
    %pause(0.1);	% wait between each cycle >> ralenti le programme
    switch state
        case 'start'
            % mainTimer = clock; % starts main timer
            state = 'stage1';
            stateNum = 0;
            t.Data = { 'Session timer' nbPelletRetrievalP1 'nothing' ; 'Current state' stateNum 'nothing';}% The first value is the first column, the second value is in the second column... semicolons indicate a new row
            % fprintf(logfile_fid,'%s\t%s\n',datestr(clock, 'dd-mmm-YYYY HH:MM:SS.FFF'),'Entering Phase 1');
        case 'stage1'
            stateNum = 1;
            %--- Stage 1 ---
            while nbPelletRetrievalP1 < 5 %&& nbPelletRetrievalBox2 < 5% La premiere ne doit pas compter

                %%BOX MANAGEMENT%%
                %\ box = box + 1 % Box's change
                %\if box == 3
                %\    box = 1
                %\end
                
                %\if box == 1 % The box number is incremented at the end of each loop 1 -> 2 -> 1 -> 2 ...
                %\    portVal = 1;
                %\    rackVal = 780;
                %\    offsetVal = -1;
                %\    pelletVal = 1;% 2 et 3 sont assign�s aux ARDUINO
                %\    nosePokeVal  = 1;
                %\    leftLeverVal = 2;
                %\    rightLeverVal = 4;
                %\elseif box == 2
                %\    portVal = 1;
                %\    rackVal = 781;
                %\    offsetVal = -1;
                %\    pelletVal = 4; % 5 et 6 sont assign�s aux ARDUINO
                %\    nosePokeVal = 8; %par exemple
                %\    leftLeverVal = 16;
                %\    rightLeverVal = 32;
                %\end
                
                currentBox = currentBox + 1;
                if currentBox > nbBox
                    currentBox = 1;
                end
                b = tableb(currentBox);
                
                %%!BOX MANAGEMENT%%
                
                pause(5); % PBR: le programme attend 5 secondes pour continuer
                calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,b.pelletVal);%Activates the output
                calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,0);%Deactivates the output
                
                myVal = double(Test704(b.portReadVal, b.rackReadVal, b.offsetReadVal)); %o� les valeurs sont modifi�s dans le if box == ...
                if myVal == nosePokeVal
                    nosePoke = 1; %to know how much pellet retrieval we have
                else
                    nosePoke = 0;
                end
                if nosePoke == 1
                    %if currentBox == 1  %nosePoke est la valeur r�cup�r�e par mex
                    nbPelletRetrievalP1 = nbPelletRetrievalP1 + 1;
                    % elseif currentBox == 2
                    %     nbPelletRetrievalBox2 = nbPelletRetrievalBox2 + 1
                    % end
                end
                
                t.Data = { 'Session timer' 'session timer here' 'nothing' 'Pellet retrievedP1' nbPelletRetrievalP1 'nothing';...
                    'Current state' stateNum 'nothing' 'State final durationP1' 'duration here' 'nothing';...
                    'State timer' 'state timer here' 'nothing' 'nothing' 'nothing' 'nothing'};
                drawnow %to execute everything now
            end
            % nbPelletRetrieval = 0; %A ce stade, nbPelletRetrievalP1 = 5
            while nbPelletRetrievalP1 < 10
                myVal = double(Test704(b.portReadVal,b.rackReadVal,b.offsetReadVal));
                if myVal == nosePokeVal
                    nosePoke = 1;
                else
                    nosePoke = 0;
                end
                if nosePoke == 1 %Dois-t'on diff�rencier ces deux actions?
                    nbPelletRetrievalP1 = nbPelletRetrievalP1 + 1;
                    calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,b.pelletVal);
                    calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,0);
                end
                t.Data = { 'Session timer' 'session timer here' 'nothing' 'Pellet retrievedP1' nbPelletRetrievalP1 'nothing';...
                    'Current state' stateNum 'nothing' 'State final durationP1' 'duration here' 'nothing';...
                    'State timer' 'state timer here' 'nothing' 'nothing' 'nothing' 'nothing'};
                drawnow
            end
            state = 'stage2';
            
        case 'stage2'
            %--- Stage 2 ---
            stateNum = 2;
            nbPelletRetrievalP2 = 0;
            pushTime = 0;
            leverTimeP2 = 0;
            tempoP2 = 0;
            timeOutP2 = 0;
            while nbPelletRetrievalP2<10
                myVal = double(Test704(b.portReadVal, b.rackReadVal, b.offsetReadVal));
                if myVal == b.leftLeverVal
                    leftLever = 1;
                    rightLever = 0;
                elseif myVal == b.rightLeverVal
                    leftLever = 0;
                    rightLever = 1;
                end
                
                if leftLever == 1 || rightLever == 1 % NB : il faut que �a blink !
                    leverTimeP2 = leverTimeP2 + 1;
                    if leverTimeP2 == 1
                        calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,b.pelletVal); % pellet dispensation
                        calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,0);
                    end
                    tic %on d�marre le timer pour connaitre de temps de r�cup
                    pushTime = 0; % To avoid nbPelletRetrieval to be incremented when nothing is retrieved (in case of nose pokes)
                end
                %Initialization of left & right levers
                leftLever = 0;
                rightLever = 0;
                
                if myVal == nosePokeVal
                    nosePoke = 1;
                else
                    nosePoke = 0;
                end
                if nosePoke == 1 % this condition cannot be included in the previous one
                    pushTime = pushTime + 1;
                    toc
                    tempoP2 = toc; % measures the time elapsed between lever's pushing and nose poke
                    if tempoP2 <15 && pushTime == 1
                        nbPelletRetrievalP2 = nbPelletRetrievalP2 + 1;
                        nbPelletRetrievalP2; %?
                    elseif tempoP2 > 15 && pushTime == 1
                        timeOutP2 = tempoP2; %In case of time out, this variable is created to be displayed
                        nbPelletRetrievalP2 = 0;
                    end
                    leverTime = 0; 
                end
                t.Data = { 'Session timer' 'session timer here' 'nothing' 'Pellet retrievedP1' nbPelletRetrievalP1 'nothing' 'Pellet retrievedP2' nbPelletRetrievalP2 tempoP2;...
                    'Current state' stateNum 'nothing' 'State final duration P1' 'state duration here' 'nothing' 'Lever pressP2' leverTimeP2 'nothing';...
                    'State timer' 'state timer here' 'nothing' 'nothing' 'nothing' 'nothing' 'Total pellet retrieved (w/ time out)' nbPelletRetrievalP1 timeOutP2;...
                    'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'State finale duration' 'state duration here' 'nothing';};
                
                %save('testSave1.mat','nbPelletRetrievalP2','-append') %The matfile. "-append" is to add a new variable to the matfile
                %m = matfile('testSave1.mat')
                drawnow
                pause(1)
            end
            state = 'stage3';
            
        case 'stage3'
            %--- Stage 3 ---
            stateNum = 3;
            tempoP3 = 0;
            tempo2P3 = 0;
            pushTime = 0;
            bothScreensOnVal = b.leftScreenVal + b.rightScreenVal; % To switch on both screens simultaneously
            %listRand = randomizer() % NB : fonction erron�e comme on en a parl� !! il faut que le pseudo-random se fasse sur chaque essai et non a priori
            nbPelletRetrievalP3 = 0;
            while nbPelletRetrievalP3 < 10
                pause(5)% Delay of 5secs
                switch underState3 % So the portWrite are not mistaken
                    case 'US3S1'
                        myVal = double(Test704(b.portReadVal, b.rackReadVal, b.offsetReadVal));
                        if myVal == nosePokeVal
                            nosePoke = 1;
                        else
                            nosePoke = 0;
                        end
                        if nosePoke == 1
                            %writeVal = listRand(([nbPelletRetrievalP3])) % The randomised value of the PortWrite %NB: Les deux �crans s'allument � ce stade.
                            %calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,writeVal); %ARDUINO on %A REACTIVER
                            calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,bothScreensOnVal); % Both screens switch on
                            tic
                            underState3 = 'US3S2';
                        end
                        nosePoke = 0;
                    case 'US3S2'
                        myVal = double(Test704(b.portReadVal, b.rackReadVal, b.offsetReadVal));
                        if myVal == b.leftLeverVal
                            leftLever = 1;
                            rightLever = 0;
                        elseif myVal == b.rightLeverVal
                            leftLever = 0;
                            rightLever = 1;
                        end
                        if leftLever == 1 || rightLever == 1 % One of the levers is pressed % NB : il faut que �a blink !
                            toc
                            tempoP3 = toc;
                            %tic
                            if tempoP3 < 60
                                tic
                                underState3 = 'US3S3';
                                pushTime =0;
                            else
                                calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,0);%ARDUINO off
                                underState3 = 'US3S1'; % The mouse has to nose poke again
                            end
                        end
                        leftLever = 0;
                        rightLever = 0;
                        
                    case 'US3S3'
                        %pause(5)
                        myVal = double(Test704(b.portReadVal, b.rackReadVal, b.offsetReadVal));
                        if myVal == nosePokeVal
                            nosePoke = 1;
                        else
                            nosePoke = 0;
                        end
                        if nosePoke == 1
                            pushTime = pushTime + 1;
                            toc
                            tempo2P3 = toc;
                            if tempo2P3 <15 && pushTime == 1
                                calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,b.pelletVal);
                                calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,0);%ARDUINO & food dispenser off
                                nbPelletRetrievalP3 = nbPelletRetrievalP3 + 1
                                underState3 = 'US3S1';
                            else
                                calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,0);%ARDUINO off
                                underState3 = 'US3S1'; % The mouse has to nose poke again NB : et on remet compteur pellets retrieved � 0!
                            end
                        end
                end
                
                %                 t.Data = { 'Session timer' 'session timer here' 'nothing' 'Pellet retrievedP1' nbPelletRetrievalP1 'nothing' 'Pellet retrievedP2' nbPelletRetrievalP2 'tempoP2' 'Last Screen on (1:Left, 2 Right)P3' 'nothing' 'nothing';...
                %                          'Current state' stateNum 'nothing' 'State final duration P1' 'state duration here' 'nothing' 'Lever pressP2' 'leverTimeP2' 'nothing' 'Lever pressP3' 'leverTimeP3' 'time of answer';...
                %                          'State timer' 'state timer here' 'nothing' 'nothing' 'nothing' 'nothing' 'Total pellet retrieved (w/ time out)P2' nbPelletRetrievalP1 'timeOutP2' 'Time out leverP3' 'nothing' 'nothing';...
                %                          'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'State final durationP2' 'state duration here' 'nothing' 'Pellet retrievedP3' nbPelletRetrievalP3 'tempoP3';...
                %                          'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'Pellet retrieval time-out' 'time out' 'nothing';...
                %                          'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'Total pellet retrieved (w/ time out)P3' 'nothing' 'nothing';...
                %                          'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'State final durationP3' 'state duration here' 'nothing';};
                t.Data = { 'Session timer(h)' '356' '' 'Pellet retrievedP1' '10' '5secs' 'Pellet retrievedP2' '10' '10secs' 'Last Screen on (1:Left, 2 Right)P3' '1' '' 'Running reversal? (1:Yes, 0:No)' '1' '';...
                    'Current state' stateNum '' 'State final duration P1' '11min' '' 'Lever pressP2' '310' '35secs' 'Lever pressP3' '978' '43secs' 'Reversal done' '0' '';...
                    'State timer(min)' '20' '' '' '' '' 'Total pellet retrieved (w/ time out)P2' '43' '364secs' 'Time out leverP3' 'time out' '' 'Successful trials/40' '0' '0';...
                    '' '' '' '' '' '' 'State final durationP2' 'state duration here' '' 'Pellet retrievedP3' nbPelletRetrievalP3 'tempoP3' 'Total trials' 'totalTrials' '';...
                    '' '' '' '' '' '' '' '' '' 'Pellet retrieval time-out' 'time out' '' 'Last Screen on (1:Left, 2 Right)P4' 'screen' '';...
                    '' '' '' '' '' '' '' '' '' 'Total pellet retrieved (w/ time out)P3' 'total' 'time last one' 'Lever pressP4' 'leverTimeP4' 'time of answer';...
                    '' '' '' '' '' '' '' '' '' 'State final durationP3' 'state duration here' '' 'Time out leverP4' 'timeOut' '';...
                    '' '' '' '' '' '' '' '' '' '' '' '' 'Pellet retrieval time-outP4' 'time out' '';...
                    '' '' '' '' '' '' '' '' '' '' '' '' 'Pellet retrieved' 'nbPelletRetrievalP4' 'time last pellet';...
                    '' '' '' '' '' '' '' '' '' '' '' '' 'Total pellet retrieved (w/ time out)P4' 'nbPelletRetrievalP4' 'timeOutP4';...
                    '' '' '' '' '' '' '' '' '' '' '' '' 'State final durationP3' 'state duration here' ''};
                drawnow
            end
            state = 'stage4';
            
        case 'stage4'
            %--- Stage 4 ---
            stateNum = 4;
            correctTrial = 0;
            tempoP5 = 0;
            % cr�er une variable booleen correctiveTrial pour
            % savoir si quand on vient ici on a d�j� eu une
            % erreur (de base : faux)
            correctiveTrial = 0;
            screen = screenonVal; % � voir si screenOnVal est appel� � chaque fois ou pas sinon d�placer sa d�claration
            while correctTrial < 3
                pause(5) %Delay of 5secs
                switch underState5
                    case 'US5S1'
                        myVal = double(Test704(b.portReadVal, b.rackReadVal, b.offsetReadVal))
                        if myVal == nosePokevAL
                            nosePoke = 1;
                        else
                            nosePoke = 0;
                        end
                        if nosePoke == 1
                            % POUR AMANDINE: Corrective trial
                            % cr�er une variable screen qui se rappelle de l'�cran qui
                            % s'est allum� en US5S1
                                                        
                            % tester si correctiveTrial est vrai ou faux
                            % si faux continuer normal
                            if correctiveTrial == 0
                                screen = screenOnVal;
                                calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal, screen); %%@Maeva: gerer screen avec l'impl�mentation de l'objet box (sachant que j'ai cr�� un �cran gauche et un droit)
                            % si true allumer l'autre �cran screen
                            else
                                calllib('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal, screen);
                            end
                            tic
                            underState5 = 'US5S2';
                        end
                        nosePoke = 0;
                    case 'US5S2'
                        myVal = double(Test704(b.portReadVal, b.rackReadVal, b.offsetReadVal))
                        if myVal == b.leftLeverVal
                            leftLever = 1;
                            rightLever = 0;
                        elseif myVal == b.rightLeverVal
                            leftLever = 0;
                            rightLever = 1;
                        end
                        
                        if leftLever == 1 | rightLever == 1 % One of the levers is pressed % NB : il faut que �a blink !
                        toc
                        tempoP5 = toc
                        if tempoP5 < 60                            
                            tic
                            underState5 = 'US5S3';
                            pushTime = 0;
                            % comparer si leftLeverVal = 1 et si l'�cran
                            % gauche (2) est allum� : correctiveTrial = faux et
                            % correctTrial +1
                            if leftLever == 1 && screen == 2
                                correctiveTrial = 0;
                                correctTrial = correctTrial +1;
                            % pareil pour rightLeverVal = 1 et l'�cran de
                            % droite (4) : correctiveTrial = faux et
                            % correctTrial +1
                            elseif rightLever == 1 && screen == 4
                                correctiveTrial = 0;
                                correctTrial = correctTrial +1;
                            % si aucun des deux allum�s ou faux alors revenir
                            % en US5S1 et correctiveTrial = vrai
                            else 
                               underState5 = 'US5S1';
                               correctiveTrial = 1;
                            end
                        else
                            calllib ('lib','PortWrite',b.portWriteVal,b.rackWriteVal,b.offsetWriteVal,0);
                            underState5 = 'US5S1';
                        end
                        end
                        leftLever = 0;
                        rightLever = 0;
                    case 'US5S3' % VERIFICATION QUE LA SOURIS AIT BIEN APPUYE SUR LE BON LEVIER

                        myVal = double(Test704(b.portReadVal, b.rackReadVal, b.offsetReadVal))
                       if myVal == b.leftLeverVal
                            leftLever = 1;
                            rightLever = 0;
                        elseif myVal == b.rightLeverVal
                            leftLever = 0;
                            rightLever = 1;
                        elseif myVal == nosePokeVal
                            leftLever = 0;
                            rightLever = 0;
                        end
                        %%CONTINUER ICI
                        
                end
            end
            
        case 'stage5'
            %--- Stage 5 ---
            stateNum = 5;
            tempo = 0;
            tempo2 = 0;
            pushTime = 0;
            reversalCounter = 0;
            nbPelletRetrievalP5 = 0;
            reversalDone = 0;
            while reversalCounter < 6
                reversalRand = rand() % rand() est une fonction de matlab donnant un chiffre entre 0 et 1
                if reversalRand > 0.5 % No reversal
                    reversalDone = 0;
                    leftScreen = 2;
                    rightScreen = 4;
                    %underState5 = 'US5S2';
                else % Reversal
                    reversalDone = 1;
                    sprintf REVERSAL
                    rightScreen = 2;% NB : ton listrand ne prend que 2 ou 3 comme valeur or l� tu u tilises 2 et 4
                    leftScreen = 4;
                    %underState5 = 'US5S2bis';
                end
                
                % NB : toute la logique de ce qui suit est erron�e, sorry :/
                % d�j� y a pas de fen�tre glissante, tu computes par bloc donc
                % ce n'est pas bon... ensuite selon ton code, tu d�termines si
                % reversal ou pas avant chaque bloc de 40 essais (si crit�re de
                % 32 atteint) mais ce n'est pas bon ! Si elle atteint 32/40
                % mais tu avais pr�determin� que ce bloc pas de reversal, et
                % bien elle va se taper 40 nouveaux essais pour rien alors que
                % cri�re d�j� atteint avec en plus le risque qu'elle tombe dans
                % un bloc sans reversal ! Et puis d'ailleurs, c'est reversals
                % dans 100% des cas quand crit�re atteint c'est pour ca que je
                % ne compute pas par bloc (ce qui ferait qu'on raterait des
                % crit�res atteints et qu'on poursuivrait donc sans reverser)
                % mais par fen�tre glissante essai apr�s essai en regardant sur
                % les 40 derniers essais! Comme �a d�s que crit�re atteint, bim
                % ! on reverse :)
                % autre probl�me: tes reversals en eux m�me... comme c'est
                % cod�, c'est non fonctionnel car imagine tu es sur un bloc ou
                % faudra faire reversal si crit�re atteint et donc ton
                % rightscreen = 2 et leftscreen = 4. Le crit�re de 32 est
                % atteint donc on reverse. b�mol, quand on revient au d�but de
                % ta boucle, si le reversalrand n'est pas sup�rieur � 0.5 alors
                % on se retrouve dans la m�me configuration, � savoir
                % rightscreen et leftscreen tjrs avec la m�me valeur... il faut
                % repenser tout ce codage malheureusement et faire comme j'ai
                % fait, � savoir une variable qui d�termine quelle est la bonne
                % couleur/figure, une variable random qui d�termine le c�t� o�
                % dot �tre affich�e la bonne couleur/figure et ensuite
                % en fonction de la combinaison, tu d�termines quel �cran doit
                % afficher quoi. Et concernant la r�ponse, tout b�te car tu as
                % d�termin� au pr�alable de quel c�t� doit s'afficher la bonne
                % figure donc comparaison de ta variable de lat�ralisation avec
                % le levier press� et voil� ! Mais ceci doit �tre fait pour
                % chaque essai ! Quand reversal, il faut juste changer la
                % variable qui d�termine la figure correcte (blanc => noir et
                % vice versa) mais �a doit �tre d�termin� A LA FIN DE L'ESSAI!
                
                % Et je r�p�te, il faut changer ce codage par bloc !! Il faut
                % une fen�tre glissante, c'est-�-dire qu'� chaque essai, on
                % compte le nombre de r�ponse correcte sur les 40 derniers
                % (essai actuel compris).
                
                
                %AJOUTER LES DONNEES DE LA PHASE 5%
                t.Data = { 'Session timer' 'session timer here' 'nothing' 'Pellet retrievedP1' nbPelletRetrievalP1 'nothing' 'Pellet retrievedP2' nbPelletRetrievalP2 'tempoP2' 'Last Screen on (1:Left, 2 Right)P3' 'nothing' 'nothing' 'Running reversal? (1:Yes, 0:No)' 'nothing' 'nothing';...
                    'Current state' stateNum 'nothing' 'State final duration P1' 'state duration here' 'nothing' 'Lever pressP2' 'leverTimeP2' 'nothing' 'Lever pressP3' 'leverTimeP3' 'time of answer' 'Reversal done' reversalCounter 'nothing';...
                    'State timer' 'state timer here' 'nothing' 'nothing' 'nothing' 'nothing' 'Total pellet retrieved (w/ time out)P2' nbPelletRetrievalP2 'timeOutP2' 'Time out leverP3' 'nothing' 'nothing' 'Successful trials/40' 'nothing' 'percentage';...
                    'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'State final durationP2' 'state duration here' 'nothing' 'Pellet retrievedP3' nbPelletRetrievalP3 'tempoP3' 'Total trials' 'nothing' 'nothing';...
                    'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'Pellet retrieval time-out' 'time out' 'nothing' 'Last Screen on (1:Left, 2 Right)P4' 'nothing' 'nothing';...
                    'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'Total pellet retrieved (w/ time out)P3' 'nothing' 'nothing' 'Lever pressP4' 'leverTimeP4' 'time of answer';...
                    'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'State final durationP3' 'state duration here' 'nothing' 'Time out leverP4' 'nothing' 'nothing';...
                    'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'Pellet retrieval time-outP4' 'time out' 'nothing',...
                    'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'Pellet retrieved' nbPelletRetrievalP4 'nothing',...
                    'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'Total pellet retrieved (w/ time out)P4' nbPelletRetrievalP4 'timeOutP4',...
                    'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'nothing' 'State final durationP3' 'state duration here' 'nothing'};
                drawnow
            end
    end
    %t.Data = { 'Session timer' nbPelletRetrieval;}
    %save('testSave1.mat','nbPelletRetrieval') %The matfile
    %m = matfile('testSave1.mat')

        
end
end


