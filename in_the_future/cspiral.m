function cspiral(M)
% 2020-09-07
% wojciech bruzda @ IFUJ | wojtek [at] bitologia.org
%
% spiral around circle in
% polar parametrisation P --> P(r, alpha)
% to be used as a path generator for an x86-assembly demo

	hold all;
	axis("square");

	A = 1/sqrt(M); % amplitude (around base-circle)
	               % small amplitudes seem to be visually symmetric

	for a=0:0.001:2*pi
		r = 1 - sin(M*a) * cos(M*a) * A;
		plot(r * cos(a), r * sin(a), ".b");     % spiral
		plot(cos(a), sin(a), ".g");             % circle (base)
	end



end

