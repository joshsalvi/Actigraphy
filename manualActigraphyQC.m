function manualActigraphyQC()

    dir0 = input('Which directory? ');
    pp = 1;
    pp0 = 0;
    
    while pp == 1
        inputStr = input('Event transition label: ');
        trange = input('Time window (sec): '); 
    
        if dir0(end) ~= '/'
            dir0 = [dir0 '/'];
        end
        
        files = dir(dir0);
        
        if pp0 == 0
            % Import Data
            disp('Importing...')
            for p0 = 1:length(files)
                try
                    if files(p0).name(end-3:end) == '.csv'
                        disp(files(p0).name)
                        if files(p0).name(end-4) == 'c'
                            disp('acc')
                            data = importdata([dir0 files(p0).name]); acc = data.data;
                        elseif files(p0).name(end-4) == 'p'
                            disp('temp')
                            data = importdata([dir0 files(p0).name]); temp = data.data;
                        elseif files(p0).name(end-4) == 'a'
                            disp('eda')
                            data = importdata([dir0 files(p0).name]); eda = data.data;
                        end
                    end
                end
            end
            pp0 = 1; clear p0
            disp('Importing complete.')
        end
        
        qrc = find(inputStr == ':'); qrc = qrc(end);
        inputStr2 = strsplit(inputStr,' '); inputStr2 = strsplit(inputStr2{4},':');
        lab1 = inputStr2{1}(1); lab2 = inputStr2{2}(1);
        
        formatIn = 'yyyy-mm-dd HH:MM:SS';
        datenum_ms = 86400e3*(datenum(inputStr(7:25),formatIn)-719529);

        qa = findnearest(acc(:,1),datenum_ms);
        qt = findnearest(temp(:,1),datenum_ms);
        qe = findnearest(eda(:,1),datenum_ms);

        Fsa = round(1/((acc(2,1)-acc(1,1))*1e-3));
        Fst = round(1/((temp(2,1)-temp(1,1))*1e-3));
        Fse = round(1/((eda(2,1)-eda(1,1))*1e-3));

        rga = trange * Fsa;
        rgt = trange * Fst;
        rge = trange * Fse;

        displ = sqrt(gradient(acc(:,2)).^2 + gradient(acc(:,3)).^2 + gradient(acc(:,4)).^2);
        vel = gradient(displ);
        velRS = sqrt(vel.^2);
        accel = gradient(vel);
        accelRS = sqrt(accel.^2);

        close all;h0 = figure;

        subplot(2,2,1);
        rectangle('Position',[0 1.05*min(vel(qa-rga:qa+rga)) acc(qa+rga,1)/1e3-acc(qa,1)/1e3 1.05*max(vel(qa-rga:qa+rga))-1.05*min(vel(qa-rga:qa+rga))],'FaceColor',[.7 .7 .7],'EdgeColor',[0 0 0])
        hold on; plot(acc(qa-rga:qa+rga,1)/1e3 - acc(qa,1)/1e3, vel(qa-rga:qa+rga));
        plot(zeros(1,100),linspace(1.05*min(vel(qa-rga:qa+rga)), 1.05*max(vel(qa-rga:qa+rga)), 100), 'k--');
        axis tight; box on;
        text(trange/2,max(vel(qa-rga:qa+rga)),0,lab2);
        text(-trange/2,max(vel(qa-rga:qa+rga)),0,lab1);
        xlabel('t_r_e_l (sec)'); ylabel('vel')
        title(inputStr);

        subplot(2,2,2);
        rectangle('Position',[0 1.05*min(velRS(qa-rga:qa+rga)) acc(qa+rga,1)/1e3-acc(qa,1)/1e3 1.05*max(velRS(qa-rga:qa+rga))-1.05*min(velRS(qa-rga:qa+rga))],'FaceColor',[.7 .7 .7],'EdgeColor',[0 0 0])
        hold on; plot(acc(qa-rga:qa+rga,1)/1e3 - acc(qa,1)/1e3, velRS(qa-rga:qa+rga));
        plot(zeros(1,100),linspace(1.05*min(velRS(qa-rga:qa+rga)), 1.05*max(velRS(qa-rga:qa+rga)), 100), 'k--');
        axis tight; box on;
        text(trange/2,max(velRS(qa-rga:qa+rga)),0,lab2);
        text(-trange/2,max(velRS(qa-rga:qa+rga)),0,lab1);
        xlabel('t_r_e_l (sec)'); ylabel('vel_R_S')

        subplot(2,2,3);
        rectangle('Position',[0 min(temp(qt-rgt:qt+rgt,2)) temp(qt+rgt,1)/1e3-temp(qt,1)/1e3 1.05*max(temp(qt-rgt:qt+rgt,2))-1.05*min(temp(qt-rgt:qt+rgt,2))],'FaceColor',[.7 .7 .7],'EdgeColor',[0 0 0])
        hold on; plot(temp(qt-rgt:qt+rgt,1)/1e3 - temp(qt,1)/1e3, temp(qt-rgt:qt+rgt,2));
        plot(zeros(1,100),linspace(min(temp(qt-rgt:qt+rgt,2)), max(temp(qt-rgt:qt+rgt,2)), 100), 'k--');
        axis tight; box on;
        text(trange/2,max(temp(qt-rgt:qt+rgt,2)),0,lab2);
        text(-trange/2,max(temp(qt-rgt:qt+rgt,2)),0,lab1);
        xlabel('t_r_e_l (sec)'); ylabel('temp')

        subplot(2,2,4);
        rectangle('Position',[0 min(eda(qe-rge:qe+rge,2)) eda(qe+rge,1)/1e3-eda(qe,1)/1e3 1.05*max(eda(qe-rge:qe+rge,2))-1.05*min(eda(qe-rge:qe+rge,2))],'FaceColor',[.7 .7 .7],'EdgeColor',[0 0 0])
        hold on; plot(eda(qe-rge:qe+rge,1)/1e3 - eda(qe,1)/1e3, eda(qe-rge:qe+rge,2));
        plot(zeros(1,100),linspace(min(eda(qe-rge:qe+rge,2)), max(eda(qe-rge:qe+rge,2)), 100), 'k--');
        axis tight; box on;
        text(trange/2,max(eda(qe-rge:qe+rge,2)),0,lab2);
        text(-trange/2,max(eda(qe-rge:qe+rge,2)),0,lab1);
        xlabel('t_r_e_l (sec)'); ylabel('eda')
        
        savefigYN = input('Save figure? (1=yes): ');
        if savefigYN == 1
            try
                warning off; mkdir(dir0,'figures');
            end
            savefig(h0, [dir0 '/figures/' inputStr '-' num2str(trange) 'sec' '.fig']);
            saveas(h0, [dir0 '/figures/' inputStr '-' num2str(trange) 'sec' '.eps']);
        end
        
        pp = input('Repeat for another time window? (1=yes): ');
        
    end
end

function [r,c,V] = findnearest(srchvalue,srcharray,bias)

    if nargin<2
        error('Need two inputs: Search value and search array')
    elseif nargin<3
        bias = 0;
    end

    % find the differences
    srcharray = srcharray-srchvalue;

    if bias == -1   % only choose values <= to the search value
        srcharray(srcharray>0) =inf;
    elseif bias == 1  % only choose values >= to the search value
        srcharray(srcharray<0) =inf;
    end

    % give the correct output
    if nargout==1 | nargout==0
        if all(isinf(srcharray(:)))
            r = [];
        else
            r = find(abs(srcharray)==min(abs(srcharray(:))));
        end 
    elseif nargout>1
        if all(isinf(srcharray(:)))
            r = [];c=[];
        else
            [r,c] = find(abs(srcharray)==min(abs(srcharray(:))));
        end
        if nargout==3
            V = srcharray(r,c)+srchvalue;
        end
    end
end
