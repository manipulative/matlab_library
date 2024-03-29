function status = UnitTestsAll_Snirf(standalone)
global DEBUG1
global procStreamStyle
global testidx;
global logger

t_local = tic;

if ~exist('standalone','var') 
    standalone = true;
end

DEBUG1=0;
testidx=0;
procStreamStyle = 'snirf';

% Clean up before we start
CleanUp(standalone);
logger = InitLogger(logger, 'UnitTestsAll_Snirf');

if standalone
    % System test runs for a long time. We want to be able to interrupt it with
    % Ctrl-C and have it automatically do the cleanup that the test would normally
    % do if it ran to completion
    cleanupObj = onCleanup(@()userInterrupt_Callback(standalone));
end

lpf = [00.30, 00.70, 01.00];
std = [05.00, 10.00, 15.00, 20.00];


groupFolders = FindUnitTestsFolders();
nGroups = length(groupFolders);
status = zeros(4, nGroups);
for ii=1:nGroups
    irow = 1;
    status(irow,ii) = unitTest_DefaultProcStream('.snirf', groupFolders{ii}); irow=irow+1;
    for jj=1:length(lpf)
        status(irow,ii) = unitTest_BandpassFilt_LPF('.snirf', groupFolders{ii}, lpf(jj)); irow=irow+1;
    end
    for kk=1:length(std)
        status(irow,ii) = unitTest_MotionArtifact_STDEV('.snirf', groupFolders{ii}, std(kk)); irow=irow+1;
    end
end

logger.Write('\n');

testidx = 0;
for ii=1:size(status,2)
    for jj=1:size(status,1)
        testidx=testidx+1;
        if status(jj,ii)~=0
            logger.Write(sprintf('#%d - Unit test %d,%d did NOT pass.\n', testidx, jj, ii));
        else
            logger.Write(sprintf('#%d - Unit test %d,%d passed.\n', testidx, jj, ii));
        end
    end
end
logger.Write('\n');

testidx=[];
procStreamStyle=[];

toc(t_local);



% ---------------------------------------------------
function userInterrupt_Callback(standalone)
fprintf('UnitTestsAll_Snirf cleaning\n')
userInterrupt(standalone)





