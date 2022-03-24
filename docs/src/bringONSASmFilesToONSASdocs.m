%md function used to conver .m files in the ONSAS repo to .md files in this repo
%md this function is executed from the makeAndPreview.sh file or can also be
%md executed from the bash terminal: `octave --eval "bringONSASmFilesToONSAS_docs('$ONSAS_PATH')"`
%md where \$ONSAS_PATH is the environment variable with the directory of ONSAS.m

function bringONSASmFilesToONSASdocs
  disp('running bringONSASmFilesToONSASdocs script...')
  dirONSASdocs = './' ;
  dirONSASm     = '../../'          ;

  addpath( genpath( '../../src/' ));

  ONSASmFiles = {   'examples/staticVonMisesTruss/onsasExample_staticVonMisesTruss.m' ...
                  ; 'examples/uniformCurvatureCantilever/onsasExample_uniformCurvatureCantilever.m' ...
                  ; 'examples/uniaxialExtension/uniaxialExtension.m' ...
                  ; 'examples/semiSphereWithInclusion/semiSphereWithInclusion.m' ...
                } ;

  MDFiles    = {   'staticVonMisesTruss.md' ...
                 ; 'cantileverBeam.md' ...
                 ; 'uniaxialExtension.md' ...
                 ; 'semiSphereWithInclusion.md' ...
                } ;

  fprintf( 'converting:\n' )
  for i=1:length( ONSASmFiles )
    fprintf([ '  - ' ONSASmFiles{i} '\n' ])
    m2md( [ dirONSASm ONSASmFiles{i} ] , [ dirONSASdocs MDFiles{i} ] , 1, 1 ) ;
  end
