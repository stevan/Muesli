use strict;
use warnings;
use ExtUtils::MakeMaker 6.30;

my %WriteMakefileArgs = (
    'NAME'               => 'Muesli',
    'VERSION'            => '0.01',    
    'DISTNAME'           => 'Muesli',      
    'ABSTRACT'           => 'Like Sereal, but not as good',
    'AUTHOR'             => 'Stevan Little',
    'BUILD_REQUIRES'     => {},
    'CONFIGURE_REQUIRES' => {
        'ExtUtils::MakeMaker' => '6.30'
    },
    'EXE_FILES'          => [],
    'LICENSE'            => 'perl',
    'NORECURS'           => 1,
    'PREREQ_PM'  => {
        # core ....
        'B'                  => 0, 
        'Scalar::Util'       => 0,
        # tests ..
        'Test::More'         => 0,        
    },
    'clean'              => { FILES => 'cover_db/ nytprof/ nytprof.out' },
    'test'               => { RECURSIVE_TEST_FILES => 1 },
);

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
