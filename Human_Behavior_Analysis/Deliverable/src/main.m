%% Reset all
clc; close all; clear;

%% Move to working directory
tmp = matlab.desktop.editor.getActive;
cd(fileparts(tmp.Filename));
addpath(genpath('./data'));

%% Tests
[X_train(1).data,Y_train(1).data,tagset_train(1).data]=load_file('P1_1_1_p19');
[X_train(2).data,Y_train(2).data,tagset_train(2).data]=load_file('P1_1_2_p06');
[X_train(3).data,Y_train(3).data,tagset_train(3).data]=load_file('P1_1_3_p19');
[X_train(4).data,Y_train(4).data,tagset_train(4).data]=load_file('P1_1_4_p06');
[X_train(5).data,Y_train(5).data,tagset_train(5).data]=load_file('P1_1_5_p19');
[X_train(6).data,Y_train(6).data,tagset_train(6).data]=load_file('P1_1_6_p06');
[X_train(7).data,Y_train(7).data,tagset_train(7).data]=load_file('P1_1_7_p22');
[X_train(8).data,Y_train(8).data,tagset_train(8).data]=load_file('P1_1_8_p06');
[X_train(9).data,Y_train(9).data,tagset_train(9).data]=load_file('P1_1_9_p21');
[X_train(10).data,Y_train(10).data,tagset_train(10).data]=load_file('P1_1_10_p19');
[X_train(11).data,Y_train(11).data,tagset_train(11).data]=load_file('P1_1_11_p21');
[X_train(12).data,Y_train(12).data,tagset_train(12).data]=load_file('P1_1_12_p19');

aux_tra = [];
data = [];
labels = [];
index = 0;
for j=1:size(X_train,2)
    [gestures,numG] = gestureCuts( X_train(j).data,Y_train(j).data);
    X_trai=X_train(j).data;
    X_tra = [];
    for i=1:size(X_trai,1)
        for k=1:size(X_trai,2)/4
            for z=1:3
                X_tra(i,k,z)=X_trai(i,z+(k-1)*4);
            end
        end
    end
    for i=1:numG
         data(index+i).indexes=X_tra(gestures(i,2):gestures(i,3),:,:);
         data(index+i).label=gestures(i,1);
         if(~ismember(gestures(i,1),labels))
             labels(size(labels,2)+1)=gestures(i,1);
         end
    end
    index = index+i;
end

confusion = zeros(size(X_train,2),size(X_train,2));
k = 1;
for i=1:size(data,2)
    if size(data(i).indexes,2)>0
        test = data(i);
        train = data(~ismember((1:size(data,2)),i));
        nn = [];
        ind1 = find(ismember(labels,test.label));
        for j=1:size(train,2)
            if size(train(j).indexes,2)>0
                d = dtw(test.indexes,train(j).indexes);
                changed = 0;
                prev.label = train(j).label;
                prev.dist = d;         
                for n=1:max(size(nn,2),k)
                    if size(nn,2)<n
                        nn(n).dist=prev.dist;
                        nn(n).label=prev.label;
                    elseif prev.dist<nn(n).dist
                        aux = prev;
                        prev = nn(n);
                        nn(n).dist = aux.dist;
                        nn(n).label=aux.label;
                    end
                end
            end
        end
        labels_count = zeros(1,size(X_train,2));
        for it=1:size(nn,2)
            labels_count = labels_count+ismember(labels,nn(it).label);
        end
        ind2 = find(ismember(labels_count,max(labels_count)),1, 'first');
        confusion(ind1,ind2) = confusion(ind1,ind2)+1;
    end
end

confusion


