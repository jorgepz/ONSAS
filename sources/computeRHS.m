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

function [systemDeltauRHS, FextG, fs, Stress] = computeRHS( Conec, ...
  crossSecsParams, coordsElemsMat, materialsParams, KS, constantFext, ...
  variableFext, userLoadsFilename, currLoadFactor, nextLoadFactor, ...
  numericalMethodParams, neumdofs, nodalDispDamping, ...
  booleanConsistentMassMat, booleanCSTangs, ...
  Ut, Udott, Udotdott, Utp1, Udottp1, Udotdottp1, elementsParams ) 

  [ solutionMethod, stopTolDeltau,   stopTolForces, ...
  stopTolIts,     targetLoadFactr, nLoadSteps,    ...
  incremArcLen, deltaT, deltaNW, AlphaNW, alphaHHT, finalTime ] ...
      = extractMethodParams( numericalMethodParams ) ;

  fs = assembler ( ...
    Conec, crossSecsParams, coordsElemsMat, materialsParams, KS, Utp1, 1, Udottp1, ...
    Udotdottp1, nodalDispDamping, solutionMethod, booleanConsistentMassMat, booleanCSTangs, elementsParams ) ;
  
  Fint = fs{1} ;  Fvis =  fs{2};  Fmas = fs{3} ;  

  if solutionMethod == 1

    FextG  = computeFext( constantFext, variableFext, nextLoadFactor, userLoadsFilename ) ;
    systemDeltauRHS = - ( Fint(neumdofs) - FextG(neumdofs) ) ;

  elseif solutionMethod == 2
    
    if norm(constantFext)>0 || ~(strcmp( userLoadsFilename , '')),
      error('load case not implemented yet for Arc-Length method');
    end
    
    FextG  = computeFext( constantFext, variableFext, nextLoadFactor, userLoadsFilename ) ;
    
    % incremental displacement
    systemDeltauRHS = [ -(Fint(neumdofs)-FextG(neumdofs))  variableFext(neumdofs) ] ;

  elseif solutionMethod == 3

    FextG = computeFext( constantFext, variableFext, nextLoadFactor, userLoadsFilename ) ;
    
    rhat      =   Fint ( neumdofs ) ...
                + Fvis ( neumdofs ) ...
                + Fmas ( neumdofs ) ...
                - FextG( neumdofs ) ;
                
    systemDeltauRHS = -rhat ;

  elseif solutionMethod == 4
      
    fs = assembler ( ...
      Conec, crossSecsParams, coordsElemsMat, materialsParams, KS, Ut, 1, Udott, ...
      Udotdott, nodalDispDamping, solutionMethod, booleanConsistentMassMat, booleanCSTangs, elementsParams ) ;
    
    Fintt = fs{1} ;  Fvist =  fs{2};  Fmast = fs{3} ;  

    FextG  = computeFext( constantFext, variableFext, nextLoadFactor, userLoadsFilename ) ;
    FextGt = computeFext( constantFext, variableFext, currLoadFactor, userLoadsFilename ) ;
                      
    rhat   =  ( 1 + alphaHHT ) * ( ...
                + Fint  ( neumdofs ) ...
                + Fvis  ( neumdofs ) ...
                - FextG ( neumdofs ) ...
              ) ...
              ...
              - alphaHHT * ( ...
                + Fintt ( neumdofs ) ...
                + Fvist ( neumdofs ) ...
                - FextGt( neumdofs ) ...
                ) ...
              ...
              + Fmas    ( neumdofs ) ;
                
    systemDeltauRHS = -rhat ;
    
  end
    
