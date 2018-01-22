%fid = fopen('Samlet_slutmodel_2013_net_opdateret.rpt','r');
fid = fopen('Samlet_slutmodel_2013_net_opdateret_ALT_V2V_CURVE.rpt','r');
str = fgetl(fid);

%pattern_N = {'189','190'};
%pattern_L = {'69','72'};

pattern_N = {'7568', '7564', '10000602', '2031', '2081', '410'};
pattern_L = {'12328', '18336', '18878'};

nodal_demands = ones(0,length(pattern_N));
nodal_pressures = ones(0,length(pattern_N));
nd = [];
np = [];

link_flows = ones(0,length(pattern_L));
lf = [];

i = 0;
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
        node = textscan(str,'%s\t%f\t%f\t%f\t%f');
        [loca,~] = ismember(pattern_N,node{1});
        if(sum(loca))
            if(length(indices_N) < length(pattern_N))
                indices_N = [indices_N,find(loca)];
            end
            nd = [nd node{2}];
            np = [np node{4}];
            if(length(nd) == length(pattern_N))
                nodal_demands = [nodal_demands;nd];
                nodal_pressures = [nodal_pressures;np];
                nd = [];
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


fclose(fid);

% if(length(indices_N) < length(pattern_N))
%     disp('Unrecognized nodes in pattern! Only the following nodes were available:')
%     disp(pattern_N(indices_N))
% end

pattern_N = pattern_N(indices_N);
pattern_L = pattern_L(indices_L);
%nodal_demands = nodal_demands(:,indices_N); %Reshuffle to fit order in pattern_N
%link_flows = link_flows(:,indices_L);
times = unique(times,'stable');