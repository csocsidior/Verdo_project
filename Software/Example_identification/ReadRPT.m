clear all;

%Tom's version
% %fid = fopen('Samlet_slutmodel_2013_net_opdateret.rpt','r');
% fid = fopen('Samlet_slutmodel_2013_net_opdateret_ALT_V2V_CURVE.rpt','r');

comma2point_overwrite('example1_1_long.rpt')
fid = fopen('example1_1_long.rpt','r');
str = fgetl(fid);

%Tom's version 
% pattern_N = {'7568', '7564', '10000602', '2031', '2081', '410'};
% pattern_L = {'12328', '18336', '18878'};

pattern_M = {'JU5'};
pattern_N = {'TA2'};
pattern_L = {'PU2','PU3'};

nodal_demands = ones(0,length(pattern_M));
nodal_pressures = ones(0,length(pattern_N));
nd = [];
np = [];

link_flows = ones(0,length(pattern_L));
lf = [];

i = 0;
indices_M = [];
indices_N = [];
indices_L = [];
times = [];
linkflag = 0;
nodeflag = 0;
count = 0;
while(~feof(fid))
    if(strfind(str,'Node Results'))
        nodeflag = 1;
        linkflag = 0;
        count = 0;
        time_str = textscan(str,'%s\b%s\b%s\b%d:%d\b%s');
        times = [times,time_str{4}+time_str{5}/60];
    end
    
    if(strfind(str,'Link Results'))
        linkflag = 1;
        nodeflag = 0;
        count = 0;
        time_str = textscan(str,'%s\b%s\b%s\b%d:%d\b%s');
        times = [times,time_str{4}+time_str{5}/60];
    end
    
    if(nodeflag && (count > 4) && ~isempty(str))
        node = textscan(str,'%s\t%f\t%f\t%f\t%f \t%s');
        [loca,~] = ismember(pattern_M,node{1});
        if(sum(loca))
            if(length(indices_M) < length(pattern_M))
                indices_M = [indices_M,find(loca)];
            end
            nd = [nd node{2}];
            if(length(nd) == length(pattern_M))
                nodal_demands = [nodal_demands;nd];
                nd = [];
            end
        end
    end
    
    if(nodeflag && (count > 4) && ~isempty(str))
        node = textscan(str,'%s\t%f\t%f\t%f\t%f \t%s');
        [loca,~] = ismember(pattern_N,node{1});
        if(sum(loca))
            if(length(indices_N) < length(pattern_N))
                indices_N = [indices_N,find(loca)];
            end
            np = [np node{4}];
            if(length(np) == length(pattern_N))
                nodal_pressures = [nodal_pressures;np];
                np = [];
            end
        end
    end
    
    if(linkflag && (count > 4) && ~isempty(str))
        link = textscan(str,'%s\t%f\t%f\t%f\t%s\b%s');
        [loca,~] = ismember(pattern_L,link{1});
        if(sum(loca))
            if(length(indices_L) < length(pattern_L))
                indices_L = [indices_L,find(loca)];
            end
            lf = [lf link{2}];
            if(length(lf) == length(pattern_L))
                link_flows = [link_flows;lf];
                lf = [];
            end
        end
    end
    count = count + 1;
    str = fgetl(fid);
end

t=0:1:148; % Time vector
figure(1)
stairs(t,nodal_pressures(:,1),'LineWidth',1.2)
xlim([0 149])
title('Inlet pressure - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

figure(2)
stairs(t,link_flows(:,1),'LineWidth',1.2)
xlim([0 149])
title('Inlet pressure - $\bar{p}_{\mathcal{K},1}$','interpreter','latex')
xlabel('Time [h]','interpreter','latex');
ylabel('Pressure  [m]','interpreter','latex')

dk_1_long_mod1 = link_flows(:,1);
sigma_v0 = nodal_demands(:,1)/5;
sigma_long_mod1 = sigma_v0*40;
dk_2_long_mod1 = link_flows(:,2);
p_h_long_mod1 = nodal_pressures(:,1);

fclose(fid);

% if(length(indices_N) < length(pattern_N))
%     disp('Unrecognized nodes in pattern! Only the following nodes were available:')
%     disp(pattern_N(indices_N))
% end

pattern_N = pattern_N(indices_N);
pattern_L = pattern_L(indices_L);
%nodal_pressures = nodal_pressures(:,indices_N); %Reshuffle to fit order in pattern_N
%link_flows = link_flows(:,indices_L);
times = unique(times,'stable');

%Function for replacing commas with points
function    comma2point_overwrite( filespec )
        file    = memmapfile( filespec, 'writable', true );
        comma   = uint8(',');
        point   = uint8('.');
        file.Data( transpose( file.Data==comma) ) = point;
end
