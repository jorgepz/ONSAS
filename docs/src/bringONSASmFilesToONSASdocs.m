%md function used to conver .m files in the ONSAS repo to .md files in this repo
%md this function is executed from the makeAndPreview.sh file or can also be
%md executed from the bash terminal: `octave --eval "bringONSASmFilesToONSAS_docs('$ONSAS_PATH')"`
%md where \$ONSAS_PATH is the environment variable with the directory of ONSAS.m

function bringONSASmFilesToONSASdocs
  disp('running bringONSASmFilesToONSASdocs script...')
  dirONSASdocs = './examples/' ;
  dirONSASm     = '../../examples/'          ;

  addpath( genpath( '../../src/examples/' ));

  ONSASmFiles = {   'static_von_mises_truss/static_von_mises_truss.m' ...
                  ; 'uniformCurvatureCantilever/uniformCurvatureCantilever.m' ...
                  ; 'uniaxialExtension/uniaxialExtension.m' ...
                  ; 'uniaxialCompression/uniaxialCompression.m' ...
                  ; 'springMass/springMass.m' ...
                  ; 'linearAerodynamics/linearAerodynamics.m' ...
                  ; 'nonLinearAerodynamics/nonLinearAerodynamics.m' ...
                  ; 'beamLinearVibration/beamLinearVibration.m' ...
                  ; 'linearCylinderPlaneStrain/linearCylinderPlaneStrain.m' ...
                } ;

  MDFiles    = {   'staticVonMisesTruss.md' ...
                 ; 'cantileverBeam.md' ...
                 ; 'uniaxialExtension.md' ...
                 ; 'uniaxialCompression.md' ...
                 ; 'springMass.md' ...
                 ; 'linearAerodynamics.md' ...
                 ; 'nonLinearAerodynamics.md' ...
                 ; 'beamLinearVibration.md' ...
                 ; 'linearCylinderPlaneStrain.md' ...
                } ;

  if exist( dirONSASdocs ) ~= 7
    fprintf('creating examples dir...\n')
    mkdir( './examples/' );
  end

  fprintf( 'converting:\n' )
  for i=1:length( ONSASmFiles )
    fprintf([ '  - ' ONSASmFiles{i} '\n' ])
    m2md( [ dirONSASm ONSASmFiles{i} ] , [ dirONSASdocs MDFiles{i} ] , 1, 1 ) ;
  end


  movefile('../../examples/springMass/output/springMassCheckU.png','./assets') 
