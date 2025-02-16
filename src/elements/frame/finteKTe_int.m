% Copyright 2023, ONSAS Authors (see documentation)
%
% This file is part of ONSAS.
%
% ONSAS is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% ONSAS is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with ONSAS.  If not, see <https://www.gnu.org/licenses/>.
%
% ======================================================================
% KT and Finte computation
% ======================================================================

global ne
global secFinteVec
global elemFuncs

KbendXZ = zeros(4,4) ;
finte 	= zeros(4,1) ;

elemCrossSecParamsVec = elemCrossSecParams{2} ;

RXYXZ = eye(4) ; RXYXZ(2,2) = -1; RXYXZ(4,4) = -1;

% Elem Gauss points
[xge, we] = gaussPointsAndWeights(ne) ;
pgeVec = ( l/2  * xge' + l/2 ) ;	

for j = 1:length(we)
	secFint 	= 0 ;
	secKTe 		= 0 ;
	pge 			= pgeVec(j) ; 
	
	% Bending intern functions second derivative
	B = bendingInterFuns(pge, l, 2)*RXYXZ ;
	
	if intBool == 1
		% Tangent stiffness matrix
		secKTe = quadv('secKT', -elemCrossSecParamsVec(2)/2, elemCrossSecParamsVec(2)/2, [], [], ...
														 elemCrossSecParamsVec(1), elemCrossSecParamsVec(2), B, R(LocBendXZdofs,LocBendXZdofs), ...
														 Ut(LocBendXZdofs), modelParams, modelName) ;
		KbendXZ = l/2*( B'*secKTe*B*we(j) ) + KbendXZ ;	
	end
	
	secFint = quadv('secFint', -elemCrossSecParamsVec(2)/2, elemCrossSecParamsVec(2)/2, [], [], ...
															elemCrossSecParamsVec(1), elemCrossSecParamsVec(2), B, R(LocBendXZdofs,LocBendXZdofs), ...
															Ut(LocBendXZdofs), modelParams, modelName) ;
	finte = l/2*secFint*we(j) + finte ;	
	
	% ==============================
	if matFintBool == 1 && ( elem == elemFuncs || elem == elemFuncs+1 )
		if elem == elemFuncs
			secFinteVec(1,end+1) = secFint(4) ;
		else
			secFinteVec(2, (size(secFinteVec,2)-ne)+j ) = secFint(4) ;
		end	
	end
		
		
	% ==============================
													
end % endfor we
