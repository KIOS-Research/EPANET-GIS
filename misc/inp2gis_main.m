function inp2gis_main(d,inpname)
%     [inpname,pathfile] = uigetfile('*.inp');
%     d=epanet(inpname,'bin','LoadFile');

    [~,f]=fileparts(inpname);
    S = d.getBinSections;
    if ~exist(f, 'dir'), mkdir(f); end
    getFields = fields(S);

    %% Coordinates, Vertices
    if ~strcmpi(getFields,'coordinates')
        S.Coordinates=1;
    end
    if ~strcmpi(getFields,'vertices')
        S.Vertices=1;
    end
    for i=2:length(S.Coordinates)
        strs=regexp(S.Coordinates{i},'\s','split');
        strs(strcmp('',strs))=[];
        if (strs{1}(1) == ';'), continue; end
        idCoords{i-1}=strs{1};        
        XCoords(i-1)=str2num(strs{2}); 
        YCoords(i-1)=str2num(strs{3}); 
    end
    for i=2:length(S.Vertices)
        strs=regexp(S.Vertices{i},'\s','split');
        strs(strcmp('',strs))=[];
        if (strs{1}(1) == ';'), continue; end
        idVertices{i-1}=strs{1};        
        Xvertices(i-1)=str2num(strs{2}); 
        Yvertices(i-1)=str2num(strs{3}); 
    end

    %% Junctions
    j=1;
    for i=2:length(S.Junctions)
        strs=regexp(S.Junctions{i},'\s','split');
        strs(strcmp('',strs))=[];
        if (strs{1}(1) == ';'), continue; end
        Junctions(j).('ID')=strs{1};        
        JunctionsID{j}=strs{1};        
        Junctions(j).('Elevation')=str2num(strs{2});
        if length(strs)>2
            JunctionsDemands{j}='';
            if (strs{3}(1) ~= ';')
                JunctionsDemands{j}=strs{3};
            end
        end
        if length(strs)>3
            JunctionsPatterns{j}='';
            if (strs{4}(1) ~= ';')
                JunctionsPatterns{j}=strs{4};
            end
        end
        pI=find(strcmpi(strs{1},idCoords));
        if ~isempty(pI)
            Junctions(j).X=XCoords(pI);
            Junctions(j).Y=YCoords(pI);
            Junctions(j).Geometry='Point';
        else
            Junctions(j).X=0;
            Junctions(j).Y=0;
            Junctions(j).Geometry='Point';
        end
        j=j+1;
    end
    %% Reservoirs
    if length(S.Reservoirs)<3
        Reservoirs(1).('ID')='';        
        Reservoirs(1).('Head')='';
        Reservoirs(1).X=0;
        Reservoirs(1).Y=0;
        Reservoirs(1).Geometry='Point';
    end
    j=1;
    for i=2:length(S.Reservoirs)
        strs=regexp(S.Reservoirs{i},'\s','split');
        strs(strcmp('',strs))=[];
        if (strs{1}(1) == ';'), continue; end
        Reservoirs(j).('ID')=strs{1};        
        Reservoirs(j).('Head')=str2num(strs{2}); 
        pI=find(strcmpi(strs{1},idCoords));
        if ~isempty(pI)
            Reservoirs(j).X=XCoords(pI);
            Reservoirs(j).Y=YCoords(pI);
            Reservoirs(j).Geometry='Point';
        else
            Reservoirs(j).X=0;
            Reservoirs(j).Y=0;
            Reservoirs(j).Geometry='Point';
        end
        j=j+1;
    end
    %% Tanks
    if length(S.Tanks)<3
        Tanks(1).('ID')='';        
        Tanks(1).('Elevation')='';
        Tanks(1).('InitLevel')='';
        Tanks(1).('MinLevel')='';
        Tanks(1).('MaxLevel')='';
        Tanks(1).('Diameter')='';
        Tanks(1).('MinVolume')='';
        Tanks(1).('VolumeCurve')='';
        Tanks(1).X=0;
        Tanks(1).Y=0;
        Tanks(1).Geometry='Point';
    end
    j=1;
    for i=2:length(S.Tanks)
        strs=regexp(S.Tanks{i},'\s','split');
        strs(strcmp('',strs))=[];
        if (strs{1}(1) == ';'), continue; end
        Tanks(j).('ID')=strs{1};        
        Tanks(j).('Elevation')=str2num(strs{2}); 
        Tanks(j).('InitLevel')=str2num(strs{3});
        Tanks(j).('MinLevel')=str2num(strs{4});
        Tanks(j).('MaxLevel')=str2num(strs{5});
        Tanks(j).('Diameter')=str2num(strs{6});
        Tanks(j).('MinVolume')=str2num(strs{7});
        if length(strs)>7
            if (strs{8}(1) == ';'), strs{8}=''; end
            Tanks(j).('VolumeCurve')=strs{8};
        end
        pI=find(strcmpi(strs{1},idCoords));
        if ~isempty(pI)
            Tanks(j).X=XCoords(pI);
            Tanks(j).Y=YCoords(pI);
            Tanks(j).Geometry='Point';
        else
            Tanks(j).X=0;
            Tanks(j).Y=0;
            Tanks(j).Geometry='Point';
        end
        j=j+1;
    end
    %% Pipes
    j=1;
    for i=2:length(S.Pipes)
        strs=regexp(S.Pipes{i},'\s','split');
        strs(strcmp('',strs))=[];
        if (strs{1}(1) == ';'), continue; end
        Pipes(j).('ID')=strs{1};        
        Pipes(j).('NodeFrom')=strs{2};
        Pipes(j).('NodeTo')=strs{3};
        indN1 = find(strcmp(idCoords,strs{2}));
        indN2 = find(strcmp(idCoords,strs{3}));
        xv=[]; yv=[];
        if sum(strcmp(who,'idVertices'))
            indexV=find(strcmpi(strs{1},idVertices));
            if ~isempty(indexV)
                xv=Xvertices(indexV);
                yv=Yvertices(indexV);
            end
        end
        Pipes(j).X=[XCoords(indN1) xv XCoords(indN2)];
        Pipes(j).Y=[YCoords(indN1) yv YCoords(indN2)];
        Pipes(j).('Length')=str2num(strs{4});
        Pipes(j).('Diameter')=str2num(strs{5});
        Pipes(j).('Roughness')=str2num(strs{6});
        Pipes(j).('MinorLoss')=str2num(strs{7});
        Pipes(j).('Status')=strs{8};
        Pipes(j).Geometry='Line';   
        j=j+1;
    end
    pumpIndex=j;

    %% Pumps
    if length(S.Pumps)<3
        Pumps(1).('ID')='';        
        Pumps(1).('NodeFrom')='';
        Pumps(1).('NodeTo')='';
        Pumps(1).X=0;
        Pumps(1).Y=0;
        Pumps(1).Geometry='Point';
    end
    j=1;
    for i=2:length(S.Pumps)
        strs=regexp(S.Pumps{i},'\s','split');
        strs(strcmp('',strs))=[];
        if (strs{1}(1) == ';'), continue; end
        Pumps(j).('ID')=strs{1};        
        Pumps(j).('NodeFrom')=strs{2};
        Pumps(j).('NodeTo')=strs{3};

        l=4;
        for u=4:length(strs)
            if (strs{u}(1) == ';'), continue; end
            Pumps(j).(strs{l}) = strs{l+1}; 
            l=l+2;
            if (l>length(strs)), break; end
            if (strs{l}(1) == ';') && (l==length(strs)), break; end
            if (u+1==length(strs)), break; end
        end

        indN1 = find(strcmp(idCoords,strs{2}));
        indN2 = find(strcmp(idCoords,strs{3}));
        xv=[]; yv=[];
        if sum(strcmp(who,'idVertices'))
            indexV=find(strcmpi(strs{1},idVertices));
            if ~isempty(indexV)
                xv=Xvertices(indexV);
                yv=Yvertices(indexV);
            end
        end
        for pp=1:2
            if pp==1
                Pipes(pumpIndex).('ID')=[strs{1},'_pump1'];        
                Pipes(pumpIndex).('NodeFrom')=idCoords{indN1};
                Pipes(pumpIndex).('NodeTo')=Pipes(pumpIndex).('ID');
            Pipes(pumpIndex).X=[XCoords(indN1) sum([XCoords(indN1) XCoords(indN2)])/2];
            Pipes(pumpIndex).Y=[YCoords(indN1) sum([YCoords(indN1) YCoords(indN2)])/2];
            Pipes(pumpIndex).Geometry='Line';  
            end
            if pp==2
                Pipes(pumpIndex).('ID')=[strs{1},'_pump2'];        
                Pipes(pumpIndex).('NodeFrom')=Pipes(pumpIndex).('ID');
                Pipes(pumpIndex).('NodeTo')=idCoords{indN2};

            Pipes(pumpIndex).X=[XCoords(indN2) sum([XCoords(indN2) XCoords(indN1)])/2];
            Pipes(pumpIndex).Y=[YCoords(indN2) sum([YCoords(indN2) YCoords(indN1)])/2];
            Pipes(pumpIndex).Geometry='Line';  
            end
            Pipes(pumpIndex).('Length')=0;
            Pipes(pumpIndex).('Diameter')=0;
            Pipes(pumpIndex).('Roughness')=0;
            Pipes(pumpIndex).('MinorLoss')=0; 
            Pipes(pumpIndex).('Status')='Open';
            pumpIndex=pumpIndex+1;
        end

        Pumps(j).X=sum([XCoords(indN1) xv XCoords(indN2)])/2; 
        Pumps(j).Y=sum([YCoords(indN1) yv YCoords(indN2)])/2; 
        Pumps(j).Geometry='Point';   
        j=j+1;
    end
    valveIndex=pumpIndex;
    %% Valves
    if length(S.Valves)<3
        Valves(1).('ID')='';        
        Valves(1).('NodeFrom')='';
        Valves(1).('NodeTo')='';
        Valves(1).('Diameter')='';
        Valves(1).('Type')='';
        Valves(1).('Setting')='';
        Valves(1).('MinorLoss')='';
        Valves(1).X=0;
        Valves(1).Y=0;
        Valves(1).Geometry='Point';
    end
    j=1;
    for i=2:length(S.Valves)
        strs=regexp(S.Valves{i},'\s','split');
        strs(strcmp('',strs))=[];
        if (strs{1}(1) == ';'), continue; end
        Valves(j).('ID')=strs{1};        
        Valves(j).('NodeFrom')=strs{2};
        Valves(j).('NodeTo')=strs{3};

        Valves(j).('Diameter')=str2num(strs{4});
        Valves(j).('Type')=strs{5};
        Valves(j).('Setting')=str2num(strs{6});
        Valves(j).('MinorLoss')=str2num(strs{7});

        indN1 = find(strcmp(idCoords,strs{2}));
        indN2 = find(strcmp(idCoords,strs{3}));
        xv=[]; yv=[];
        if sum(strcmp(who,'idVertices'))
            indexV=find(strcmpi(strs{1},idVertices));
            if ~isempty(indexV)
                xv=Xvertices(indexV);
                yv=Yvertices(indexV);
            end
        end
        for pp=1:2
            if pp==1
                Pipes(valveIndex).('ID')=[strs{1},'_valve1'];        
                Pipes(valveIndex).('NodeFrom')=idCoords{indN1};
                Pipes(valveIndex).('NodeTo')=Pipes(valveIndex).('ID');
            Pipes(valveIndex).X=[XCoords(indN1) sum([XCoords(indN1) XCoords(indN2)])/2];
            Pipes(valveIndex).Y=[YCoords(indN1) sum([YCoords(indN1) YCoords(indN2)])/2];
            Pipes(valveIndex).Geometry='Line';  
            end
            if pp==2
                Pipes(valveIndex).('ID')=[strs{1},'_valve2'];        
                Pipes(valveIndex).('NodeFrom')=Pipes(valveIndex).('ID');
                Pipes(valveIndex).('NodeTo')=idCoords{indN2};

            Pipes(valveIndex).X=[XCoords(indN2) sum([XCoords(indN2) XCoords(indN1)])/2];
            Pipes(valveIndex).Y=[YCoords(indN2) sum([YCoords(indN2) YCoords(indN1)])/2];
            Pipes(valveIndex).Geometry='Line';  
            end
            Pipes(valveIndex).('Length')=0;
            Pipes(valveIndex).('Diameter')=0;
            Pipes(valveIndex).('Roughness')=0;
            Pipes(valveIndex).('MinorLoss')=0; 
            Pipes(valveIndex).('Status')='Open';
            valveIndex=valveIndex+1;
        end

        Valves(j).X=sum([XCoords(indN1) xv XCoords(indN2)])/2; 
        Valves(j).Y=sum([YCoords(indN1) yv YCoords(indN2)])/2; 
        Valves(j).Geometry='Point';   
        j=j+1;
    end
    shapewrite(Valves, [f,'/',f,'_valves.shp']);
    shapewrite(Pipes, [f,'/',f,'_pipes.shp']);
    shapewrite(Pumps, [f,'/',f,'_pumps.shp']);
    shapewrite(Tanks, [f,'/',f,'_tanks.shp']);
    shapewrite(Reservoirs, [f,'/',f,'_reservoirs.shp']);
    shapewrite(Junctions, [f,'/',f,'_junctions.shp']);

    for i=1:6
        if ~strcmpi(getFields{i},'demands')
            S=rmfield(S,getFields{i});
        end
    end
    getFields = fields(S);

    if sum(strcmpi(getFields,'report')) 
        if length(S.Report)<2 
            G(1).('Status')='No';
            G(1).('Summary')='No';
            G(1).('Page')='0';
            G.X=0;
            G.Y=0;
            G.Geometry='Point';
            shapewrite(G, [f,'/',f,'_REPORT.shp']);
            delete([f,'/',f,'_REPORT.shp']);
            delete([f,'/',f,'_REPORT.shx']);
        end
    end
    typeCurves='';newStrsRule='';diffChars='';conCnt=1;m=1;
    for j=1:length(getFields)
        if length(S.([getFields{j}]))
            u=1;clear G;
            cnt=length(S.([getFields{j}]));
            if cnt==1, cnt=2; end
            for i=2:cnt
                if length(S.([getFields{j}]))>1
                    strs=regexp(S.([getFields{j}]){i},'\s','split');
                    strs(strcmp('',strs))=[];
                    indexCurveType=find(strcmpi(d.TYPECURVE,strs{1}(2:end-1)));
                    if indexCurveType
                        typeCurves{u}=d.TYPECURVE{indexCurveType};continue;
                    else
                        if (strs{1}(1) == ';') && cnt>=2,
                            if cnt==2
                                strs=repmat({''},1,30);
                            else
                            continue,
                            end
                        end
                    end
                else
                   strs=repmat({''},1,30); 
                end
                if strcmpi(getFields{j},'demands')
                    G(u).('ID')=strs{1};        
                    G(u).('Demand')=strs{2}; 
                    G(u).('Pattern')=strs{3};
                end
                if strcmpi(getFields{j},'status')
                    G(u).('ID')=strs{1};        
                    G(u).('Status_Setting')=strs{2}; 
                end
                if strcmpi(getFields{j},'patterns')
                    G(u).('ID')=strs{1};    
                    st=cellstr(num2str(str2num(char(strs(2:end)))));
                    newStrsPat = cellfun(@(x) [x ' '], st, 'UniformOutput', false);
                    newStrsPat{end} = st{end};
                    G(u).('Pattern')=[newStrsPat{:}]; 
                end
                if strcmpi(getFields{j},'curves')
                    G(u).('ID')=strs{1};  
                    G(u).('X_Value')=strs{2}; 
                    G(u).('Y_Value')=strs{3}; 
                    if length(typeCurves)==u
                        G(u).('Type') = typeCurves{u};
                    else
                        G(u).('Type') = 'PUMP';
                    end
                end
                if strcmpi(getFields{j},'controls')
                    newStrsControl = cellfun(@(x) [x ' '], strs, 'UniformOutput', false);
                    newStrsControl=cell2mat(newStrsControl);
                    G(u).('Controls')=newStrsControl; 
                end
                if strcmpi(getFields{j},'rules')
                    if u==1; G(conCnt).('ID')=strs{2};end
                    if strcmpi(strs{1},'priority') || length(strs)>2
                        newStrsRule1 = cellfun(@(x) [x ' '], strs, 'UniformOutput', false);
                        new = cell2mat(newStrsRule1);
                        if u>2
                            diffChars = length(newStrsRule{1}) - length(new);
                            if diffChars<0
                                newStrsRule{1} = [newStrsRule{1} char(32*ones(1,-1*diffChars))];
                            end
                        end
                        if (isempty(diffChars) || diffChars==0)
                            newStrsRule{conCnt}(m,:)=new;
                        else
                            newStrsRule{conCnt}(m,:)=[new char(32*ones(1,diffChars))];
                        end
                        m=m+1;
                    elseif u>2 
                        if conCnt>1 || strcmpi(strs{1},'rule')
                            G(conCnt+1).('ID')=strs{2};
                        end
                        for t=1:size(newStrsRule{conCnt},1)
                            G(conCnt).(['Condition',num2str(t)])=newStrsRule{conCnt}(t,:);
                        end
                        G(conCnt).X=0;
                        G(conCnt).Y=0;
                        G(conCnt).Geometry='Point';
                        conCnt=conCnt+1;m=1;
                    end
                    if i==cnt
                        for t=1:size(newStrsRule{conCnt},1)
                            G(conCnt).(['Condition',num2str(t)])=newStrsRule{conCnt}(t,:);
                        end
                        G(conCnt).X=0;
                        G(conCnt).Y=0;
                        G(conCnt).Geometry='Point';
                    end
                end
                if strcmpi(getFields{j},'energy')
                    newStrsEnergy = cellfun(@(x) [x ' '], strs, 'UniformOutput', false);
                    newStrsEnergy=cell2mat(newStrsEnergy);
                    G(u).('Energy')=newStrsEnergy;        
                end
                if strcmpi(getFields{j},'emitters')
                    G(u).('JunctionID')=strs{1};        
                    G(u).('Coefficient')=strs{2};
                end
                if strcmpi(getFields{j},'quality')
                    G(u).('NodeID')=strs{1};        
                    G(u).('InitQual')=strs{2}; 
                end
                if strcmpi(getFields{j},'sources')
                    G(u).('NodeID')=strs{1};        
                    G(u).('Type')=strs{2}; 
                    G(u).('Strength')=strs{3};
                    G(u).('Pattern')=strs{4}; 
                end
                if strcmpi(getFields{j},'optreactions')
                    newStrsOptReac = cellfun(@(x) [x ' '], strs, 'UniformOutput', false);
                    newStrsOptReac=cell2mat(newStrsOptReac);
                    G(u).('Reactions')=newStrsOptReac; 
                end
                if strcmpi(getFields{j},'reactions')
                    G(u).('Type')=strs{1};        
                    G(u).('Pipe_Tank')=strs{2}; 
                    G(u).('Coefficient')=strs{3};
                end
                if strcmpi(getFields{j},'mixing')
                    G(u).('TankID')=strs{1};        
                    G(u).('Model')=strs{2}; 
                    stM='';
                    if length(strs)>2
                       stM = strs{3}; 
                    end
                    G(u).('Fraction')=stM;
                end
                if strcmpi(getFields{j},'times')
                    switch upper(strs{1})
                        case 'DURATION'
                            G.('Duration')=strs{2}; 
                        case 'HYDRAULIC'
                            G.('HydStep')=strs{3}; 
                        case 'QUALITY'
                            G.('QualStep')=strs{3}; 
                        case 'RULE'
                            G.('RuleStep')=strs{3}; 
                        case 'PATTERN'
                            if strcmpi(strs{2},'TIMESTEP')
                                G.('PatStep')=strs{3};
                            elseif strcmpi(strs{2},'START')
                                G.('PatStart')=strs{3};
                            end
                        case 'REPORT'
                            if strcmpi(strs{2},'TIMESTEP')
                                G.('RepStep')=strs{3};
                            elseif strcmpi(strs{2},'START')
                                G.('RepStart')=strs{3};
                            end
                        case 'START'
                            if strcmpi(strs{2},'CLOCKTIME')
                                mn = cellfun(@(x) [x ' '], strs(3:end), 'UniformOutput', false);
                                mn=cell2mat(mn);
                                G.('StartClock')=mn;
                            end
                        case 'STATISTIC'
                            G.('Statistic')=strs{2}; 
                    end
                    G.X=0;
                    G.Y=0;
                    G.Geometry='Point';
                end
                if strcmpi(getFields{j},'report')
                    switch upper(strs{1})
                        case 'PAGESIZE'
                            G.('PageSize')=strs{2}; 
                        case 'FILE'
                            G.('FileName')=strs{2}; 
                        case 'STATUS'
                            G.('Status')=strs{2}; 
                        case 'SUMMARY'
                            G.('Summary')=strs{2}; 
                        case 'ENERGY'
                            G.('Energy')=strs{2}; 
                        case 'NODES'
                            mnod = cellfun(@(x) [x ' '], strs(2:end), 'UniformOutput', false);
                            mnod=cell2mat(mnod);
                            G.('Nodes')=mnod;
                        case 'LINKS'
                            mlink = cellfun(@(x) [x ' '], strs(2:end), 'UniformOutput', false);
                            mlink=cell2mat(mlink);
                            G.('Links')=mlink;
                        otherwise
                            mvar = cellfun(@(x) [x ' '], strs(2:end), 'UniformOutput', false);
                            mvar=cell2mat(mvar);
                            if ~isempty(strs{1})
                                G.(strs{1})=mvar; 
                            end
                    end
                    G.X=0;
                    G.Y=0;
                    G.Geometry='Point';
                end
                if strcmpi(getFields{j},'options')
                    switch upper(strs{1})
                        case 'UNITS'
                            G.('Units')=strs{2}; 
                        case 'HYDRAULICS'
                            mhd = cellfun(@(x) [x ' '], strs(2:end), 'UniformOutput', false);
                            mhd=cell2mat(mhd);
                            G.('Hydraulics')=mhd; 
                        case 'QUALITY'
                            mst = cellfun(@(x) [x ' '], strs(2:end), 'UniformOutput', false);
                            mst=cell2mat(mst);
                            G.('Quality')=mst; 
                        case 'VISCOSITY'
                            G.('Viscosity')=strs{2}; 
                        case 'DIFFUSIVITY'
                            G.('Diffusivity')=strs{2}; 
                        case 'SPECIFIC'
                            G.('SpecGrav')=strs{3}; 
                        case 'TRIALS'
                            G.('Trials')=strs{2}; 
                        case 'HEADLOSS'
                            G.('Headloss')=strs{2}; 
                        case 'ACCURACY'
                            G.('Accuracy')=strs{2}; 
                        case 'UNBALANCED'
                            mstun = cellfun(@(x) [x ' '], strs(2:end), 'UniformOutput', false);
                            mstun=cell2mat(mstun);
                            G.('Unbalanced')=mstun; 
                        case 'PATTERN'
                            G.('PatternID')=strs{2};
                        case 'TOLERANCE'
                            G.('Tolerance')=strs{2};   
                        case 'MAP'
                            G.('Map')=strs{2};  
                        case 'DEMAND'
                            G.('DemMult')=strs{3};
                        case 'EMITTER'
                            G.('EmitExp')=strs{3};
                        case 'CHECKFREQ'
                            G.('CheckFreq')=strs{2};     
                        case 'MAXCHECK'
                            G.('MaxCheck')=strs{2};    
                        case 'DAMPLIMIT'
                            G.('DAMPLIMIT')=strs{2}; 
                        otherwise
                            mvar = cellfun(@(x) [x ' '], strs(2:end), 'UniformOutput', false);
                            mvar=cell2mat(mvar);
                            G.(strs{1})=mvar; 
                    end
                    G.X=0;
                    G.Y=0;
                    G.Geometry='Point';
                end
                if ~sum(strcmpi(getFields{j},{'rules','times','report','options'}))
                    G(u).X=0;
                    G(u).Y=0;
                    G(u).Geometry='Point';
                end
                u=u+1;
            end
            if strcmpi(getFields{j},'demands') && sum(strcmp(who,'JunctionsDemands'))
                if ~isempty(G(1).('ID'))
                    k=length(G)+1;
                    for lk=1:length(G)
                        indexD = find(strcmp(JunctionsID,G(lk).('ID')));
                        if ~isempty(indexD)
                            JunctionsID{indexD}='';  
                        end
                    end
                    for p1=1:length(JunctionsDemands)
                        if ~isempty(JunctionsID{p1})
                            G(k).('ID')=JunctionsID{p1};        
                            G(k).('Demand')=JunctionsDemands{p1}; 
                            G(k).('Pattern')=JunctionsPatterns{p1};
                            G(k).X=0;
                            G(k).Y=0;
                            G(k).Geometry='Point';
                            k=k+1;
                        end
                    end
                end
            end
            shapewrite(G,[f,'/',f,'_',upper(getFields{j}),'.shp']);
            delete([f,'/',f,'_',upper(getFields{j}),'.shp']);
            delete([f,'/',f,'_',upper(getFields{j}),'.shx']);
        end
    end
    d.BinClose;
%     msgbox('Operation Completed');
end
