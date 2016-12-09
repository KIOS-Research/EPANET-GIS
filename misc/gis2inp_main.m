function gis2inp_main(inpname,foldername)
    addpath(genpath(foldername));

    %%shapefiles-features
    shpJunctions = [foldername,'_junctions.shp'];
    shpPipes = [foldername,'_pipes.shp'];
    shpReservoirs = [foldername,'_reservoirs.shp'];
    shpTanks = [foldername,'_tanks.shp'];
    shpPumps = [foldername,'_pumps.shp'];
    shpValves = [foldername,'_valves.shp'];
    %%shapefiles-sections
    shpDemands = [foldername,'_DEMANDS.dbf'];
    shpStatus = [foldername,'_STATUS.dbf'];
    shpPatterns = [foldername,'_PATTERNS.dbf'];
    shpCurves = [foldername,'_CURVES.dbf'];
    shpControls = [foldername,'_CONTROLS.dbf'];
    shpRules = [foldername,'_RULES.dbf'];
    shpEnergy = [foldername,'_ENERGY.dbf'];
    shpEmitters = [foldername,'_EMITTERS.dbf'];
    shpQuality = [foldername,'_QUALITY.dbf'];
    shpSources = [foldername,'_SOURCES.dbf'];
    shpReactions = [foldername,'_REACTIONS.dbf'];
    shpOptReactions = [foldername,'_OPTREACTIONS.dbf'];
    shpMixing = [foldername,'_MIXING.dbf'];
    shpTimes = [foldername,'_TIMES.dbf'];
    shpReport = [foldername,'_REPORT.dbf'];
    shpOptions = [foldername,'_OPTIONS.dbf'];

    %%Junctions Shapefile
    Sjunctions = shaperead(shpJunctions);
    JunctionsFields = fields(Sjunctions);
    indexID=find(strcmpi(JunctionsFields,'ID'));
    indexElevation=find(strcmpi(JunctionsFields,'elevation'));
    indexDemands=find(cellfun(@(x) any(x(:)==1),regexpi(JunctionsFields,'\w*Demand\w*')));
    indexPatterns=find(cellfun(@(x) any(x(:)==1),regexpi(JunctionsFields,'\w*Pattern\w*')));
    for i=1:length(Sjunctions)
        NodeJunctionNameID{i} = Sjunctions(i).(JunctionsFields{indexID});
        NodeJunctionElevation(i) = Sjunctions(i).(JunctionsFields{indexElevation});
        for u=1:length(indexDemands)
            NodeJunctionDemand{u}(i) = Sjunctions(i).(JunctionsFields{indexDemands(u)});
            NodeJunctionPatternNameID{u}{i} = Sjunctions(i).(JunctionsFields{indexPatterns(u)});
        end
        NodeJunctionXcoord(i) = Sjunctions(i).X;
        NodeJunctionYcoord(i) = Sjunctions(i).Y;
    end

    %%Reservoirs Shapefile
    Sreservoirs = shaperead(shpReservoirs);
    ReservoirsFields = fields(Sreservoirs);
    indexID=find(strcmpi(ReservoirsFields,'ID'));
    indexHead=find(strcmpi(ReservoirsFields,'head'));
    for i=1:length(Sreservoirs)
        NodeReservoirsNameID{i} = Sreservoirs(i).(ReservoirsFields{indexID});
        if isempty(NodeReservoirsNameID{i}), break; end
        NodeReservoirsHead(i) = Sreservoirs(i).(ReservoirsFields{indexHead});
        NodeReservoirsXcoord(i) = Sreservoirs(i).X;
        NodeReservoirsYcoord(i) = Sreservoirs(i).Y;
    end

    %%Tanks Shapefile
    Stanks = shaperead(shpTanks);
    TanksFields = fields(Stanks);
    indexID=find(strcmpi(TanksFields,'ID'));
    indexEle=find(strcmpi(TanksFields,'ELEVATION'));
    indexInitLevel=find(strcmpi(TanksFields,'InitLevel'));
    indexMinLevel=find(strcmpi(TanksFields,'Minlevel'));
    indexMaxLevel=find(strcmpi(TanksFields,'Maxlevel'));
    indexDiameter=find(strcmpi(TanksFields,'Diameter'));
    indexMinVolume=find(strcmpi(TanksFields,'MinVolume'));
    indexVolumeCurve=find(strcmpi(TanksFields,'VolumeCurve'));
    for i=1:length(Stanks)
        NodeTanksNameID{i} = Stanks(i).(TanksFields{indexID});
        if isempty(NodeTanksNameID{i}), break; end
        NodeTanksElevation(i) = Stanks(i).(TanksFields{indexEle});
        NodeTanksInitLevel(i) = Stanks(i).(TanksFields{indexInitLevel});
        NodeTanksMinLevel(i) = Stanks(i).(TanksFields{indexMinLevel});
        NodeTanksMaxLevel(i) = Stanks(i).(TanksFields{indexMaxLevel});
        NodeTanksDiameter(i) = Stanks(i).(TanksFields{indexDiameter});
        NodeTanksMinVolume(i) = Stanks(i).(TanksFields{indexMinVolume});
        if ~isempty(indexVolumeCurve)
            NodeTanksVolumeCurve{i} = Stanks(i).(TanksFields{indexVolumeCurve});
        else
            NodeTanksVolumeCurve{i}='';
        end
        NodeTanksXcoord(i) = Stanks(i).X;
        NodeTanksYcoord(i) = Stanks(i).Y;
    end

    %%Pipes Shapefile
    Spipes = shaperead(shpPipes);
    PipesFields = fields(Spipes);
    indexID=find(strcmpi(PipesFields,'ID'));
    indexFrom=find(strcmpi(PipesFields,'NodeFrom'));
    indexTo=find(strcmpi(PipesFields,'NodeTo'));
    indexStatus=find(strcmpi(PipesFields,'Status'));
    indexLength=find(strcmpi(PipesFields,'Length'));
    indexDiameter=find(strcmpi(PipesFields,'Diameter'));
    indexRoughness=find(strcmpi(PipesFields,'Roughness'));
    indexMinor=find(strcmpi(PipesFields,'MinorLoss'));
    u=1;
    for i=1:length(Spipes)
        LinkPipeNameID{u} = Spipes(i).(PipesFields{indexID});
        NodeFromPipe{u} = Spipes(i).(PipesFields{indexFrom});
        NodeToPipe{u} = Spipes(i).(PipesFields{indexTo});
        if length(Spipes(i).X)>3
            idVERTICES{u} = LinkPipeNameID{u};
            verticesXcoord{u} = Spipes(i).X(2:end-2); %vertices
        end
        if length(Spipes(i).Y)>3
            idVERTICES{u} = LinkPipeNameID{u};
            verticesYcoord{u} = Spipes(i).Y(2:end-2);
        end
        if ~isempty(regexpi(LinkPipeNameID{u},'\w*_pump1\w*')), continue; end
        if ~isempty(regexpi(LinkPipeNameID{u},'\w*_pump2\w*')), continue; end
        if ~isempty(regexpi(LinkPipeNameID{u},'\w*_valve1\w*')), continue; end
        if ~isempty(regexpi(LinkPipeNameID{u},'\w*_valve2\w*')), continue; end
        LinkPipeStatus{u} = Spipes(i).(PipesFields{indexStatus}); 
        LinkPipeLength(u) = Spipes(i).(PipesFields{indexLength});
        LinkPipeDiameter(u) = Spipes(i).(PipesFields{indexDiameter});
        LinkPipeRoughness(u) = Spipes(i).(PipesFields{indexRoughness});
        LinkPipeMinor(u) = Spipes(i).(PipesFields{indexMinor});
        u=u+1;
    end

    %%Pumps Shapefile
    Spumps = shaperead(shpPumps);
    PumpsFields = fields(Spumps);
    indexID=find(strcmpi(PumpsFields,'ID'));
    indexFrom=find(strcmpi(PumpsFields,'NodeFrom'));
    indexTo=find(strcmpi(PumpsFields,'NodeTo'));
    indexHead=find(cellfun(@(x) any(x(:)==1),regexpi(PumpsFields,'\w*head\w*')));
    indexPower=find(cellfun(@(x) any(x(:)==1),regexpi(PumpsFields,'\w*power\w*')));
    indexPattern=find(cellfun(@(x) any(x(:)==1),regexpi(PumpsFields,'\w*pattern\w*')));
    indexSpeed=find(cellfun(@(x) any(x(:)==1),regexpi(PumpsFields,'\w*speed\w*')));
    LinkPumpHead=repmat({''},1,length(Spumps));
    LinkPumpPower=LinkPumpHead;
    LinkPumpPattern=LinkPumpPower;
    LinkPumpSpeed=LinkPumpPattern;
    for i=1:length(Spumps)
        LinkPumpNameID{i} = Spumps(i).(PumpsFields{indexID});
        if isempty(LinkPumpNameID{i}), break; end
        NodeFromPump{i} = Spumps(i).(PumpsFields{indexFrom});
        NodeToPump{i} = Spumps(i).(PumpsFields{indexTo});
        if ~isempty(indexHead), LinkPumpHead{i} = Spumps(i).(PumpsFields{indexHead}); end
        if ~isempty(indexPower), LinkPumpPower{i} = Spumps(i).(PumpsFields{indexPower}); end
        if ~isempty(indexPattern), LinkPumpPattern{i} = Spumps(i).(PumpsFields{indexPattern}); end
        if ~isempty(indexSpeed), LinkPumpSpeed{i} = Spumps(i).(PumpsFields{indexSpeed}); end
        LinkPumpXcoord(i) = Spumps(i).X;
        LinkPumpYcoord(i) = Spumps(i).Y;
    end

    %%Valves Shapefile
    Svalves = shaperead(shpValves);
    ValvesFields = fields(Svalves);
    indexID=find(strcmpi(ValvesFields,'ID'));
    indexFrom=find(strcmpi(ValvesFields,'NodeFrom'));
    indexTo=find(strcmpi(ValvesFields,'NodeTo'));
    indexDiameter=find(strcmpi(ValvesFields,'Diameter'));
    indexSetting=find(strcmpi(ValvesFields,'Setting'));
    indexType=find(strcmpi(ValvesFields,'Type'));
    indexMinorLoss=find(strcmpi(ValvesFields,'MinorLoss'));
    for i=1:length(Svalves)
        LinkValveNameID{i} = Svalves(i).(ValvesFields{indexID});
        if isempty(LinkValveNameID{i}), break; end
        NodeFromValve{i} = Svalves(i).(ValvesFields{indexFrom});
        NodeToValve{i} = Svalves(i).(ValvesFields{indexTo});
        LinkValveDiameter(i) = Svalves(i).(ValvesFields{indexDiameter});
        LinkValveSetting(i) = Svalves(i).(ValvesFields{indexSetting});
        LinkValveMinorLoss(i) = Svalves(i).(ValvesFields{indexMinorLoss});
        LinkValveType{i} = Svalves(i).(ValvesFields{indexType});
        LinkValveXcoord(i) = Svalves(i).X;
        LinkValveYcoord(i) = Svalves(i).Y;
    end


    %%Sections
    %%DEMANDS
    c=which(shpDemands);
    if isempty(c)
        idDEMANDS{1} = '';
        dDEMANDS{1} = '';
        patDEMANDS{1} = '';
    else
        [Sdemands,DemandsFields] = dbfread(shpDemands);
        for i=1:size(Sdemands,1)
            idDEMANDS{i} = Sdemands{i,1};
            dDEMANDS{i} = Sdemands{i,2};
            patDEMANDS{i} = Sdemands{i,3};
        end
    end
    %%STATUS
    c=which(shpStatus);
    if isempty(c)
        idSTATUS{1} = '';
        statSetting{1} = '';
    else
        [Sstatus,StatusFields] = dbfread(shpStatus);
        for i=1:size(Sstatus,1)
            idSTATUS{i} = Sstatus{i,1};
            statSetting{i} = Sstatus{i,2};
        end
    end
    %%PATTERNS
    c=which(shpPatterns);
    if isempty(c)
        idPATTERNS{1} = '';
        PATTERNS{1} = '';
    else
        [Spatterns,PatternsFields] = dbfread(shpPatterns);
        for i=1:size(Spatterns,1)
            idPATTERNS{i} = Spatterns{i,1};
            PATTERNS{i} = Spatterns{i,2};
        end
    end
    %%CURVES
    c=which(shpCurves);
    if isempty(c)
        idCURVES{1} = '';
        xCURVES{1} = '';
        yCURVES{1} = '';
        typeCURVES{1} = '';
        indexCURVES=0;
    else
        [Scurves,CurvesFields] = dbfread(shpCurves);
        for i=1:size(Scurves,1)
            idCURVES{i} = Scurves{i,1};
            xCURVES{i} = Scurves{i,2};
            yCURVES{i} = Scurves{i,3};
            typeCURVES{i} = Scurves{i,4};
        end
        uniqCURVES = unique(idCURVES);
        for i=1:length(uniqCURVES)
            index = find(strcmp(idCURVES, uniqCURVES{i}));
            indexCURVES(i)=index(1);
        end
    end
    %%CONTROLS
    c=which(shpControls);
    if isempty(c)
        CONTROLS{1} = '';
    else
        [Scontrols,ControlsFields] = dbfread(shpControls);
        for i=1:size(Scontrols,1)
            CONTROLS{i} = Scontrols{i,1};
        end
    end
    %%RULES
    c=which(shpRules);
    if isempty(c)
        idRULES{1} = '';
        RULES{1} = '';
    else
        [Srules,RulesFields] = dbfread(shpRules);
        for i=1:size(Srules,1)
            idRULES{i} = Srules{i,1};m=1;
            for u=2:size(Srules,2)
                RULES{i}{m} = Srules{i,u};m=m+1;
            end
        end
    end
    %%ENERGY
    c=which(shpEnergy);
    if isempty(c)
        ENERGY{1} = 'Global Efficiency  	75'; 
        ENERGY{2} = 'Global Price       	0.0'; 
        ENERGY{3} = 'Demand Charge      	0.0'; 
    else
        [Senergy,EnergyFields] = dbfread(shpEnergy);
        for i=1:size(Senergy,1)
            ENERGY{i} = Senergy{i,1};
        end
    end
    %%EMITTERS
    c=which(shpEmitters);
    if isempty(c)
        idEMITTERS{1} = ''; 
        coeffEMITTERS{1} = ''; 
    else
        [Semitters,EmittersFields] = dbfread(shpEmitters);
        for i=1:size(Semitters,1)
            idEMITTERS{i} = Semitters{i,1};
            coeffEMITTERS{i} = Semitters{i,1};
        end
    end
    %%QUALITY
    c=which(shpQuality);
    if isempty(c)
        idQUALITY{1} = ''; 
        initQUALITY{1} = ''; 
    else
        [Squality,QualityFields] = dbfread(shpQuality);
        for i=1:size(Squality,1)
            idQUALITY{i} = Squality{i,1};
            initQUALITY{i} = Squality{i,2};
        end
    end
    %%SOURCES
    c=which(shpQuality);
    if isempty(c)
        idSOURCES{1} = ''; 
        typeSOURCES{1} = ''; 
        strengthSOURCES{1} = ''; 
        patternSOURCES{1} = ''; 
    else
        [Ssources,SourcesFields] = dbfread(shpSources);
        for i=1:size(Ssources,1)
            idSOURCES{i} = Ssources{i,1};
            typeSOURCES{i} = Ssources{i,2};
            strengthSOURCES{i} = Ssources{i,3};
            patternSOURCES{i} = Ssources{i,4};
        end
    end
    %%REACTIONS
    c=which(shpReactions);
    if isempty(c)
        typeREACTIONS{1} = ''; 
        ptankREACTIONS{1} = ''; 
        coeffREACTIONS{1} = ''; 
    else
        [Sreactions,ReactionsFields] = dbfread(shpReactions);
        for i=1:size(Sreactions,1)
            typeREACTIONS{i} = Sreactions{i,1};
            ptankREACTIONS{i} = Sreactions{i,2};
            coeffREACTIONS{i} = Sreactions{i,3};
        end
    end
    %%optREACTIONS
    c=which(shpOptReactions);
    if isempty(c)
        OPTREACTIONS{1} = ''; 
    else
        [Soptreactions,OptReactionsFields] = dbfread(shpOptReactions);
        for i=1:size(Soptreactions,1)
            OPTREACTIONS{i} = Soptreactions{i,1};
        end
    end
    %%MIXING
    c=which(shpMixing);
    if isempty(c)
        idMIXING{1} = ''; 
        modelMIXING{1} = ''; 
        fractionMIXING{1} = ''; 
    else
        [Smixing,MixingFields] = dbfread(shpMixing);
        for i=1:size(Smixing,1)
            idMIXING{i} = Smixing{i,1};
            modelMIXING{i} = Smixing{i,2};
            fractionMIXING{i} = Smixing{i,3};
        end
    end
    %%TIMES
    c=which(shpTimes);
    if isempty(c)
        TIMES{1} = 'Duration           	24:00';
        TIMES{2} = 'Hydraulic Timestep 	1:00'; 
        TIMES{3} = 'Quality Timestep   	0:05'; 
        TIMES{4} = 'Pattern Timestep   	2:00'; 
        TIMES{5} = 'Pattern Start      	0:00';
        TIMES{6} = 'Report Timestep    	1:00'; 
        TIMES{7} = 'Report Start       	0:00'; 
        TIMES{8} = 'Start ClockTime    	12 am';
        TIMES{9} = 'Statistic          	None';
    else
        [Stimes,TimesFields] = dbfread(shpTimes);
        for i=1:size(Stimes,2)
            switch lower(TimesFields{i})
                case 'duration'
                    TIMES{i} = ['DURATION ',Stimes{i}];
                case 'hydstep'
                    TIMES{i} = ['HYDRAULIC TIMESTEP ',Stimes{i}];
                case 'qualstep'
                    TIMES{i} = ['QUALITY TIMESTEP ',Stimes{i}];
                case 'rulestep'
                    TIMES{i} = ['RULE TIMESTEP ',Stimes{i}];
                case 'patstep'
                    TIMES{i} = ['PATTERN TIMESTEP ',Stimes{i}];
                case 'patstart'
                    TIMES{i} = ['PATTERN START ',Stimes{i}];
                case 'repstep'
                    TIMES{i} = ['REPORT TIMESTEP ',Stimes{i}];
                case 'repstart'
                    TIMES{i} = ['REPORT START ',Stimes{i}];
                case 'startclock'
                    TIMES{i} = ['START CLOCKTIME ',Stimes{i}];
                case 'statistic'
                    TIMES{i} = ['STATISTIC ',Stimes{i}];
            end
        end
    end
    %%REPORT
    c=which(shpReport);
    if isempty(c)
        REPORT{1} = 'Status             	Yes';
        REPORT{2} = 'Summary            	No'; 
        REPORT{3} = 'Page               	0'; 
    else
        [Sreport,ReportFields] = dbfread(shpReport);
        for i=1:size(Sreport,2)
            REPORT{i} = [ReportFields{i},' ',Sreport{i}];
        end
    end
    %%OPTIONS
    c=which(shpOptions);
    if isempty(c)
        OPTIONS{1} = 'Units GPM';
        OPTIONS{2} = 'Headloss H-W'; 
    else
        [Soptions,OptionsFields] = dbfread(shpOptions);
        for i=1:size(Soptions,2)
            if ~sum(strcmpi(OptionsFields{i},{'DemMult','EmitExp','SpecGrav'}))
                OPTIONS{i} = [OptionsFields{i},' ',Soptions{i}];
            else
                switch lower(OptionsFields{i})
                    case 'specgrav'
                        OPTIONS{i} = ['SPECIFIC GRAVITY ',Soptions{i}];
                    case 'demmult'
                        OPTIONS{i} = ['DEMAND MULTIPLIER ',Soptions{i}];
                    case 'emitexp'
                        OPTIONS{i} = ['EMITTER EXPONENT ',Soptions{i}];
                end
            end
        end
    end


    %%
    fid = fopen(inpname,'w');
    fprintf(fid,'[TITLE]');fprintf(fid,'\n');
    fprintf(fid,'[JUNCTIONS]');fprintf(fid,'\n');
    for i=1:length(NodeJunctionNameID)
        fprintf(fid,[NodeJunctionNameID{i},' ',num2str(NodeJunctionElevation(i))]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[RESERVOIRS]');fprintf(fid,'\n');
    for i=1:length(NodeReservoirsNameID)
        if isempty(NodeReservoirsNameID{i}), break; end
        fprintf(fid,[NodeReservoirsNameID{i},' ',num2str(NodeReservoirsHead(i))]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[TANKS]');fprintf(fid,'\n');
    for i=1:length(NodeTanksNameID)
        if isempty(NodeTanksNameID{i}), break; end
        fprintf(fid,[NodeTanksNameID{i},' ',num2str(NodeTanksElevation(i)),...
        ' ',num2str(NodeTanksInitLevel(i)),' ',num2str(NodeTanksMinLevel(i)),...
        ' ',num2str(NodeTanksMaxLevel(i)),' ',num2str(NodeTanksDiameter(i)),...
        ' ',num2str(NodeTanksMinVolume(i)),' ',NodeTanksVolumeCurve{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[PIPES]');fprintf(fid,'\n');
    for i=1:length(LinkPipeStatus)
        fprintf(fid,[LinkPipeNameID{i},' ',NodeFromPipe{i},' ',NodeToPipe{i}...
        ' ',num2str(LinkPipeLength(i)),' ',num2str(LinkPipeDiameter(i)),...
        ' ',num2str(LinkPipeRoughness(i)),' ',num2str(LinkPipeMinor(i)),...
        ' ',LinkPipeStatus{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[PUMPS]');fprintf(fid,'\n');
    for i=1:length(LinkPumpNameID)
        if isempty(LinkPumpNameID{i}), break; end
        lineP = [LinkPumpNameID{i},' ',NodeFromPump{i},' ',NodeToPump{i}];
        if ~isempty(LinkPumpHead{i})
            lineP = [lineP ' HEAD ' LinkPumpHead{i}];
        end
        if ~isempty(LinkPumpSpeed{i})
            lineP = [lineP ' SPEED ' LinkPumpSpeed{i}];
        end
        if ~isempty(LinkPumpPattern{i})
            lineP = [lineP ' PATTERN ' LinkPumpPattern{i}];
        end
        if ~isempty(LinkPumpPower{i})
            lineP = [lineP ' POWER ' LinkPumpPower{i}];
        end
        fprintf(fid,lineP);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[VALVES]');fprintf(fid,'\n');
    for i=1:length(LinkValveNameID)
        if isempty(LinkValveNameID{i}), break; end
        fprintf(fid,[LinkValveNameID{i},' ',NodeFromValve{i},' ',NodeToValve{i}...
        ' ',num2str(LinkValveDiameter(i)),' ',LinkValveType{i},...
        ' ',num2str(LinkValveSetting(i)),' ',num2str(LinkValveMinorLoss(i))]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[DEMANDS]');fprintf(fid,'\n');
    for i=1:length(idDEMANDS)
        fprintf(fid,[idDEMANDS{i},' ',num2str(dDEMANDS{i}),...
        ' ',num2str(patDEMANDS{i})]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[STATUS]');fprintf(fid,'\n');
    for i=1:length(idSTATUS)
        fprintf(fid,[idSTATUS{i},' ',statSetting{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[PATTERNS]');fprintf(fid,'\n');
    for i=1:length(idPATTERNS)
        fprintf(fid,[idPATTERNS{i},' ',PATTERNS{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[CURVES]');fprintf(fid,'\n');
    for i=1:length(idCURVES)
        if sum(i==indexCURVES)
            fprintf(fid,[';',typeCURVES{i}]);fprintf(fid,'\n'); 
        end
        fprintf(fid,[idCURVES{i},' ',num2str(xCURVES{i}),...
        ' ',num2str(yCURVES{i})]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[CONTROLS]');fprintf(fid,'\n');
    for i=1:length(CONTROLS)
        fprintf(fid,[CONTROLS{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[RULES]');fprintf(fid,'\n');
    for i=1:length(idRULES)
        if isempty(idRULES{i}), break; end
        fprintf(fid,['RULE ',idRULES{i}]);fprintf(fid,'\n');
        for u=1:length(RULES{i})
            fprintf(fid,[RULES{i}{u}]);
            fprintf(fid,'\n');
        end
    end
    fprintf(fid,'[ENERGY]');fprintf(fid,'\n');
    for i=1:length(ENERGY)
        fprintf(fid,[ENERGY{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[EMITTERS]');fprintf(fid,'\n');
    for i=1:length(idEMITTERS)
        fprintf(fid,[idEMITTERS{i},' ',num2str(coeffEMITTERS{i})]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[QUALITY]');fprintf(fid,'\n');
    for i=1:length(idQUALITY)
        fprintf(fid,[idQUALITY{i},' ',num2str(initQUALITY{i})]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[SOURCES]');fprintf(fid,'\n');
    for i=1:length(idSOURCES)
        fprintf(fid,[idSOURCES{i},' ',typeSOURCES{i},' ',...
        num2str(strengthSOURCES{i}),' ',patternSOURCES{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[REACTIONS]');fprintf(fid,'\n');
    for i=1:length(typeREACTIONS)
        fprintf(fid,[typeREACTIONS{i},' ',ptankREACTIONS{i},' ',...
        num2str(coeffREACTIONS{i})]);
        fprintf(fid,'\n'); 
    end
    for i=1:length(OPTREACTIONS)
        fprintf(fid,[OPTREACTIONS{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[MIXING]');fprintf(fid,'\n');
    for i=1:length(idMIXING)
        fprintf(fid,[idMIXING{i},' ',modelMIXING{i},' ',...
        num2str(fractionMIXING{i})]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[TIMES]');fprintf(fid,'\n');
    for i=1:length(TIMES)
        fprintf(fid,[TIMES{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[REPORT]');fprintf(fid,'\n');
    for i=1:length(REPORT)
        fprintf(fid,[REPORT{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[OPTIONS]');fprintf(fid,'\n');
    for i=1:length(OPTIONS)
        fprintf(fid,[OPTIONS{i}]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'\n');
    fprintf(fid,'[COORDINATES]');fprintf(fid,'\n');
    for i=1:length(NodeJunctionNameID)
        fprintf(fid,[NodeJunctionNameID{i},' ',num2str(NodeJunctionXcoord(i)),...
        ' ',num2str(NodeJunctionYcoord(i))]);
        fprintf(fid,'\n'); 
    end
    for i=1:length(NodeReservoirsNameID) 
        fprintf(fid,[NodeReservoirsNameID{i},' ',num2str(NodeReservoirsXcoord(i)),...
        ' ',num2str(NodeReservoirsYcoord(i))]);
        fprintf(fid,'\n'); 
    end
    for i=1:length(NodeTanksNameID) 
        fprintf(fid,[NodeTanksNameID{i},' ',num2str(NodeTanksXcoord(i)),...
        ' ',num2str(NodeTanksYcoord(i))]);
        fprintf(fid,'\n'); 
    end
    fprintf(fid,'[VERTICES]');fprintf(fid,'\n');
    if sum(strcmp(who,'idVERTICES'))
        idVERTICES=idVERTICES(~cellfun('isempty',idVERTICES));
        verticesXcoord=verticesXcoord(~cellfun('isempty',verticesXcoord));
        verticesYcoord=verticesYcoord(~cellfun('isempty',verticesYcoord));
        for i=1:length(idVERTICES)
            for u=1:length(verticesXcoord{i})
                fprintf(fid,[idVERTICES{i},' ',num2str(verticesXcoord{i}(u)),...
                ' ',num2str(verticesYcoord{i}(u))]);
                fprintf(fid,'\n'); 
            end
            fprintf(fid,'\n'); 
        end
    end
    fprintf(fid,'[LABELS]');fprintf(fid,'\n');
    fprintf(fid,'[BACKDROP]');fprintf(fid,'\n');
    fprintf(fid,'[END]');
    fclose all;
%     msgbox('Operation Completed');
end
