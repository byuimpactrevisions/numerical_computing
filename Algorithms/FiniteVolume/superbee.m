function [x u T] = superbee(J,CFL,N,a)
%[x u T] = superbee(J,CFL,N,a)
%

xStep = 1/(J-1);
x = 0:xStep:1;
T = 0;
u = exp(-((x-.2).^2)/.005) + double((x<.6) & (x>.5));
v = u;
w = u;
d = a>0;

for nn = 1:N
    timeStep = CFL*xStep/abs(a);
    T = T + timeStep;
    nu = a*timeStep/xStep;
    deltaU = diff(u);
    %compute the slope using the superbee operation
    for jj = 1:J-2
        sigma1 = .5*(sign(deltaU(jj))+sign(deltaU(jj+1)))*...
            min(abs(deltaU(jj)),abs(2*deltaU(jj+1)))/xStep;
        sigma2 = .5*(sign(deltaU(jj))+sign(deltaU(jj+1)))*...
            min(abs(2*deltaU(jj)),abs(deltaU(jj+1)))/xStep;
        slope(jj+1) = .5*(sign(sigma1)+sign(sigma2))*...
            max(abs(sigma1),abs(sigma2));
    end
    %initializes for periodic boundary conditions
    sigma1 = .5*(sign(deltaU(J-1))+sign(deltaU(1)))*...
        min(abs(deltaU(J-1)),abs(2*deltaU(1)))/xStep;
    sigma2 = .5*(sign(deltaU(J-1))+sign(deltaU(1)))*...
        min(abs(2*deltaU(J-1)),abs(deltaU(1)))/xStep;
    slope(J) = .5*(sign(sigma1)+sign(sigma2))*...
        max(abs(sigma1),abs(sigma2));
    slope(1) = slope(J);
    
    %compute the fluxes
    for jj = 2:J-1
        f(jj) = d*a*(u(jj)+.5*(sign(a)-a*timeStep/xStep)*xStep*slope(jj))...
            +(1-d)*a*(u(jj+1)+.5*(sign(a)-a*timeStep/xStep)*xStep*slope(jj+1));
    end
    %periodic boundary conditions
    f(J) = d*a*(u(J)+.5*(sign(a)-a*timeStep/xStep)*xStep*slope(J))...
        +(1-d)*a*(u(2)+.5*(sign(a)-a*timeStep/xStep)*xStep*slope(2));
    f(1) = f(J);
    
    for jj = 2:J-1
        u(jj) = u(jj) - (timeStep/xStep)*(f(jj)-f(jj-1));
        %upwind scheme for comparison
        v_new(jj) = v(jj) - d*nu*(v(jj)-v(jj-1))...
            - (1-d)*nu*(v(jj+1)-v(jj));
        %lax-wendroff also for comparison
        w_new(jj) = w(jj) - .5*nu*(w(jj+1)-w(jj-1)) + ...
            .5*(nu^2)*(w(jj-1)-2*w(jj)+w(jj+1));
    end
    %periodic boundary conditions
    u(J) = u(J) - (timeStep/xStep)*(f(J)-f(J-1));
    u(1) = u(J);
    v_new(J) = v(J) - d*nu*(v(J)-v(J-1)) - (1-d)*nu*(v(2)-v(J));
    v_new(1) = v_new(J);
    v = v_new;
    w_new(J) = w(J) - .5*nu*(w(2)-w(J-1)) + .5*(nu^2)*(w(J-1)-2*w(J)+w(2));
    w_new(1) = w_new(J);
    w = w_new;
    
end
%analytic solution to advection problem
analytic = exp(-((x-.2-a*T).^2)/.005) + double(((x-a*T) > .5) & ((x-a*T) < .6));

%plot and compare analytic & numeric solutions
figure
plot(x,u,'b.')
hold on
plot(x,analytic,'r')
% plot(x,v,'g*')
% plot(x,w,'k*')
