function [A,R] = generateMat( p1, p2)
%generateMat returns the matrix prepared for applying to DLT
    % p1 and p2
    x1 = p1(1);
    x2 = p1(2);
    x3 = 1;
    y1 = p2(1);
    y2 = p2(2);
    y3 = 1;
    
    A = [0,0,0,-y3*x1, -y3*x2, -y3*x3, y2*x1, y2*x2; y3*x1, y3*x2, y3*x3, 0,0,0, -y1*x1, -y1*x2];
    R = [-y2*x3;y1*x3];
end

