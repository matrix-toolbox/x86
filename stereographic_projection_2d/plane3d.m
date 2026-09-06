function pr3(v0, v1, v2)
%   for Ulam's spiral and 3d-projection
    x0=v0(1);y0=v0(2);z0=v0(3);
    x1=v1(1);y1=v1(2);z1=v1(3);
    x2=v2(1);y2=v2(2);z2=v2(3);


    A=(z1*x2-z2*x1)*y2/x2 - (y1*x2-y2*x1)*z2/x2;
    B=(z2*x1-z1*x2);
    C=(y1*x2-y2*z1);
    D=x0*(y1*z2-y2*z1)+x1*(z0*y2-z2*y0)+x2*(z1*y0-z0*y1);

    [A B C D]

end



