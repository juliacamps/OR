function H = DLT( P1,P2 )
%DLT is the Direct Linear Transformation
    A = [];
    R = [];
    for i = 1:size(P1,1)
        [A1,R1] = generateMat( P1(i,:), P2(i,:));
        A = cat(1,A,A1);
        R = cat(1,R,R1);
    end
    
    AR = [A R];
    if rank(A) == rank(AR)
        h = A\R;
    else
        msg = 'Ranks are different';
        error(msg)
        exit(1);
    end
    h = [h;[1]]';
    H = [h(1:3);h(4:6);h(7:9)]

end

