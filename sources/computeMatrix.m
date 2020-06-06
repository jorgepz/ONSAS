% Copyright (C) 2019, Jorge M. Perez Zerpa, J. Bruno Bazzano, Jean-Marc Battini, Joaquin Viera, Mauricio Vanzulli  
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

% ======================================================================
function systemDeltauMatrix = computeMatrix( Conec, secGeomProps, coordsElemsMat, hyperElasParamsMat, KS, Uk, neumdofs, numericalMethodParams , bendStiff, massMat, dampingMat, booleanConsistentMassMat )

  [ solutionMethod, stopTolDeltau,   stopTolForces, ...
  stopTolIts,     targetLoadFactr, nLoadSteps,    ...
  incremArcLen, deltaT, deltaNW, AlphaNW, finalTime ] ...
      = extractMethodParams( numericalMethodParams ) ;

  tiem=time();

  % computes static tangent matrix
  [~, KT ] = assemblyFintVecTangMat( Conec, secGeomProps, coordsElemsMat, hyperElasParamsMat, KS, Uk, bendStiff, 2 ) ;

  tiempoAssembly = time() - tiem ;

  % extracts matrix entries
  if solutionMethod == 1 || solutionMethod == 2
    systemDeltauMatrix = KT ( neumdofs, neumdofs ) ;
    
  elseif solutionMethod == 3
  
  %~ KT ( neumdofs, neumdofs )
  %~ massMat(neumdofs, neumdofs ) 
  %~ stop
    systemDeltauMatrix = KT ( neumdofs, neumdofs ) + 1/( AlphaNW*deltaT^2) * massMat(neumdofs, neumdofs) ...
      + deltaNW / ( AlphaNW*deltaT) * dampingMat(neumdofs, neumdofs)  ;

%~ neumdofs
%~ size(systemDeltauMatrix)
%~ stop    
  end
